# Decisiones del proyecto

Decisiones tomadas por Omar, el dueño del proyecto. **Este archivo manda sobre
cualquier especificación o informe.** Si algo en `docs/` lo contradice, gana lo
que está aquí.

Cada decisión lleva fecha. Para cambiar una, se agrega una línea nueva con la
fecha nueva; la anterior se deja tachada, para no perder el historial.

---

## Identidad

- **2026-11-14 — El proyecto se llama MIRA** (Mapa de Incidentes y Reportes
  Anómalos). Antes se llamó "Open Sky Archive / OUAP".
- **2026-11-14 — No es una agencia ficticia.** Es un proyecto independiente de
  alguien interesado en estos fenómenos, que comparte lo que recopila con la
  comunidad. No volver al planteamiento de agencia secreta.
- **2026-11-14 — Sí se conserva la estética** de archivo clasificado filtrado /
  consola de rastreo.
- **2026-11-14 — El autor firma como DARKOM, y solo en "Acerca de".** No poner
  ese nombre por toda la interfaz.
- **2026-11-14 — La dirección del sitio sigue siendo**
  `open-sky-archive.netlify.app`, aunque el proyecto ya no se llame así.

## Contenido

- **2026-11-14 — Los 4 casos descartados se quedan descartados:** Phoenix
  Lights, Coyame, Roswell y Los Ángeles. No se publican.
- **2026-11-14 — La taxonomía usa términos reales** de ufología y criptozoología
  (FANI/UAP, clasificación de Hynek, críptido alado, bestia atmosférica,
  varillas), no términos inventados.
- **2026-11-14 — El dictamen es público:** se muestra en el expediente. No
  escribir ahí notas privadas de moderación.

## Interfaz

- **2026-11-14 — El contador de contactos abre en "Todo"**, no en 24 horas.
- **2026-11-14 — La franja superior dice "Último contacto"**.
- **2026-11-14 — El clic en el globo solo coloca un punto cuando el usuario
  eligió "marcar en el mapa"**; en cualquier otro momento no hace nada. Es
  intencional, no un error. (Pendiente de revisar si conviene que además cierre
  el panel de registro.)

## Privacidad y datos

- **2026-11-14 — La ubicación de los reportes se guarda redondeada** a dos
  decimales (unos 1000 metros). No se guarda ni se muestra la ubicación exacta
  de un testigo.
- **2026-11-14 — No se venden datos personales** ni ubicaciones exactas.

## Dinero

- **2026-11-14 — Donaciones por Ko-fi:** https://ko-fi.com/darkom0115
- **2026-11-14 — Nada de muro de pago, criptomonedas, ni "informes premium"**
  que prometan verificar lo inverificable.

## Dónde vive el sitio

- **2026-11-18 — El sitio se muda a Cloudflare Pages.** El plan gratuito de
  Netlify da 300 créditos al mes y cada publicación cuesta unos 15: alcanza
  para unas 20 al mes. Con 19 publicaciones en cuatro días se agotaron y
  Netlify pausó los despliegues hasta el 13 de diciembre. Cloudflare Pages
  da 500 al mes y el sitio es estático. Los pasos están en
  `docs/mudanza-a-cloudflare.md`.
- **2026-11-18 — No se borra el sitio de Netlify.** Se queda en línea como
  respaldo, con su `netlify.toml` y su función, por si hay que volver.
- **2026-11-18 — Un solo envío por sesión de trabajo.** Cada push a `main`
  publica y cuesta. Los cambios se juntan en vez de subirlos de uno en uno.

## Pendiente de decidir

- Moderación con ayuda de IA: ¿solo ordena y etiqueta la cola, o también puede
  rechazar por su cuenta lo que es claramente abuso?
- Monetización más allá de las donaciones.
- Si el clic en el globo debe cerrar el panel de registro.
