-- =============================================================
--  MIRA — REESTRUCTURACIÓN del catálogo
--  Modelo de datos nuevo, con los campos que usan los catálogos
--  reales de avistamientos (Hynek, NUFORC, Blue Book).
--
--  • Conserva tus reportes: los traduce al modelo nuevo.
--  • Copia TODO en: SQL Editor → New query → Run   (solo una vez)
-- =============================================================


-- 1) CATEGORÍA DEL FENÓMENO (reemplaza a "tipo")
--    fani ............... fenómeno aéreo no identificado (UAP)
--    criptido_alado ..... criatura alada (Thunderbird, Kongamato, Ropen…)
--    bestia_atmosferica . medusa atmosférica y similares
--    varillas ........... "rods" o sky fish
--    serpiente .......... serpiente del cielo
--    sin_clasificar ..... no encaja en las anteriores
alter table public.reportes
  add column categoria text not null default 'sin_clasificar'
  check (categoria in ('fani', 'criptido_alado', 'bestia_atmosferica', 'varillas', 'serpiente', 'sin_clasificar'));

-- Traducimos los reportes que ya existen
update public.reportes set categoria = case tipo
  when 'dinosaurio' then 'criptido_alado'
  when 'medusa'     then 'bestia_atmosferica'
  when 'ovni'       then 'fani'
  else 'sin_clasificar'
end;

-- "tipo" queda como columna vieja: ya no se usa, pero no se borra
alter table public.reportes alter column tipo drop not null;


-- 2) FORMA OBSERVADA (la lista que usan los formularios de reportes)
alter table public.reportes
  add column forma text
  check (forma in ('luz', 'esfera', 'disco', 'triangulo', 'cilindro', 'ovalo',
                   'formacion', 'cambiante', 'irregular', 'otra'));


-- 3) CIRCUNSTANCIAS (de aquí sale la clasificación de Hynek)
alter table public.reportes add column momento   text check (momento in ('dia', 'crepusculo', 'noche'));
alter table public.reportes add column distancia text check (distancia in ('lejos', 'cerca'));
alter table public.reportes add column efecto    text check (efecto in ('ninguno', 'rastro', 'ocupante'));
alter table public.reportes add column duracion  text check (duracion in ('segundos', 'min1a5', 'min5a30', 'mas30'));
alter table public.reportes add column testigos  smallint check (testigos between 1 and 999);
alter table public.reportes add column radar     boolean not null default false;


-- 4) ESTADO DEL CASO (los tres del Proyecto Blue Book, más dos de flujo)
--    pendiente ........... recién enviado, nadie lo ve
--    no_identificado ..... publicado, sin explicación
--    ifo ................. publicado, identificado (dron, satélite…)
--    datos_insuficientes . publicado, no alcanza para concluir
--    descartado .......... falso o spam, nadie lo ve
alter table public.reportes drop constraint reportes_estado_check;

update public.reportes set estado = case estado
  when 'sin explicar' then 'no_identificado'
  when 'explicado'    then 'ifo'
  when 'rechazado'    then 'descartado'
  else estado
end;

alter table public.reportes
  add constraint reportes_estado_check
  check (estado in ('pendiente', 'no_identificado', 'ifo', 'datos_insuficientes', 'descartado'));


-- 5) Las reglas de seguridad usan los estados nuevos
drop policy "Todos ven solo reportes aprobados" on public.reportes;

create policy "Todos ven los casos publicados"
  on public.reportes for select
  to anon, authenticated
  using (estado in ('no_identificado', 'ifo', 'datos_insuficientes'));

-- (La regla de crear sigue igual: todo entra como 'pendiente'.)
