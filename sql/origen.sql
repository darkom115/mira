-- =============================================================
--  MIRA — Origen del caso: avistamiento o caso documentado
--
--  Hasta ahora un caso de 1955 recopilado de una hemeroteca y un
--  avistamiento de la semana pasada se veían igual. Esto los separa:
--
--    avistamiento  → lo vio quien lo reporta
--    documentado   → caso recopilado de una fuente
--
--  También saca a su propio campo la fuente, que hasta ahora venía
--  pegada al final de la descripción, y quita los "(Estado: ...)"
--  que se escribían a mano cuando no existía el campo de estado.
--
--  Correr una sola vez en: SQL Editor → New query → Run
-- =============================================================


-- 1) Copia de seguridad de las descripciones, por si hay que volver atrás.
--    Para deshacer:
--      update public.reportes r set descripcion = c.descripcion, fuente = null
--      from public.copia_descripciones c where c.id = r.id;
create table if not exists public.copia_descripciones as
  select id, descripcion from public.reportes;

alter table public.copia_descripciones enable row level security;
-- Sin políticas: nadie puede leerla desde la app.


-- 2) Los dos campos nuevos.
alter table public.reportes
  add column if not exists origen text not null default 'avistamiento',
  add column if not exists fuente text;

-- Solo se aceptan esos dos valores: evita que un error del panel
-- deje un caso con un origen inventado.
alter table public.reportes drop constraint if exists reportes_origen_valido;
alter table public.reportes add constraint reportes_origen_valido
  check (origen in ('avistamiento', 'documentado'));


-- 3) Los casos anteriores al año 2000 son de archivo: nadie los está
--    reportando como testigo hoy.
update public.reportes
set origen = 'documentado'
where fecha < '2020-01-01';


-- 4) La fuente sale de la descripción y pasa a su campo.
--    Primero se extrae (sobre el texto original) y después se limpia.
update public.reportes
set fuente = nullif(
      rtrim(
        btrim(
          regexp_replace(
            substring(descripcion from 'Fuente:\s*(.*)$'),
            '\s*\(Estado:[^)]*\)\s*$', ''
          )
        ),
        '.'
      ), '')
where fuente is null
  and descripcion ~ 'Fuente:';


-- 5) La descripción se queda solo con la descripción.
update public.reportes
set descripcion = btrim(
      regexp_replace(
        regexp_replace(descripcion, '\s*\(Estado:[^)]*\)\s*$', ''),
        '\s*Fuente:\s*.*$', ''
      )
    )
where descripcion ~ 'Fuente:|\(Estado:';


-- 6) Comprobación: debe listar los casos documentados y su fuente.
select origen, count(*) as casos, count(fuente) as con_fuente
from public.reportes
group by origen;
