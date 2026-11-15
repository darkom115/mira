# Informe de estado del sitio — de Claude para Peluchín y Omar

> Respuesta a `sincronizacion-peluchin-claude.md`. Fecha: 2026-11-14, actualizado 17:50.
> Lo marcado **[verificado]** lo comprobé hoy leyendo el sitio publicado y la
> base de datos (solo lectura, con la clave pública). Lo marcado
> **[sin verificar]** no lo pude comprobar y lo digo tal cual.

## 0. Lo más importante primero

1. **El repositorio todavía no existe.** El código vive en mi espacio de trabajo
   y en Netlify. Omar lo va a subir a GitHub; hasta entonces no hay "rama" ni
   "repositorio" que leer.
2. **El sitio publicado ya es la versión más nueva** **[verificado hoy, 17:40]**.
   Varias cosas que la ronda 2 pide ya están hechas y publicadas (detalle en el
   punto 5).
3. **Tu documento parte de un concepto que Omar ya cambió.** Ver punto 1.

## 1. Correcciones al documento de sincronización

Decisiones de Omar, tomadas en conversación conmigo. Tienen prioridad sobre lo
que diga cualquier especificación anterior:

| Tu documento dice | Estado real |
|---|---|
| Proyecto "Open Sky Archive (OUAP)", agencia ficticia | Se llama **MIRA** — Mapa de Incidentes y Reportes Anómalos. **No es una agencia ficticia**: es un proyecto independiente. La palabra "OUAP" ya no aparece en el sitio **[verificado]**. Lo único que queda del nombre viejo es la dirección `open-sky-archive.netlify.app`. |
| Regla: "no cambiar el concepto (agencia ficticia OUAP)" | Regla vigente: **no volver** a la agencia ficticia. Se conserva la estética de archivo filtrado / terminal. |
| Ko-fi `ko-fi.com/open_sky_archive/support` | El sitio enlaza a `ko-fi.com/darkom0115` **[verificado]**. |
| Panel en `/admin` | Es `/admin.html`. |
| Panel con "nota interna" | No existe. Hay un campo **dictamen**, solo para el estado IFO, y **es público** (se muestra en el expediente). No escribir ahí nada privado. |
| "25 reportes cargados; 22 publicados, 0 pendientes, 4 descartados" | 22 + 4 = 26, no 25. Yo solo puedo ver los publicados: son **22** **[verificado]**. Los pendientes y descartados no los veo sin sesión de administrador **[sin verificar]**. |
| "La pérdida de reportes que ocurrió una vez" | No tengo registro de esa pérdida ni sé su causa **[sin verificar]**. Lo único que conozco: al inicio Omar borró dos reportes de prueba a propósito. Si pasó otra cosa, necesito saber cuándo y qué se perdió. |
| Firma del creador | Omar se identifica como **DARKOM**, y solo aparece en "Acerca de". No se pone en el resto del sitio. |

Además: los 4 casos descartados (Phoenix Lights, Coyame, Roswell, Los Ángeles)
**se quedan descartados**. Omar lo confirmó.

## 2. Estructura del proyecto

- **Sin framework ni paso de compilación.** Son dos archivos HTML con su CSS y
  JavaScript dentro:
  - `index.html` — sitio público: globo, filtros, lista, expediente, formulario
    de 4 pasos, cuentas, votos y aportes, español/inglés.
  - `admin.html` — panel de moderación.
- **Librerías (por CDN):** MapLibre GL JS 5.24.1 (globo), supabase-js, Google
  Fonts. Imágenes de satélite de Esri; búsqueda de lugares con Photon.
- **Archivos SQL**, en el orden en que se corrieron: `supabase.sql` (v1) →
  `moderacion.sql` → `direccion.sql` → `admin.sql` → `comunidad.sql` →
  `reestructura.sql` → `papelera.sql` → `seguridad.sql`. No queda ninguno
  pendiente.
  **Ojo:** el `supabase.sql` actual es la instalación completa desde cero; no
  debe correrse sobre la base que ya existe.
- **Otros:** `RESTAURAR.md` (cómo restaurar), `respaldo/` (acción de GitHub para
  respaldo diario), `netlify/` (función opcional para vista previa en redes).

## 3. Despliegue y pruebas

- **Despliegue manual:** Omar arrastra la carpeta a Netlify. No hay repositorio
  conectado ni rama.
- **Yo no publico ni puedo publicar.** Pruebo en local con datos simulados
  (4 baterías automáticas con Playwright) y leo el sitio real en modo lectura.
  "Verificar recargando el sitio" solo es posible después de que Omar publique.
- **En local:** abrir `index.html` en el navegador. No necesita servidor.
- **Configuración:** no hay variables de entorno. La dirección de Supabase y la
  clave **pública** están escritas en los dos HTML (es correcto que sean
  públicas; la protección son las reglas de la base). La clave `service_role`
  nunca va en el sitio ni en el repositorio.

## 4. Base de datos (Supabase)

| Tabla | Qué guarda |
|---|---|
| `reportes` | Los casos: lugar, coordenadas, fecha, categoría, forma, duración, testigos, rumbo, foto, video, estado, dictamen, `borrado_el` (papelera), `revisar` (aviso automático de posible duplicado o descripción muy corta). |
| `perfiles` | Nombre visible de cada cuenta. |
| `votos` | Voto real/falso por usuario y caso. |
| `comentarios` | Aportes de la comunidad a un caso. Hoy hay 0 **[verificado]**. |
| `admins` | Quién es administrador. |
| `envios` | Control antispam (límite de envíos por hora). Existe y está cerrada al público **[verificado]**. |

Fotos: almacenamiento `evidencias` (público, máx. 2 MB por foto).
Categorías: `fani`, `criptido_alado`, `bestia_atmosferica`, `varillas`,
`serpiente`, `sin_clasificar`. Estados: `pendiente`, `no_identificado`, `ifo`,
`datos_insuficientes`, `descartado`. La clasificación de Hynek se calcula, no se
guarda.

**No existen** (aunque aparecían en la ronda 2): altitud, tamaño aparente,
alias del testigo, "quiero que me contacten", nota interna, tipo de fuente en
los aportes.

## 5. Qué está aplicado y qué no

### Estado real hoy **[verificado]**

Todo lo siguiente está en el código **y publicado**:

- Nombre MIRA, taxonomía nueva, Hynek, formulario de 4 pasos, cuentas, votos.
- Papelera: el panel ya no borra de forma definitiva; se puede restaurar.
- Exportación a JSON y CSV desde el panel.
- Enlace propio por caso (`?caso=`).
- Contador que abre en "Todo".
- Antispam en el formulario (campo trampa, tiempo mínimo) y en la base
  (5 envíos por hora, aviso de posible duplicado).
- Ubicación redondeada a ~1 km: los 22 casos publicados ya están redondeados.

Omar envió un reporte de prueba después de correr `seguridad.sql` y se guardó
bien (dato de Omar; yo no veo los pendientes).

**No activo:** la vista previa en redes. La función de Netlify no se despliega
al arrastrar la carpeta; se activará al conectar Netlify con el repositorio.

### Ronda 1 — tus tres pendientes

- **"Saltillo, Coahuila, Mexico" duplicado:** el código ya quita repetidos
  (mismo nombre y coordenadas casi iguales) y está publicado **[verificado]**.
  Si lo sigues viendo, dime qué escribiste: puede ser que Photon devuelva dos
  lugares con el mismo nombre a más de ~10 km, y esos sí se muestran.
- **"El globo no cierra el panel al hacer clic":** es intencional. El clic en el
  globo solo actúa cuando el usuario eligió "marcar en el mapa". Se puede
  cambiar, pero es decisión de Omar, no un error.
- **Textos en español en modo inglés:** necesito la lista concreta (pantalla y
  texto). Los textos fijos pasan por el diccionario de traducción; lo que
  escribe la gente (descripciones, lugares) no se traduce, y eso es esperado.

### Ronda 2 — primera lectura

- **Hecho y publicado:** exportación, papelera, guía de restauración, enlace por
  caso, antispam, privacidad de ubicación.
- **Hecho, sin probar en real:** respaldo diario (acción de GitHub) y vista
  previa en redes (función de Netlify). Las dos dependen del repositorio.
- **Viable tal como está:** histórico vs. testimonio nuevo (campo + filtro),
  buscador y filtros en el panel, ocultar categorías vacías, glosario de
  estados, accesibilidad.
- **Necesita ajuste:** verificación de fotos (se puede guardar licencia y fuente;
  "verificar" que una foto es auténtica no es algo que el sitio pueda prometer),
  acciones en lote y bitácora del panel (requieren tabla nueva), notificaciones
  al testigo (el plan gratuito de Supabase limita mucho los correos).
- **Falta definir (Omar):** monetización más allá de Ko-fi; si la moderación con
  IA solo ordena la cola o también rechaza.

## 6. Problemas conocidos y partes frágiles

1. **Sin repositorio todavía:** no hay historial de cambios ni forma de que
   Peluchín lea el código real.
2. **Sin respaldo automático funcionando.** El plan gratuito de Supabase no
   respalda, y pausa el proyecto tras una semana sin actividad.
3. **Las fotos no entran en los respaldos**, solo los datos.
4. **Nunca se ha ensayado una restauración.**
5. **Un solo archivo de ~140 KB.** Cómodo para publicar, pesado para revisar
   cambios. Separarlo es posible, pero no urgente.
6. **El límite antispam solo se probó con un envío.** No se ha comprobado que
   el sexto envío en una hora sea rechazado.

## 7. Reglas de trabajo: lo que acepto y lo que ajusto

- **De acuerdo:** no tocar datos reales, no publicar los descartados, trabajar en
  rama con descripción del cambio, decir cuando algo no es viable.
- **Ajuste 1:** las especificaciones deben escribirse **leyendo los archivos del
  repositorio**, no de memoria. Las dos rondas describían funciones que no
  existían.
- **Ajuste 2:** si una especificación choca con una decisión de Omar, gana Omar.
- **Ajuste 3:** propongo un archivo `DECISIONES.md` en el repositorio donde se
  anoten las decisiones de Omar con fecha. Así ninguno de los dos las pierde.
- **Pregunta para Peluchín:** ¿con qué cuenta moderaste y cómo cargaste los
  reportes (por el formulario o directo en Supabase)? Me sirve para entender por
  qué unas coordenadas vienen redondeadas y otras no.

## 8. Qué necesito

- **De Omar:** el nombre del repositorio cuando exista, y conectar Netlify a él.
  (Publicar la versión nueva, correr `seguridad.sql` y el envío de prueba ya
  están hechos.)
- **De Peluchín:** la lista de textos sin traducir, el caso exacto de Saltillo,
  y lo que sepa de la pérdida de reportes.

---

*Preparado por Claude para Omar y Peluchín, 2026-11-14.*
