-- =============================================================
--  MIRA — Casos de DEMOSTRACIÓN (opcional)
--  10 casos de ejemplo con el modelo nuevo completo, para que los
--  filtros, el mapa de calor y las oleadas tengan qué mostrar.
--
--  • No toca tus casos reales.
--  • Todos llevan "(demo)" en el lugar y "[Demostración]" en la
--    descripción, para que nadie los confunda con casos reales.
--
--  Córrelo DESPUÉS de reestructura.sql, en: SQL Editor → New query → Run
--
--  Para borrarlos después:
--      delete from public.reportes where lugar like '%(demo)';
-- =============================================================

insert into public.reportes
  (categoria, forma, lugar, lat, lng, fecha, descripcion, momento, distancia, efecto, duracion, testigos, radar, direccion, estado, explicacion, idioma)
values
  ('fani', 'triangulo', 'Monterrey, Nuevo León (demo)', 25.6866, -100.3161, now() - interval '5 hours',
   '[Demostración] Tres luces en formación triangular, inmóviles sobre el Cerro de la Silla durante unos diez minutos.',
   'noche', 'lejos', null, 'min5a30', 4, false, 'estacionario', 'no_identificado', null, 'es'),

  ('fani', 'esfera', 'Apodaca, Nuevo León (demo)', 25.7810, -100.1880, now() - interval '2 days',
   '[Demostración] Esfera silenciosa que cruzó rumbo al aeropuerto a baja altura.',
   'crepusculo', 'cerca', 'ninguno', 'min1a5', 2, false, 'NE', 'no_identificado', null, 'es'),

  ('fani', 'luz', 'San Pedro Garza García, Nuevo León (demo)', 25.6573, -100.4020, now() - interval '3 days',
   '[Demostración] Punto brillante que avanzó despacio hacia el noreste y se apagó de golpe.',
   'noche', 'lejos', null, 'min1a5', 1, false, 'NE', 'no_identificado', null, 'es'),

  ('bestia_atmosferica', 'cambiante', 'Chihuahua, Chihuahua (demo)', 28.6353, -106.0889, now() - interval '4 days',
   '[Demostración] Forma translúcida con filamentos colgando, flotando hacia el norte.',
   'dia', 'lejos', null, 'min5a30', 3, false, 'N', 'no_identificado', null, 'es'),

  ('bestia_atmosferica', 'irregular', 'San Antonio, Texas (demo)', 29.4241, -98.4936, now() - interval '6 days',
   '[Demostración] Glowing dome shape with trailing strands, drifting slowly east.',
   'noche', 'lejos', null, 'min1a5', 6, false, 'E', 'no_identificado', null, 'en'),

  ('fani', 'formacion', 'Hermosillo, Sonora (demo)', 29.0729, -110.9559, now() - interval '9 days',
   '[Demostración] Fila de luces que cruzó el cielo en línea recta.',
   'noche', 'lejos', null, 'min1a5', 5, false, 'E', 'ifo',
   'Tren de satélites Starlink poco después de su lanzamiento.', 'es'),

  ('fani', 'esfera', 'El Paso, Texas (demo)', 31.7619, -106.4850, now() - interval '12 days',
   '[Demostración] Bright orange light hovering, then fading out.',
   'noche', 'lejos', null, 'segundos', 2, true, 'estacionario', 'ifo',
   'Bengala de un ejercicio militar en Fort Bliss.', 'en'),

  ('criptido_alado', 'irregular', 'Saltillo, Coahuila (demo)', 25.4383, -100.9737, now() - interval '18 days',
   '[Demostración] Silueta enorme con alas, planeando sin hacer ruido al atardecer. Dejó marcas en el techo de una bodega.',
   'crepusculo', 'cerca', 'rastro', 'segundos', 2, false, 'SW', 'no_identificado', null, 'es'),

  ('varillas', 'cilindro', 'Tucson, Arizona (demo)', 32.2226, -110.9747, now() - interval '25 days',
   '[Demostración] Elongated shape crossing the frame, only visible when reviewing the video.',
   'dia', 'lejos', null, 'segundos', 1, false, 'W', 'datos_insuficientes', null, 'en'),

  ('serpiente', 'cambiante', 'Torreón, Coahuila (demo)', 25.5428, -103.4068, now() - interval '45 days',
   '[Demostración] Forma alargada y ondulante sobre el río Nazas, sin alas visibles.',
   'dia', 'lejos', null, 'min1a5', 3, false, null, 'no_identificado', null, 'es');
