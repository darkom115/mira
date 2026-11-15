# Cómo restaurar MIRA si algo sale mal

Guarda este archivo junto con tus respaldos.

## Qué tienes respaldado

- **Automático (diario):** el repositorio privado de GitHub con la carpeta `respaldos/`,
  que trae `reportes.json`, `perfiles.json`, `comentarios.json`, `votos.json` y `admins.json`.
- **Manual:** los botones **Exportar JSON** y **Exportar CSV** del panel de administración.
- **Las fotos NO están en esos respaldos.** Viven en Supabase → Storage → `evidencias`.
  Para guardarlas, entra a Storage y usa **Download** sobre la carpeta, de vez en cuando.

## Caso 1: borraste un caso por error

No hace falta restaurar nada. Entra al panel → pestaña **Papelera** → **Restaurar**.
Los casos solo desaparecen de verdad si usas "Eliminar definitivamente".

## Caso 2: se perdió la base de datos completa

1. Crea un proyecto nuevo en Supabase (o usa el mismo si sigue vivo).
2. En **SQL Editor**, corre `supabase.sql` completo. Eso crea las tablas, los permisos
   y las reglas de seguridad, pero vacías.
3. Corre también `papelera.sql`.
4. Vuelve a crear tu usuario en **Authentication → Users** y date permisos:
   ```sql
   insert into public.admins (user_id)
   select id from auth.users where email = 'TU-CORREO@ejemplo.com';
   ```
5. Abre `respaldos/reportes.json`, copia **todo** su contenido y corre esto en el
   SQL Editor, pegando el JSON entre las comillas simples:

   ```sql
   insert into public.reportes
   select * from json_populate_recordset(null::public.reportes, '<PEGA AQUÍ EL JSON>');
   ```

   Repite lo mismo con `comentarios.json` y `votos.json` cambiando el nombre de la tabla.
   (`perfiles` depende de las cuentas de usuario: si las cuentas se perdieron, esos
   registros ya no sirven.)
6. Si la URL del proyecto cambió, actualiza `SUPABASE_URL` y `SUPABASE_KEY` en el
   PASO 0 de `index.html` y en `admin.html`, y vuelve a publicar en Netlify.

## Caso 3: se cayó Netlify o perdiste el sitio

El sitio son dos archivos: `index.html` y `admin.html`. Súbelos de nuevo a
app.netlify.com/drop. La base de datos no se toca.

## Prueba la restauración antes de necesitarla

Haz esto una vez, con calma:

1. Crea un segundo proyecto de Supabase de prueba (el plan gratis permite dos).
2. Sigue el Caso 2 completo contra ese proyecto.
3. Apunta cuánto tardaste y qué se te atoró.

Si nunca lo pruebas, no sabes si tu respaldo sirve.
