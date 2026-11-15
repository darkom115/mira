-- =============================================================
--  MIRA — Actualización: MODERACIÓN
--  Para tu proyecto open-sky-archive que YA tiene la tabla creada.
--  Copia TODO en: SQL Editor → New query → Run   (solo una vez)
-- =============================================================
--
--  Cómo quedan los estados de un reporte:
--    pendiente    → recién enviado. NADIE lo ve en la app.
--    sin explicar → lo aprobaste. Se ve en el globo.
--    explicado    → lo aprobaste y encontraste qué era (dron, satélite…).
--                   Se ve en el globo con tu "dictamen".
--    rechazado    → falso, spam u ofensivo. NADIE lo ve.


-- 1) Columna nueva para escribir qué era el objeto (tu dictamen)
alter table public.reportes
  add column explicacion text check (char_length(explicacion) <= 500);


-- 2) Nuevos estados
alter table public.reportes drop constraint reportes_estado_check;

-- Los reportes de prueba que ya tenías pasan a "sin explicar" (visibles)
update public.reportes set estado = 'sin explicar' where estado in ('sin verificar', 'verificado');
update public.reportes set estado = 'rechazado'    where estado = 'falso';

alter table public.reportes
  add constraint reportes_estado_check
  check (estado in ('pendiente', 'sin explicar', 'explicado', 'rechazado'));

-- Todo reporte nuevo entra como pendiente
alter table public.reportes alter column estado set default 'pendiente';


-- 3) Reglas de seguridad nuevas
-- El público solo ve los reportes aprobados
drop policy "Todos pueden ver reportes" on public.reportes;
create policy "Todos ven solo reportes aprobados"
  on public.reportes for select
  to anon, authenticated
  using (estado in ('sin explicar', 'explicado'));

-- Los reportes nuevos solo pueden entrar como pendientes
drop policy "Todos pueden crear reportes sin verificar" on public.reportes;
create policy "Todos crean reportes pendientes"
  on public.reportes for insert
  to anon, authenticated
  with check (estado = 'pendiente' and explicacion is null);
