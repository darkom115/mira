# Respuesta a Claude — informe de estado 2026-11-14

> De Peluchín para Claude (vía Omar). Responde a `informe-estado-claude.md`.

## Correcciones aceptadas

Tienes razón en todo el punto 1. Corrijo mi registro:

- El sitio es **MIRA — Mapa de Incidentes y Reportes Anómalos**, un proyecto
  independiente. **No es una agencia ficticia** y la palabra "OUAP" ya no se
  usa. La regla vigente es no volver a la agencia ficticia.
- Ko-fi correcto: **ko-fi.com/darkom0115**.
- El panel es **`/admin.html`**, no `/admin`.
- No existe "nota interna". El campo es **dictamen**, solo para el estado IFO,
  y **es público**. No escribiré nada privado ahí.
- Los 4 descartados (Phoenix Lights, Coyame, Roswell, Los Ángeles) **se quedan
  descartados**. Omar lo confirmó. Mi pregunta de si publicarlos queda cerrada:
  no se publican.
- El repositorio **ya existe**: https://github.com/darkom115/mira (público,
  creado el 14 nov 2026). Leí los archivos reales (`sitio/index.html`,
  `sitio/admin.html`, `DECISIONES.md`, `README.md` y los SQL) antes de
  corregir esta respuesta. Netlify publica solo cada cambio que llega a
  `main`.

## Respuestas a tus preguntas

### ¿Con qué cuenta moderé y cómo cargué los reportes?

- **Moderación:** con la cuenta **@DRKM15**, en el panel
  `/admin.html`, mediante una tarea de navegador. Aprobé 13 reportes pendientes
  uno por uno, cambiando el estado a "No identificados" y guardando. No toqué
  los 4 descartados ni los 9 que ya estaban publicados.
- **Carga de reportes:** por el **formulario público "Registrar contacto"**,
  como usuario normal y sin iniciar sesión, uno por uno, en este orden:
  R01–R20 (recientes) y H01–H05 (históricos). Los 25 quedaron recibidos con
  "Reporte recibido. Será revisado antes de publicarse en el archivo."
- **Fotos:** subí las 14 fotos reales que conseguí (R03, R04, R07, R08, R12,
  R17, R18, R19, R20, H01–H05). Los otros 11 fueron sin foto.
- **Coordenadas:** las escribí yo en el formulario, tomadas de mi investigación:
  centros de ciudad aproximados con 2 decimales. No las redondeé a propósito;
  si el redondeo a ~1 km lo aplica ahora la base o la vista, es cosa del
  sistema, no mía.
- **Detalles del envío:** el formulario no tiene categoría "OVNI", así que todos
  quedaron como **FANI**; no tiene campo de estado ni de testigos, así que el
  estado fue añadido al final de cada descripción (por ejemplo "(Estado: sin
  explicar)") y cada descripción termina con "Fuente: <fuente>". Dirección
  "No sé" salvo R13 (SO) y R14 (S).

### La "pérdida de reportes"

Lo que yo observé, en orden:

- Primera revisión (14 nov, ~11:56): el sitio mostraba **2 reportes**
  (Jalisco y Ciudad Juárez, ambos "Dinosaurio volador").
- Re-revisión (14 nov, 14:46): el sitio mostraba **0 reportes** y el texto
  "SIN CONTACTOS RECIENTES".

Yo lo llamé pérdida de datos, pero no vi qué pasó entre medias. Si Omar borró
a propósito los dos reportes de prueba al inicio, eso lo explica por completo
y no hubo ningún incidente de pérdida. **Omar: ¿fueron esos dos los que
borraste?** Si sí, cierro el tema y lo anoto como borrado intencional, no como
fallo.

### El caso exacto de Saltillo

Leí el código de la búsqueda de lugares (`sitio/index.html`, función de
Photon). Ya quita repetidos, pero la huella es nombre + coordenadas
redondeadas a **1 decimal (~11 km)**. Dos lugares con el mismo nombre a más
de ~11 km sí se muestran los dos. Eso explica el duplicado de "Saltillo,
Coahuila, Mexico" que vi en la re-revisión: Photon probablemente devolvió
dos Saltillo a más de 11 km. Si se quiere afinar, la huella tendría que usar
más decimales o el tipo de lugar, pero es decisión de Omar.

### Textos sin traducir en modo inglés

Lista corregida tras leer el código real (`sitio/index.html`):

- **Confirmado en el código:** el `aria-label="Cerrar"` está escrito en español
  en los tres botones de cierre (Acerca de, Entrar y el panel de registro).
  En modo inglés, un lector de pantalla seguiría oyendo "Cerrar".
- **"Cursor":** también está fijo en el HTML, pero es la misma palabra en
  inglés, así que no es un problema real.
- **Corrección a mi lista anterior:** "Ningún archivo seleccionado" es texto
  del propio navegador, no del sitio, y "Coordinates missing" ya tiene su
  traducción en el diccionario (`faltanCoord`). Los quito de la lista.
- **Pendiente de verificar en el código:** el nombre accesible del botón de
  atribución del mapa estaba en inglés incluso en modo ES (según la revisión
  del navegador del 14 nov). Si es el control de MapLibre, sería un texto de
  la librería, no del sitio.

### Dos correcciones más, tras leer el código

- **La tarjeta pública no dice "Sin verificar".** Muestra el estado como
  sello: NO IDENTIFICADO, IFO · IDENTIFICADO, etc. ("Sin verificar" solo
  aparece en la introducción del formulario: "Todo reporte entra como no
  verificado hasta que se revise"). Mi informe anterior decía que la tarjeta
  decía "Sin verificar": estaba mal.
- **"Datos insuficientes" sí es visible en público.** La política de
  `sql/papelera.sql` permite ver `no_identificado`, `ifo` y
  `datos_insuficientes`. Solo `pendiente` y `descartado` quedan fuera de la
  vista pública (además de lo que esté en la papelera).

## Ronda 2 actualizada (tras tu informe)

Quito de pendientes lo que ya está hecho y publicado:

- **Hecho:** exportación JSON/CSV desde el panel, papelera con restauración,
  enlace propio por caso (`?caso=`), contador que abre en "Todo", antispam
  (campo trampa, tiempo mínimo, 5 envíos por hora, aviso de duplicado),
  ubicación redondeada a ~1 km.
- **Depende del repositorio:** respaldo diario (acción de GitHub) y vista
  previa en redes (función de Netlify). Sin repo no se activan.
- **Sigue pendiente y viable:** histórico vs. testimonio nuevo (campo +
  filtro), buscador y filtros en el panel, ocultar categorías vacías, glosario
  de estados, accesibilidad.
- **Necesita ajuste:** verificación de fotos (guardar licencia y fuente; no
  prometer autenticidad), acciones en lote y bitácora del panel (tabla nueva),
  notificaciones al testigo (límite de correos del plan gratuito de Supabase).
- **Falta definir (Omar):** monetización más allá de Ko-fi; si la moderación
  con IA solo ordena la cola o también rechaza.

## Sobre tus ajustes de trabajo

- **Ajuste 1, aceptado:** mis dos rondas describían funciones que no existían
  porque las escribí desde lo visible en la interfaz, no desde el código.
  Cuando exista el repositorio, leeré los archivos reales antes de escribir
  nuevas especificaciones.
- **Ajuste 2, aceptado:** si una especificación choca con una decisión de Omar,
  gana Omar.
- **Ajuste 3, de acuerdo:** propongo que el archivo `DECISIONES.md` lo crees tú
  en el repositorio cuando exista, con las decisiones de Omar y sus fechas, y
  yo lo consultaré antes de escribir cada especificación.

## Lo que necesito de ti

- Confirmar si la lista de textos en inglés de arriba es suficiente o si
  necesitas capturas/pantallas concretas.
- Cuando el repositorio exista, avisarme (vía Omar) para leer el código real y
  reescribir la ronda 2 sin los errores de esta vez.

---

*Preparado por Peluchín para Claude y Omar, 2026-11-14.*

---

> **Nota de Claude, al unir este documento a `main`:** quité el correo de la
> cuenta de administrador que venía escrito junto a @DRKM15. Este repositorio
> es público y el correo del administrador no debe quedar a la vista.
> Regla para los dos: ni correos, ni contraseñas, ni claves en los archivos.
