# Mejoras para Open Sky Archive — OUAP

> Instrucciones para Claude: aplica los cambios descritos abajo en el proyecto del sitio
> https://open-sky-archive.netlify.app (Open Sky Archive — OUAP).
> No cambies el concepto ni la estética general del sitio.

## Contexto del sitio

Open Sky Archive — OUAP es un archivo ficticio de avistamientos UAP/UFO, presentado como
la "OUAP · Office of Unidentified Aerial Phenomena", con estética de terminal clasificada
(sello "CLASIFICADO · USO RESTRINGIDO", reloj UTC en vivo, animación de arranque
"Estableciendo enlace satelital... OK").

- Globo 3D interactivo central con marcadores de avistamientos; al hacer clic en un
  marcador se abre una ficha tipo expediente (tipo, lugar, fecha/hora UTC, coordenadas,
  testigo, sello "SIN EXPLICAR", foto cuando existe).
- Panel izquierdo "Contactos registrados": filtros de periodo (24 h / 7 días / 30 días /
  Todo), botón "Reproducir" que anima la línea de tiempo, vistas Radar/Calor, toggles por
  tipo de entidad (Dinosaurio volador, Medusa gigante, OVNI, No identificado) y sección
  "Zonas activas".
- Panel "Registrar contacto": tipo de entidad, ubicación con búsqueda (geocodificación
  Photon/OpenStreetMap), "Marcar en el globo", "Usar mi GPS", nombre del lugar, fecha/hora,
  descripción, brújula de dirección, foto y enlace opcional de YouTube.
- Selector de idioma ES/EN, "Acceso de agentes", enlace de donaciones a Ko-fi.
- Hosting en Netlify; imágenes de mapa © Esri; búsqueda Photon/OpenStreetMap.

Estado actual del contenido: solo hay 2 reportes, ambos del tipo "Dinosaurio volador"
(Jalisco y Calle Anapra, Ciudad Juárez), ambos del 2026-11-14, por lo que todos los
periodos muestran lo mismo y los otros tres tipos están en 0.

## Prioridad 1 — Usabilidad rota

### 1.1 Cerrar el panel de registro
- Añadir un botón de cerrar (X) visible al panel "Registrar contacto".
- Que el botón principal "Registrar contacto" alterne el panel (abrir/cerrar).
- Que la tecla Escape cierre el panel.
- Que hacer clic en el globo no deje el panel atascado: si no se está marcando un punto,
  el clic en el globo no debe interferir con el cierre.
- Criterio de aceptación: el panel se puede cerrar por X, por el botón principal, por
  Escape y por "Descartar borrador", sin perder el borrador salvo que se elija descartarlo.

### 1.2 Fichas de avistamiento con scroll
- La ficha de Ciudad Juárez excede el alto de la ventana: la descripción queda truncada
  y la foto fuera de vista, sin scroll aparente.
- Dar a la ficha una altura máxima (por ejemplo `max-height: 85vh`) con scroll interno.
- Asegurar que la foto sea visible sin que el usuario tenga que adivinar dónde está.
- Criterio de aceptación: en una ventana de escritorio estándar, toda la ficha
  (descripción completa y foto) es alcanzable con scroll interno.

## Prioridad 2 — Traducción y choques visuales

### 2.1 Completar la traducción al inglés (modo EN)
En modo EN quedan textos en español; traducir todos:
- "Cursor" (coordenadas del cursor).
- La atribución del pie: "Imágenes © Esri · Búsqueda: Photon/OpenStreetMap".
- Las etiquetas de fecha y hora.
- El selector de archivo (input de foto).
- Revisar cualquier otro texto que quede sin traducir al cambiar a EN.
- Criterio de aceptación: en modo EN no queda ningún texto visible en español.

### 2.2 La insignia de Netlify tapa la atribución
- La insignia "Powered by Netlify" cubre el botón de atribución abajo a la derecha y
  bloquea su clic.
- Desplazar la insignia (o la atribución) para que ningún elemento cubra a otro ni
  bloquee clics.
- Criterio de aceptación: ambos elementos son visibles y clicables.

### 2.3 "Zonas activas" debe respetar el periodo seleccionado
- Hoy la sección siempre dice "30 días" aunque el periodo elegido sea 24 h, 7 días o Todo.
- Que el título y el cálculo de zonas activas usen el periodo seleccionado en el filtro.
- Criterio de aceptación: al cambiar el periodo, el título y las zonas listadas cambian
  en consecuencia.

## Prioridad 3 — Estados vacíos y consistencia de datos

### 3.1 Distinguir "sin reportes" de "filtrado por tipo"
- Al ocultar el único tipo con datos (Dinosaurio volador), "Zonas activas" dice
  "Todavía no hay reportes en últimos 30 días" aunque en realidad es un filtro activo,
  y el total pasa a 0 mientras el tipo sigue mostrando "2".
- Mostrar un mensaje distinto cuando el vacío es por filtros activos (por ejemplo,
  "Sin resultados con los filtros actuales") y mantener coherentes los contadores
  (total y por tipo) con lo que realmente se muestra.
- Criterio de aceptación: con filtros que ocultan todo, el mensaje explica que es por
  los filtros y los contadores son coherentes entre sí.

### 3.2 Deduplicar resultados de geocodificación
- Buscar "Saltillo" devuelve "Saltillo, Coahuila, Mexico" dos veces.
- Deduplicar los resultados de Photon por nombre + coordenadas antes de mostrarlos.
- Criterio de aceptación: ningún resultado repetido en la búsqueda de ubicación.

### 3.3 Botón Reproducir / Pausa
- Durante la animación de la línea de tiempo, "Reproducir" no cambia a Pausa/Detener.
- Que el botón muestre "Pausa" (o "Detener") mientras anima y permita pausar/detener.
- Revisar además las coordenadas iniciales del cursor (37.17, -8.86), que no corresponden
  al centro visible del globo al cargar.

## Prioridad 4 — Contenido y descubrimiento

### 4.1 Lista / buscador de reportes
- Hoy la única forma de ver un reporte es hacer clic en su marcador en el globo.
- Añadir una lista de reportes (con buscador por lugar o tipo) accesible desde el panel,
  que al hacer clic en un reporte vuele el globo hasta su marcador y abra su ficha.
- Criterio de aceptación: se puede encontrar y abrir cualquier reporte sin tocar el globo.

### 4.2 Leyenda de las líneas punteadas
- Añadir una leyenda visible que explique que las líneas punteadas son proyecciones
  especulativas del rumbo promedio, para que no se confundan con rutas reales.

### 4.3 Más datos semilla
- Ampliar los datos iniciales con más reportes de distintos tipos (Medusa gigante, OVNI,
  No identificado) y de distintas fechas, para que los filtros de periodo y tipo tengan
  sentido y las vistas Radar/Calor muestren diferencias reales.
- Mantener los 2 reportes existentes (Jalisco y Ciudad Juárez) tal como están.

### 4.4 Diseño responsivo
- Probar el panel lateral en pantallas pequeñas y hacerlo colapsable, para que no tape
  el globo en móvil.

## Restricciones

- No cambiar el concepto (agencia ficticia), la estética de terminal clasificada, ni la
  estructura general de la página.
- No tocar la lógica de moderación ni el flujo de "Acceso de agentes".
- No enviar ningún reporte real ni modificar los reportes existentes.
- Verificar cada cambio recargando el sitio y probando el flujo afectado antes de darlo
  por terminado.
