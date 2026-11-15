-- =============================================================
--  MIRA — Permisos de lectura para el respaldo
--
--  El respaldo diario entra con la clave "service_role". Al crear
--  las tablas se dieron permisos a los visitantes (anon) y a los
--  usuarios registrados (authenticated), pero no a ese rol, así que
--  Supabase respondía "permission denied for table reportes".
--
--  Solo lectura: el respaldo no necesita escribir nada. Si algún día
--  hay que restaurar, eso se hace desde el editor SQL, que entra con
--  permisos completos.
--
--  Correr una sola vez en: SQL Editor → New query → Run
-- =============================================================

grant usage on schema public to service_role;

grant select on
  public.reportes,
  public.perfiles,
  public.comentarios,
  public.votos,
  public.admins
to service_role;

-- Para que las tablas que se creen más adelante también se respalden
-- sin tener que acordarse de esto.
alter default privileges in schema public grant select on tables to service_role;
