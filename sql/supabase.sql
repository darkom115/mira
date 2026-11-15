-- =============================================================
--  MIRA — Mapa de Incidentes y Reportes Anómalos
--  Base de datos COMPLETA
--  Solo para un proyecto NUEVO de Supabase.
--  (Tu proyecto actual ya está creado: para él usa moderacion.sql)
--
--  Copia TODO en: Supabase → SQL Editor → New query → Run
-- =============================================================
--
--  Estados de un reporte:
--    pendiente ........... recién enviado, nadie lo ve
--    no_identificado ..... publicado, sin explicación
--    ifo ................. publicado, identificado (dron, satélite…)
--    datos_insuficientes . publicado, no alcanza para concluir
--    descartado .......... falso o spam, nadie lo ve


-- 1) Tabla de reportes (cada fila = un expediente MIRA-AAAA-XXXX)
create table public.reportes (
  id          uuid primary key default gen_random_uuid(),
  creado      timestamptz not null default now(),
  -- Qué viste
  categoria   text not null default 'sin_clasificar'
              check (categoria in ('fani', 'criptido_alado', 'bestia_atmosferica', 'varillas', 'serpiente', 'sin_clasificar')),
  forma       text check (forma in ('luz', 'esfera', 'disco', 'triangulo', 'cilindro', 'ovalo',
                                    'formacion', 'cambiante', 'irregular', 'otra')),
  descripcion text not null check (char_length(descripcion) <= 1000),
  -- Dónde y cuándo
  lugar       text not null check (char_length(lugar) <= 200),
  lat         double precision not null check (lat between -90 and 90),
  lng         double precision not null check (lng between -180 and 180),
  fecha       timestamptz not null,
  momento     text check (momento in ('dia', 'crepusculo', 'noche')),
  -- Circunstancias (de aquí sale la clasificación de Hynek)
  distancia   text check (distancia in ('lejos', 'cerca')),
  efecto      text check (efecto in ('ninguno', 'rastro', 'ocupante')),
  duracion    text check (duracion in ('segundos', 'min1a5', 'min5a30', 'mas30')),
  testigos    smallint check (testigos between 1 and 999),
  direccion   text check (direccion in ('N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW', 'estacionario')),
  -- Evidencia
  foto_url    text,
  youtube_id  text check (youtube_id ~ '^[A-Za-z0-9_-]{11}$'),
  radar       boolean not null default false,
  -- Estado del caso
  estado      text not null default 'pendiente'
              constraint reportes_estado_check
              check (estado in ('pendiente', 'no_identificado', 'ifo', 'datos_insuficientes', 'descartado')),
  explicacion text check (char_length(explicacion) <= 500),
  idioma      text not null default 'es' check (idioma in ('es', 'en'))
);

create index reportes_fecha_idx on public.reportes (fecha desc);


-- 2) Permisos: la app solo puede VER y CREAR reportes
grant usage on schema public to anon, authenticated;
grant select, insert on public.reportes to anon, authenticated;


-- 3) Reglas de seguridad por fila (RLS)
alter table public.reportes enable row level security;

create policy "Todos ven los casos publicados"
  on public.reportes for select
  to anon, authenticated
  using (estado in ('no_identificado', 'ifo', 'datos_insuficientes'));

create policy "Todos crean reportes pendientes"
  on public.reportes for insert
  to anon, authenticated
  with check (estado = 'pendiente' and explicacion is null);


-- 4) Carpeta de fotos "evidencias": pública, máx. 2 MB, solo JPG
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('evidencias', 'evidencias', true, 2097152, array['image/jpeg'])
on conflict (id) do update
  set public = true, file_size_limit = 2097152, allowed_mime_types = array['image/jpeg'];

create policy "Todos pueden subir evidencias"
  on storage.objects for insert
  to anon, authenticated
  with check (bucket_id = 'evidencias');


-- 5) Administradores (solo guarda el id del usuario)
create table public.admins (
  user_id uuid primary key references auth.users (id) on delete cascade
);
alter table public.admins enable row level security;
-- Sin políticas: nadie puede leer ni cambiar esta tabla desde la app.


-- 6) Función que responde: ¿el usuario actual es administrador?
--    "security definer" = la función puede leer la tabla admins
--    aunque el usuario no tenga permiso directo.
create function public.es_admin()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (select 1 from public.admins where user_id = auth.uid());
$$;

revoke all on function public.es_admin() from public;
grant execute on function public.es_admin() to anon, authenticated;


-- 7) Los administradores pueden BORRAR reportes
grant delete on public.reportes to authenticated;

create policy "Admins borran reportes"
  on public.reportes for delete
  to authenticated
  using (public.es_admin());


-- 8) Los administradores pueden borrar fotos de "evidencias"
--    (para borrar, Supabase pide permiso de ver y de borrar)
create policy "Admins ven evidencias"
  on storage.objects for select
  to authenticated
  using (bucket_id = 'evidencias' and public.es_admin());

create policy "Admins borran evidencias"
  on storage.objects for delete
  to authenticated
  using (bucket_id = 'evidencias' and public.es_admin());


-- Tú eres el administrador. Crea antes tu usuario en Authentication → Users
-- y CAMBIA el correo por el tuyo:
insert into public.admins (user_id)
select id from auth.users where email = 'TU-CORREO@ejemplo.com';


-- ===================== COMUNIDAD =====================
-- PERFILES: el alias público de cada usuario
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


-- ===================== PAPELERA =====================
-- Marca de papelera: null = activo, con fecha = en la papelera
alter table public.reportes add column borrado_el timestamptz;

-- 2) El público nunca ve lo que está en la papelera
drop policy "Todos ven los casos publicados" on public.reportes;

create policy "Todos ven los casos publicados"
  on public.reportes for select
  to anon, authenticated
  using (estado in ('no_identificado', 'ifo', 'datos_insuficientes') and borrado_el is null);

-- (Los administradores siguen viéndolo todo por su propia política,
--  así que la papelera solo la ves tú desde el panel.)


-- ===================== ANTISPAM =====================
-- Marca de revisión: el sistema avisa por qué conviene mirar un caso
alter table public.reportes add column revisar text;


-- 3) Registro de envíos, solo para frenar el spam.
--    NO guarda la dirección IP: guarda una huella irreversible de ella.
create table public.envios (
  huella text not null,
  creado timestamptz not null default now()
);
create index envios_creado_idx on public.envios (creado desc);
alter table public.envios enable row level security;
-- Sin políticas: nadie puede leerla ni escribirla desde la app.
-- Solo la función de abajo la toca.


-- 4) Antes de guardar un caso: límite por hora y aviso de duplicados
create function public.revisar_envio()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  ip      text;
  v_huella text;
  recientes int;
begin
  -- La IP llega en las cabeceras de la petición; la convertimos en huella
  ip := split_part(coalesce(
          (current_setting('request.headers', true)::json ->> 'x-forwarded-for'),
          'desconocida'), ',', 1);
  v_huella := md5('mira-salt-2026|' || ip);

  -- Máximo 5 envíos por hora desde el mismo lugar
  select count(*) into recientes
    from public.envios e
   where e.huella = v_huella
     and e.creado > now() - interval '1 hour';

  if recientes >= 5 then
    raise exception 'limite_envios'
      using hint = 'Has enviado demasiados casos en poco tiempo. Intenta más tarde.';
  end if;

  insert into public.envios (huella) values (v_huella);
  delete from public.envios where creado < now() - interval '7 days';

  -- ¿Ya hay un caso del mismo lugar y el mismo día? Se marca para revisar.
  if exists (
    select 1 from public.reportes r
     where r.borrado_el is null
       and lower(r.lugar) = lower(new.lugar)
       and r.fecha::date = new.fecha::date
  ) then
    new.revisar := 'posible duplicado';
  end if;

  -- Descripciones muy cortas también se marcan
  if char_length(trim(new.descripcion)) < 25 then
    new.revisar := coalesce(new.revisar || ' · ', '') || 'descripción muy corta';
  end if;

  return new;
end;
$$;

create trigger revisar_envio_trigger
  before insert on public.reportes
  for each row execute function public.revisar_envio();
