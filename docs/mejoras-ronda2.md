# Mejoras y monetización para Open Sky Archive — OUAP (ronda 2)

> Instrucciones para Claude: aplica los cambios descritos abajo en el proyecto del sitio
> https://open-sky-archive.netlify.app (Open Sky Archive — OUAP).
> Esta es la segunda ronda de mejoras; la primera (cierre del panel, scroll de fichas,
> traducción EN, insignia de Netlify, periodo en "Oleadas", botón Detener, sección
> "Reportes") ya está aplicada en su mayor parte y NO debe revertirse.
> No cambies el concepto ni la estética general del sitio.

## Contexto del sitio

Open Sky Archive — OUAP es un archivo ficticio de avistamientos UAP/FANI, presentado
como la "OUAP · Office of Unidentified Aerial Phenomena" (en inglés, MIRA — Map of
Incidents & Reported Anomalies), con estética de terminal clasificada.

- **Pila:** alojamiento en Netlify; Supabase como base de datos, autenticación y
  almacenamiento de fotos; imágenes de mapa © Esri; búsqueda de lugares Photon /
  OpenStreetMap; Google Fonts, unpkg/jsDelivr y miniaturas de YouTube.
- **Lado público:** globo 3D interactivo, franja "ÚLTIMO CONTACTO" con hora local en
  vivo, panel "Contactos registrados" con periodos (24 h / 7 días / 30 días / Todo),
  botón "Reproducir" (animación temporal), vistas Radar / Calor, filtros por tipo
  (FANI, Críptido alado, Bestia atmosférica, Varillas (rods), Serpiente del cielo,
  Sin clasificar), sección "Reportes" con buscador, sección "Oleadas" con zonas
  activas y líneas punteadas especulativas, tarjetas de reporte en modal (tipo,
  estado, lugar, fecha/hora, foto ampliable, descripción, "Enviado el…", botón
  "Ver video", votación "Parece real / Parece falso" con sesión, y "Aportar al
  expediente" con tipo de fuente, URL y nota). Selector ES/EN. Enlace "Apoya al
  archivo" a https://ko-fi.com/open_sky_archive/support.
- **Formulario "Registrar contacto" (4 pasos, borrador en el dispositivo):**
  Paso 1 "Qué viste" (categoría, forma observada, descripción obligatoria);
  Paso 2 "Dónde y cuándo" (buscador Photon, "Marcar en el globo", "Usar mi GPS",
  "Sin coordenadas", nombre del lugar, fecha/hora, "¿Cuándo fue?");
  Paso 3 "Circunstancias" (brújula de 8 rumbos, movimiento, distancia, duración,
  altitud, tamaño aparente); Paso 4 "Evidencia" (foto JPG/PNG/WebP máx. 8 MB,
  enlace de YouTube, ¿lo vio alguien más?, nombre o alias opcional, "Quiero que
  me contacten"). Todo reporte entra como no verificado hasta revisión humana.
- **Panel de administración (/admin, "Panel de moderación"):** pestañas Pendientes,
  No identificados, IFO (identificados), Datos insuficientes, Descartados. Cada
  reporte muestra foto, título, categoría, lugar, fecha, descripción,
  "Enviado el… · Formulario web", selector de Estado (las mismas 5 opciones),
  cuadro "Nota interna (no se publica)" y botones "Guardar" y "Eliminar".
  No hay edición del contenido, acciones en lote, buscador/filtros, gestión de
  usuarios, ajustes, estadísticas ni exportación. Abajo, "Aportes recientes de la
  comunidad".
- **Ciclo de vida:** envío → Pendientes (no público) → el moderador cambia Estado
  y Guarda → No identificados (y presumiblemente IFO) se publica en globo/lista;
  Datos insuficientes y Descartados quedan fuera; Eliminar borra.
- **Estado actual (2026-11-14):** 22 reportes publicados (21 FANI + 1 Críptido
  alado), 0 pendientes, 4 descartados (Phoenix Lights, Coyame, Roswell,
  Los Ángeles). En público la tarjeta dice "Sin verificar" aunque en el panel el
  estado sea "No identificados": publicado y verificado NO son lo mismo.

## Prioridad 1 — Proteger los datos (lo más urgente)

### 1.1 Respaldo y exportación de Supabase
- El sitio ya pasó de 2 reportes a 0 en una ocasión y el panel no ofrece ninguna
  forma de exportar ni respaldar. Supabase es hoy un único punto de fallo.
- Implementar exportación programada (diaria) de la base en CSV y JSON, con
  descarga manual desde el panel, y documentar el procedimiento de restauración.
- Hacer una prueba real de restauración en un entorno de pruebas antes de darlo
  por terminado.
- Criterio de aceptación: existe un respaldo automático diario, un botón de
  exportar en el panel, y una restauración de prueba verificada y documentada.

### 1.2 Confirmación y papelera al eliminar
- Hoy "Eliminar" en el panel parece definitivo y no pide confirmación.
- Añadir diálogo de confirmación y, si es posible, papelera con recuperación
  (o al menos borrado lógico con marca de eliminado).
- Criterio de aceptación: ningún reporte se borra con un solo clic accidental.

## Prioridad 2 — Confianza y calidad del archivo

### 2.1 Antispam y duplicados en el formulario
- Hoy cualquiera puede enviar texto, foto y enlace de YouTube sin cuenta.
- Añadir honeypot, límite de envíos por IP/cuenta y CAPTCHA selectivo, y
  detección de duplicados (mismo lugar + fecha + descripción similar) y de
  casos históricos ya cargados.
- Criterio de aceptación: un envío automatizado masivo queda bloqueado y un
  reporte duplicado se marca para revisión en vez de publicarse dos veces.

### 2.2 Verificación de fotos y licencia
- Añadir revisión de EXIF (fecha y GPS coherentes con el reporte), hash contra
  imágenes conocidas, y un campo de licencia/autor de la foto.
- Mantener visible el crédito de la foto en la tarjeta pública.
- Criterio de aceptación: una foto sin EXIF o con fecha incoherente queda
  marcada para revisión y la tarjeta muestra su fuente.

### 2.3 Distinguir casos históricos de testimonios nuevos
- Hoy Tampico 1967, Zona del Silencio, Roswell, Coyame y Phoenix Lights
  conviven con testimonios de 2024–2026 bajo la misma etiqueta "Sin verificar".
- Añadir un campo "Tipo de caso" (testimonio nuevo / caso histórico documentado)
  visible en la tarjeta, y un filtro para ver solo históricos.
- Criterio de aceptación: un visitante distingue a simple vista un caso histórico
  de un testimonio reciente.

### 2.4 Estados públicos claros
- Explicar qué es IFO con ejemplos, y la diferencia entre Pendientes,
  No identificados y "Sin verificar".
- Añadir un estado público "Verificado por moderación" separado de
  "Sin verificar", y mostrarlo en la tarjeta.
- Unificar la terminología en un solo glosario (FANI / OVNI / No identificado /
  Sin verificar hoy se mezclan).
- Criterio de aceptación: la tarjeta explica su propio estado sin necesidad de
  leer la documentación.

### 2.5 Privacidad del testigo
- El formulario pide ubicación exacta (incluso GPS), fecha/hora, si iba
  acompañado y contacto opcional; ubicación + hora pueden identificar a una
  persona. El aviso de privacidad es genérico.
- Redondear la ubicación pública al barrio/ciudad (nunca coordenadas exactas),
  y completar el aviso con responsable, plazo de conservación y procedimiento
  de borrado de datos.
- Criterio de aceptación: la ubicación pública nunca muestra coordenadas exactas
  ni permite identificar al testigo.

## Prioridad 3 — Producto y moderación

### 3.1 URL propia por reporte y página de detalle
- Hoy todo es un modal sobre el mapa: no se puede enlazar, compartir ni indexar
  un caso en buscadores o redes.
- Crear una ruta propia por reporte (por ejemplo `/reporte/<id-o-slug>`) con su
  página de detalle y etiquetas Open Graph (título, descripción, imagen) para
  redes sociales.
- Criterio de aceptación: cada reporte tiene una URL que se puede copiar, abrir
  directamente y compartir con vista previa en redes.

### 3.2 Panel de moderación con buscador, filtros y acciones en lote
- Añadir búsqueda por lugar, fecha, categoría y estado, acciones en lote
  (aprobar/rechazar varios a la vez) y registro de auditoría (quién cambió qué
  y cuándo).
- Criterio de aceptación: moderar 20 reportes pendientes toma minutos, no
  revisión uno por uno sin contexto.

### 3.3 Notificaciones
- Avisar al testigo cuando su reporte se recibe, se publica o se rechaza (con
  motivo), y al moderador cuando llega un pendiente nuevo.
- Permitir que el testigo corrija su reporte.
- Criterio de aceptación: un testigo sabe en qué estado está su reporte sin
  tener que preguntar.

### 3.4 Formulario más corto y fechas históricas explícitas
- El formulario de 4 pasos es largo para un avistamiento casual.
- Permitir enviar con lo mínimo (descripción + lugar aproximado + fecha) y
  pedir el resto después, y aceptar fechas históricas de forma explícita.
- Criterio de aceptación: un reporte mínimo se puede enviar en menos de un
  minuto y un caso de 1967 no se confunde con uno de 2026.

### 3.5 Contador y presentación
- El contador "Contactos registrados" muestra por defecto el periodo de 30 días
  (3) aunque en "Todo" hay 22, lo que da sensación de sitio vacío.
- Mostrar el total histórico junto al número filtrado y recordar el periodo
  activo en la lista.
- Criterio de aceptación: al abrir el sitio se ve el total real de reportes.

### 3.6 Accesibilidad y móvil
- Mejorar contraste, foco de teclado, alternativa textual al globo y lista
  equivalente, y paginación/virtualización de la lista cuando crezca.
- Criterio de aceptación: el archivo es usable sin ratón y en una pantalla de
  teléfono sin que el panel tape el globo.

## Prioridad 4 — Simplificar

### 4.1 "Oleadas" especulativas
- Las líneas punteadas de "Oleadas" se pueden leer como predicción real.
- Marcarlas claramente como experimento y desactivarlas por defecto, o
  quitarlas hasta que haya datos suficientes para sostenerlas.
- Criterio de aceptación: ningún visitante puede confundir una proyección
  especulativa con un hecho.

### 4.2 Categorías vacías
- Bestia atmosférica, Varillas (rods) y Serpiente del cielo tienen 0 casos en
  todos los periodos y diluyen FANI/Críptido.
- Mantenerlas solo si hay una estrategia para poblarlas; si no, ocultarlas del
  filtro público hasta que tengan casos.
- Criterio de aceptación: cada categoría visible tiene al menos un caso.

### 4.3 Botón "Reproducir"
- Revisar si la animación temporal aporta una historia clara; si no, quitarla
  o convertirla en una línea de tiempo con hitos.
- Criterio de aceptación: el botón existe solo si comunica algo que la lista no.

## Monetización (por orden de esfuerzo/retorno)

### M1. Membresías en Ko-fi (menor esfuerzo, hacer primero)
- El enlace a Ko-fi ya existe. Activar Membresías (por ejemplo 3–5 USD/mes) con
  objetivos visibles ("costos de Supabase/Netlify", "digitalizar un caso
  histórico") y una sección de miembros destacados en el sitio.
- No requiere tocar el código del sitio, solo configurar Ko-fi y enlazarlo de
  forma persistente.

### M2. Embudo de video y redes
- TikTok, YouTube Shorts y X con "el caso de la semana" tomado de la tarjeta del
  reporte, enlazando a su URL propia (ver 3.1).
- Necesita las URL por reporte y miniaturas propias. Retorno en audiencia y
  donaciones, no en venta directa.

### M3. Merchandising ligero
- Ko-fi Shop o Printful (playeras del globo, "Agente MIRA"), sin inventario.
- Necesita diseños y un enlace en el sitio.

### M4. Afiliados afines
- Sección "Recursos" con libros de divulgación, telescopios/binoculares y apps
  de cielo, con divulgación clara de afiliación.
- Retorno bajo al inicio; no abusar para no dañar la credibilidad.

### M5. Premium para investigadores (después de las prioridades 1–3)
- Alertas por zona, exportación CSV, dossier PDF por caso, acceso a datos
  crudos y a la API.
- Necesita Supabase Auth (ya existe) + pasarela (Stripe o Ko-fi Memberships con
  webhook), una tabla de suscripciones/permisos y controles de acceso por fila.
- No implementar antes de tener respaldo, antispam y URL por reporte.

### M6. Datos/API para medios y academia
- Licencia de uso del dataset con atribución, documentación, clave API y
  términos de uso.
- Requiere la base limpia y con licencias de foto resueltas (ver 2.2).

### M7. Publicidad (solo si el tráfico crece mucho)
- AdSense solo con tráfico alto; hoy, con ~22 reportes, el retorno sería mínimo
  y dañaría la confianza.

### No hacer todavía
- Muro de pago sobre los reportes o el mapa (mataría el envío comunitario).
- Vender datos personales o la ubicación exacta de testigos.
- Criptomonedas.
- "Informes premium" que prometan verificar lo inverificable.

## Riesgos a tener en cuenta al implementar

- **Pérdida de datos:** Supabase es un único punto de fallo; sin respaldo, un
  error borra el archivo (ya ocurrió una vez: de 2 reportes a 0).
- **Fotos de terceros:** pueden estar sacadas de contexto o no corresponder al
  avistamiento (la foto de Tampico 1967 muestra buzos, no el fenómeno). Sin
  licencia hay riesgo de copyright y de engaño.
- **Reportes falsos y spam:** envío anónimo, moderación de una sola persona, y
  votos "Parece real/falso" y aportes con URL manipulables sin límites visibles.
- **Dependencias externas:** Esri, Photon/OSM, Google Fonts, unpkg/jsDelivr y
  YouTube pueden cambiar, caerse o registrar datos de visitantes; autoalojar
  fuentes y librerías críticas y fijar versiones.

## Restricciones

- No cambiar el concepto (agencia ficticia), la estética de terminal clasificada,
  ni la estructura general de la página.
- No tocar la lógica de moderación existente (envío → Pendientes → publicación)
  salvo en lo indicado en 3.2 y 3.3.
- No publicar ni modificar los reportes existentes sin autorización del
  propietario; los 4 descartados (Phoenix Lights, Coyame, Roswell, Los Ángeles)
  solo se publican si el propietario lo autoriza explícitamente.
- No enviar ningún reporte real ni modificar datos de Supabase salvo en pruebas
  con datos de prueba.
- Verificar cada cambio recargando el sitio y probando el flujo afectado antes
  de darlo por terminado.
