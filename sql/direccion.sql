-- =============================================================
--  MIRA — Actualización: RUMBO DEL OBJETO
--  Agrega la columna "direccion" (hacia dónde se movía).
--  Copia TODO en: SQL Editor → New query → Run   (solo una vez)
-- =============================================================
--
--  Valores posibles (puntos cardinales en inglés, como en una brújula):
--    N, NE, E, SE, S, SW, W, NW  → hacia dónde iba
--    estacionario                → estaba quieto
--    (vacío)                     → la persona no sabe

alter table public.reportes
  add column direccion text
  check (direccion in ('N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW', 'estacionario'));
