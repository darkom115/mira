-- =============================================================
--  MIRA — CURADORES
--
--  Hasta ahora solo el administrador decidía qué se publica.
--  Esto reparte la decisión: los curadores revisan la cola de
--  pendientes y votan. Cuando dos coinciden, el caso se mueve solo.
--
--  Lo que un curador PUEDE hacer:
--    - ver los casos pendientes (nadie más los ve)
--    - votar: publicar, faltan datos o descartar
--  Lo que NO puede:
--    - borrar nada, ni mandar a la papelera
--    - cambiar un caso ya resuelto
--    - cambiar su voto una vez emitido (queda registrado)
--
--  Correr una sola vez en: SQL Editor → New query → Run
-- =============================================================


-- 1) Quiénes son curadores. Igual que admins: la tabla no se lee
--    desde la app, solo a través de la función de abajo.
create table if not exists public.curadores (
  user_id uuid primary key references auth.users (id) on delete cascade,
  desde timestamptz not null default now()
);
alter table public.curadores enable row level security;


-- 2) ¿El usuario actual es curador? Los administradores también lo son.
create or replace function public.es_curador()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (select 1 from public.curadores where user_id = auth.uid())
      or exists (select 1 from public.admins    where user_id = auth.uid());
$$;

revoke all on function public.es_curador() from public;
grant execute on function public.es_curador() to anon, authenticated;


-- 3) Los votos de revisión. Uno por curador y por caso.
create table if not exists public.revisiones (
  id uuid primary key default gen_random_uuid(),
  reporte_id uuid not null references public.reportes (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  voto text not null check (voto in ('publicar', 'datos_insuficientes', 'descartar')),
  nota text,
  creado timestamptz not null default now(),
  unique (reporte_id, user_id)
);
alter table public.revisiones enable row level security;

-- Un curador ve las revisiones y añade la suya. Nadie borra ni edita:
-- el historial de quién decidió qué tiene que quedar intacto.
drop policy if exists "Curadores ven las revisiones" on public.revisiones;
create policy "Curadores ven las revisiones"
  on public.revisiones for select
  to authenticated
  using (public.es_curador());

drop policy if exists "Curadores votan una vez" on public.revisiones;
create policy "Curadores votan una vez"
  on public.revisiones for insert
  to authenticated
  with check (public.es_curador() and user_id = auth.uid());

grant select, insert on public.revisiones to authenticated;


-- 4) Los curadores ven la cola de pendientes. Solo eso: lo que está
--    en la papelera y lo ya resuelto sigue siendo cosa del admin.
drop policy if exists "Curadores ven la cola" on public.reportes;
create policy "Curadores ven la cola"
  on public.reportes for select
  to authenticated
  using (estado = 'pendiente' and borrado_el is null and public.es_curador());


-- 5) Cuántos curadores han revisado cada caso. Se muestra en el
--    expediente para que la decisión sea pública.
alter table public.reportes add column if not exists revisado_por integer not null default 0;


-- 6) La regla: dos votos iguales deciden. Lo aplica la base, no la
--    página, así que no se puede forzar desde el navegador.
create or replace function public.aplicar_revision()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_publicar  integer;
  v_datos     integer;
  v_descartar integer;
  v_total     integer;
  v_estado    text;
begin
  select
    count(*) filter (where voto = 'publicar'),
    count(*) filter (where voto = 'datos_insuficientes'),
    count(*) filter (where voto = 'descartar'),
    count(*)
  into v_publicar, v_datos, v_descartar, v_total
  from public.revisiones
  where reporte_id = new.reporte_id;

  -- Hacen falta dos coincidencias para mover un caso
  if v_publicar >= 2 then
    v_estado := 'no_identificado';
  elsif v_descartar >= 2 then
    v_estado := 'descartado';
  elsif v_datos >= 2 then
    v_estado := 'datos_insuficientes';
  end if;

  update public.reportes
  set revisado_por = v_total,
      estado = coalesce(v_estado, estado)
  where id = new.reporte_id
    and estado = 'pendiente';   -- nunca toca un caso ya resuelto

  return new;
end;
$$;

drop trigger if exists revision_decide on public.revisiones;
create trigger revision_decide
  after insert on public.revisiones
  for each row execute function public.aplicar_revision();


-- 7) Para nombrar a alguien curador, cambia el correo y corre esto.
--    La persona tiene que haber entrado al sitio al menos una vez.
-- insert into public.curadores (user_id)
-- select id from auth.users where email = 'CORREO-DEL-CURADOR@ejemplo.com'
-- on conflict do nothing;


-- 8) Comprobación
select
  (select count(*) from public.curadores)  as curadores,
  (select count(*) from public.revisiones) as revisiones;
