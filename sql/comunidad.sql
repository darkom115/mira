-- =============================================================
--  MIRA — Actualización: COMUNIDAD
--  Cuentas de usuario, votos (real / falso), aportes (comentarios)
--  y permisos para el panel de administración.
--
--  Requiere haber corrido antes admin.sql (ya lo hiciste).
--  Copia TODO en: SQL Editor → New query → Run   (solo una vez)
-- =============================================================


-- 1) PERFILES: el alias público de cada usuario
create table public.perfiles (
  user_id uuid primary key default auth.uid() references auth.users (id) on delete cascade,
  alias   text not null check (alias ~ '^[A-Za-z0-9_]{3,20}$'),
  creado  timestamptz not null default now()
);
-- No puede haber dos alias iguales (sin importar mayúsculas)
create unique index perfiles_alias_idx on public.perfiles (lower(alias));

alter table public.perfiles enable row level security;
grant select on public.perfiles to anon, authenticated;
grant insert on public.perfiles to authenticated;

create policy "Todos ven los alias"
  on public.perfiles for select to anon, authenticated using (true);

-- Cada quien crea solo SU perfil. Nadie más puede usar "darkom" en su alias.
create policy "Cada quien crea su perfil"
  on public.perfiles for insert to authenticated
  with check (
    user_id = (select auth.uid())
    and (lower(alias) not like '%darkom%' or (select public.es_admin()))
  );


-- 2) VOTOS: un voto por usuario y por reporte
create table public.votos (
  reporte_id uuid not null references public.reportes (id) on delete cascade,
  user_id    uuid not null default auth.uid() references auth.users (id) on delete cascade,
  voto       text not null check (voto in ('real', 'falso')),
  creado     timestamptz not null default now(),
  primary key (reporte_id, user_id)
);

alter table public.votos enable row level security;
grant select, insert, update, delete on public.votos to authenticated;

create policy "Cada quien maneja su voto"
  on public.votos for all to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

-- Conteo público de votos de un reporte (sin revelar quién votó qué)
create function public.votos_de(p_reporte uuid)
returns json
language sql
stable
security definer
set search_path = ''
as $$
  select json_build_object(
    'real',  count(*) filter (where voto = 'real'),
    'falso', count(*) filter (where voto = 'falso'),
    'mio',   max(voto) filter (where user_id = auth.uid())
  )
  from public.votos
  where reporte_id = p_reporte;
$$;
revoke all on function public.votos_de(uuid) from public;
grant execute on function public.votos_de(uuid) to anon, authenticated;


-- 3) COMENTARIOS (aportes de la comunidad)
create table public.comentarios (
  id         uuid primary key default gen_random_uuid(),
  reporte_id uuid not null references public.reportes (id) on delete cascade,
  user_id    uuid not null default auth.uid() references public.perfiles (user_id) on delete cascade,
  texto      text not null check (char_length(texto) between 3 and 500),
  creado     timestamptz not null default now()
);
create index comentarios_reporte_idx on public.comentarios (reporte_id, creado);

alter table public.comentarios enable row level security;
grant select on public.comentarios to anon, authenticated;
grant insert, delete on public.comentarios to authenticated;

create policy "Todos leen los aportes"
  on public.comentarios for select to anon, authenticated using (true);

create policy "Usuarios con cuenta aportan"
  on public.comentarios for insert to authenticated
  with check (user_id = (select auth.uid()));

-- Cada quien borra lo suyo; los administradores borran cualquiera
create policy "Borrar aportes propios o como admin"
  on public.comentarios for delete to authenticated
  using (user_id = (select auth.uid()) or (select public.es_admin()));


-- 4) Que cada usuario pueda ELIMINAR SU PROPIA CUENTA
--    (se borran también su perfil, sus votos y sus aportes)
create function public.eliminar_mi_cuenta()
returns void
language sql
security definer
set search_path = ''
as $$
  delete from auth.users where id = auth.uid();
$$;
revoke all on function public.eliminar_mi_cuenta() from public, anon;
grant execute on function public.eliminar_mi_cuenta() to authenticated;


-- 5) PANEL DE ADMINISTRACIÓN: los admins ven TODOS los reportes
--    (también pendientes y rechazados) y pueden cambiarles el estado
grant update on public.reportes to authenticated;

create policy "Admins ven todos los reportes"
  on public.reportes for select to authenticated
  using ((select public.es_admin()));

create policy "Admins editan reportes"
  on public.reportes for update to authenticated
  using ((select public.es_admin()))
  with check ((select public.es_admin()));
