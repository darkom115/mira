# Para Peluchín — cambios del 14 de noviembre de 2026

Escrito por Claude. Resume lo que cambió hoy en el proyecto y cómo trabajar de
aquí en adelante. El informe completo, que responde punto por punto a tu
documento de sincronización, está en `docs/informe-estado-claude.md`.

## 1. Ya existe el repositorio, y es la fuente de verdad

- **Dirección:** https://github.com/darkom115/mira (público)
- **Para leer un archivo en crudo:**
  `https://raw.githubusercontent.com/darkom115/mira/main/<ruta>`
  Por ejemplo:
  `https://raw.githubusercontent.com/darkom115/mira/main/sitio/index.html`

Lo que hay dentro:

```
sitio/index.html   el sitio público completo
sitio/admin.html   el panel de moderación
sql/               los 9 archivos de base de datos, en orden
docs/              informes y especificaciones
DECISIONES.md      las decisiones de Omar, con fecha
README.md          cómo está armado el proyecto
```

**Petición concreta:** antes de escribir la próxima especificación, lee
`sitio/index.html` y `DECISIONES.md`. Las dos rondas anteriores describían
funciones que no existen en el código (altitud, tamaño aparente, alias del
testigo, "quiero que me contacten", nota interna, tipo de fuente en los
aportes). Ninguna de esas está construida.

## 2. Qué cambió hoy

- **Netlify publica desde el repositorio.** Cada cambio que llegue a la rama
  `main` se publica solo, en menos de un minuto. Ya no se publica arrastrando
  carpetas.
- **Claude tiene permiso de escritura** sobre el repositorio y trabaja directo
  sobre los archivos.
- **Se corrió `seguridad.sql`.** El antispam está activo: máximo 5 envíos por
  hora desde la misma conexión, y marca automática de posibles duplicados y de
  descripciones muy cortas.
- **Las ubicaciones ya están redondeadas** a unos 1000 metros, en los 22 casos
  publicados y en todo lo que entre de ahora en adelante. No se guarda la
  ubicación exacta de ningún testigo.
- **Cada caso tiene enlace propio** (`?caso=<id>`) y, al compartirlo, la vista
  previa muestra el título y la descripción de ese caso. Verificado.
- **La papelera está en funcionamiento:** el panel ya no borra de forma
  definitiva, se puede restaurar, y hay exportación a JSON y CSV.

## 3. Correcciones a tu documento

Resumidas; el detalle está en `docs/informe-estado-claude.md`.

- El proyecto se llama **MIRA** y **no es una agencia ficticia**. "OUAP" ya no
  existe en el sitio. La regla vigente es no volver a ese planteamiento.
- Ko-fi correcto: **ko-fi.com/darkom0115**.
- El panel está en **/admin.html**.
- **No hay "nota interna".** Hay un campo *dictamen*, solo para el estado IFO,
  y **es público**: se muestra en el expediente. No escribir ahí nada privado.
- Las cuentas no cuadran: 22 publicados + 4 descartados son 26, no 25.
- Los 4 casos descartados **se quedan descartados** (decisión de Omar).

## 4. Qué necesitamos de ti

1. **La lista de textos en español que aparecen en modo inglés:** en qué
   pantalla y qué texto. Lo que escriben los usuarios (descripciones, lugares)
   no se traduce, y eso es intencional.
2. **El caso exacto del buscador** que duplica "Saltillo, Coahuila, Mexico":
   qué escribiste tal cual. El código ya quita repetidos y está publicado.
3. **Qué pasó con la pérdida de reportes** que mencionas: cuándo fue y qué se
   perdió. No hay registro de eso.
4. **Con qué cuenta moderaste y cómo cargaste los reportes**, por el formulario
   o directo en Supabase. Sirve para entender por qué unas coordenadas venían
   redondeadas y otras no.

## 5. Cómo seguimos

Propuesta de orden para lo que falta de la ronda 2:

1. Respaldo diario de la base en un repositorio privado aparte, y ensayar una
   restauración. Es lo único grave que falta: hoy, si se borra algo en Supabase,
   no hay de dónde recuperarlo.
2. Separar casos históricos de testimonios nuevos, con filtro.
3. Buscador y filtros en el panel de moderación.
4. Glosario de estados y ocultar categorías vacías.

Si una especificación no es viable tal como está escrita, Claude lo dice y
propone alternativa. Lo que esté en `DECISIONES.md` manda sobre cualquier
documento, este incluido.
