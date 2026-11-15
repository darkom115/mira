-- =============================================================
--  MIRA — PAPELERA (borrado reversible)
--  "Eliminar" en el panel ya no borra: manda a la papelera.
--  El borrado definitivo se hace aparte, a propósito.
--
--  Copia TODO en: SQL Editor → New query → Run   (solo una vez)
-- =============================================================

-- 1) Marca de papelera: null = activo, con fecha = en la papelera
alter table public.reportes add column borrado_el timestamptz;

-- 2) El público nunca ve lo que está en la papelera
drop policy "Todos ven los casos publicados" on public.reportes;

create policy "Todos ven los casos publicados"
  on public.reportes for select
  to anon, authenticated
  using (estado in ('no_identificado', 'ifo', 'datos_insuficientes') and borrado_el is null);

-- (Los administradores siguen viéndolo todo por su propia política,
--  así que la papelera solo la ves tú desde el panel.)
