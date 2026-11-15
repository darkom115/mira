# MIRA — Mapa de Incidentes y Reportes Anómalos

Sitio público para registrar y consultar avistamientos de fenómenos aéreos y
críptidos en el norte de México y el sur de Estados Unidos. Proyecto
independiente; su autor firma como **DARKOM**.

- **Sitio publicado:** https://open-sky-archive.netlify.app
- **Base de datos, cuentas y fotos:** Supabase
- **Mapa:** MapLibre GL JS (globo 3D), imágenes de satélite de Esri, búsqueda
  de lugares con Photon/OpenStreetMap

## Cómo está armado

No hay framework ni paso de compilación: son dos archivos HTML con su CSS y su
JavaScript dentro. Para trabajar en local, basta abrir `sitio/index.html` en el
navegador.

```
sitio/index.html   Sitio público: globo, filtros, lista, expediente,
                   formulario de 4 pasos, cuentas, votos y aportes, ES/EN
sitio/admin.html   Panel de moderación (se abre en /admin.html)
sql/               Cambios a la base de datos, en orden (ver abajo)
docs/              Informes y especificaciones de mejoras
netlify/           Función que genera la vista previa de los enlaces ?caso=
netlify.toml       Configuración de despliegue (publica la carpeta sitio/)
RESTAURAR.md       Cómo restaurar datos si algo se pierde
DECISIONES.md      Decisiones de Omar, con fecha. Manda sobre cualquier otro doc
```

## Orden de los archivos SQL

Ya se corrieron todos, en este orden, sobre el proyecto de Supabase:

1. `supabase.sql` — instalación completa. **Solo para una base nueva**; no
   correr sobre la que ya existe.
2. `moderacion.sql`
3. `direccion.sql`
4. `admin.sql` — antes de correrlo hay que cambiar el correo de la última línea.
   En el repositorio va con un correo de ejemplo, a propósito.
5. `comunidad.sql`
6. `reestructura.sql`
7. `papelera.sql`
8. `seguridad.sql`

`semilla.sql` es opcional: mete casos de ejemplo.

## Cómo se publica

Netlify toma los cambios de este repositorio y publica la carpeta `sitio/`.
Cada cambio que se suba a la rama principal se publica solo.

No hay variables de entorno. La dirección de Supabase y su clave **pública**
están escritas dentro de los HTML; eso es correcto, porque la protección real
son las reglas (RLS) de la base de datos.

## Qué nunca va en este repositorio

- La clave `service_role` de Supabase, ni ninguna contraseña.
- Los respaldos de la base: traen datos de personas y van en un repositorio
  privado aparte.
- El correo real del administrador (`sql/admin.sql` va con uno de ejemplo).

## Cómo trabajamos aquí

En el proyecto colaboran dos asistentes de IA, y Omar es el puente entre ellos:

- **Peluchín** investiga, modera contenido y escribe las especificaciones de
  mejoras en `docs/`.
- **Claude** implementa los cambios en el código.

Reglas para los dos:

1. **Leer los archivos de este repositorio antes de describir o cambiar algo.**
   Nada de trabajar de memoria: las dos primeras rondas de mejoras describían
   funciones que no existían.
2. Las decisiones de `DECISIONES.md` manda sobre cualquier especificación.
3. No modificar, borrar ni publicar reportes existentes sin autorización de Omar.
4. No enviar reportes reales: para probar, datos de prueba.
5. Si una especificación no es viable tal como está escrita, decirlo y proponer
   una alternativa; no improvisar en silencio.
