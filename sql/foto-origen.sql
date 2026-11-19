-- =============================================================
--  MIRA — De dónde salió la foto
--
--  El índice de evidencia sumaba un punto por "tener foto", sin
--  preguntar de quién era la foto. Pero la mayoría de las fotos del
--  archivo son de prensa o ilustraciones que se añadieron como
--  contexto al cargar el caso, no material del testigo.
--
--  El resultado: casos que muestran un punto de respaldo que no les
--  corresponde. Esto lo separa:
--
--    testigo      → la tomó quien vio el fenómeno, o se capturó ahí
--    prensa       → foto de una nota, una agencia o un archivo
--    ilustracion  → dibujo o recreación, no es del hecho
--    (vacío)      → todavía sin clasificar
--
--  Solo la foto del testigo cuenta como evidencia. Las demás se
--  siguen mostrando, pero con su etiqueta, como contexto.
--
--  Correr una sola vez en: SQL Editor → New query → Run
-- =============================================================


-- 1) El campo nuevo. Se queda vacío a propósito: vacío significa
--    "todavía nadie lo ha clasificado", y eso es verdad hoy.
alter table public.reportes
  add column if not exists foto_origen text;

-- 2) Solo se aceptan los tres valores previstos (o vacío).
do $$
begin
  if not exists (
    select 1 from pg_constraint where conname = 'reportes_foto_origen_check'
  ) then
    alter table public.reportes
      add constraint reportes_foto_origen_check
      check (foto_origen is null or foto_origen in ('testigo', 'prensa', 'ilustracion'));
  end if;
end $$;

-- 3) Un caso sin foto no necesita este dato: lo dejamos vacío.
update public.reportes
   set foto_origen = null
 where foto_url is null;

-- =============================================================
--  Después de correr esto
--
--  Los casos que ya tienen foto quedan "sin clasificar", así que
--  dejan de sumar ese punto de evidencia hasta que alguien diga de
--  dónde salió cada foto. Eso es lo correcto: no se puede acreditar
--  una evidencia que no sabemos de quién es.
--
--  Para clasificarlas se usa el panel de administración, caso por
--  caso. Quien cargó el caso es quien sabe de dónde sacó la foto.
--
--  Para ver cuántas faltan:
--    select coalesce(foto_origen, 'sin clasificar') as origen, count(*)
--      from public.reportes
--     where foto_url is not null
--     group by 1 order by 2 desc;
-- =============================================================
