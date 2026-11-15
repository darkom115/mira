-- =============================================================
--  MIRA — Actualización: ADMINISTRADORES
--  Permite que los administradores borren reportes (y sus fotos)
--  desde la app, después de iniciar sesión.
--
--  ANTES de correr esto, crea tu usuario:
--    Authentication → Users → Add user → Create new user
--    (pon tu correo y una contraseña, y marca "Auto Confirm User")
--
--  Luego cambia el correo de la última línea por el tuyo y corre
--  TODO en: SQL Editor → New query → Run   (solo una vez)
-- =============================================================


-- 1) Lista de administradores (solo guarda el id del usuario)
create table public.admins (
  user_id uuid primary key references auth.users (id) on delete cascade
);
alter table public.admins enable row level security;
-- Sin políticas: nadie puede leer ni cambiar esta tabla desde la app.


-- 2) Función que responde: ¿el usuario actual es administrador?
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


-- 3) Los administradores pueden BORRAR reportes
grant delete on public.reportes to authenticated;

create policy "Admins borran reportes"
  on public.reportes for delete
  to authenticated
  using (public.es_admin());


-- 4) Los administradores pueden borrar fotos de "evidencias"
--    (para borrar, Supabase pide permiso de ver y de borrar)
create policy "Admins ven evidencias"
  on storage.objects for select
  to authenticated
  using (bucket_id = 'evidencias' and public.es_admin());

create policy "Admins borran evidencias"
  on storage.objects for delete
  to authenticated
  using (bucket_id = 'evidencias' and public.es_admin());


-- 5) Tú eres el administrador. CAMBIA el correo por el tuyo:
insert into public.admins (user_id)
select id from auth.users where email = 'TU-CORREO@ejemplo.com';
