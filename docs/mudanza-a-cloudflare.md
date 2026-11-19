# Mudar MIRA a Cloudflare Pages

> Fecha: 2026-11-18. Para Omar.
>
> **Por qué.** El plan gratuito de Netlify da 300 créditos al mes y cada
> publicación cuesta unos 15, así que alcanza para unas 20 al mes. Entre el
> 14 y el 18 de noviembre se gastaron 19 publicaciones (285 créditos) y
> Netlify pausó los despliegues hasta el 13 de diciembre. El sitio sigue en
> línea, pero congelado en la versión del 14.
>
> Cloudflare Pages es gratis y da 500 publicaciones al mes. El sitio es
> estático, así que cabe de sobra.

El repositorio ya quedó listo. Falta conectar la cuenta, y eso solo lo
puedes hacer tú.

---

## 1. Crear el proyecto en Cloudflare

1. Entra a `dash.cloudflare.com` y crea una cuenta gratuita (o entra si ya
   tienes una).
2. En el menú de la izquierda: **Workers & Pages** → **Create** →
   pestaña **Pages** → **Connect to Git**.
3. Autoriza a Cloudflare a ver tu GitHub y elige el repositorio
   **darkom115/mira**.
4. En la pantalla de configuración pon exactamente esto:

   | Campo | Valor |
   |---|---|
   | Project name | `mira` (o el que quieras: define la dirección) |
   | Production branch | `main` |
   | Framework preset | **None** |
   | Build command | *vacío* (si no deja vacío, escribe `exit 0`) |
   | Build output directory | `sitio` |
   | Root directory | déjalo como está |

5. **Save and Deploy.**

En un par de minutos te da una dirección del tipo
`https://mira.pages.dev`. Ábrela y comprueba que el globo carga y que los
22 casos aparecen.

---

## 2. Avisarle a Supabase de la dirección nueva

**Esto es obligatorio o se rompe la entrada con Discord.** El sitio le pide
a Supabase que lo regrese a su propia dirección después de iniciar sesión,
y Supabase solo acepta direcciones que tenga en su lista.

1. En Supabase: **Authentication** → **URL Configuration**.
2. En **Site URL** pon la dirección nueva de Cloudflare.
3. En **Redirect URLs** agrega las dos, con asterisco al final:
   - `https://mira.pages.dev/**`
   - `https://open-sky-archive.netlify.app/**` (déjala, por si vuelves)
4. Guarda y prueba entrar con Discord en la dirección nueva.

En Discord no hay que tocar nada: su enlace de regreso apunta a Supabase,
no al sitio.

---

## 3. Comprobar que todo quedó

- [ ] El globo carga y se ven los casos.
- [ ] Entrar con Discord funciona.
- [ ] La sala de revisión responde: `tu-direccion/revision.html`.
- [ ] El panel de administración responde: `tu-direccion/admin.html`.
- [ ] Al compartir un caso (`tu-direccion/?caso=<id>`) la vista previa
      muestra el título del caso y no el genérico. Se prueba pegando el
      enlace en WhatsApp o en la caja de un mensaje de Discord, sin enviarlo.

---

## 4. Después

- **Cambiar los enlaces que ya repartiste**: tu página de Ko-fi, lo que
  hayas puesto en redes, y la dirección que le pasaste a Luna.
- **El dominio propio.** Esta mudanza es buen momento: con un dominio
  tuyo la dirección deja de depender de dónde esté alojado el sitio, y de
  paso se arregla que el sitio se llame MIRA pero la dirección diga
  "open-sky-archive". Cloudflare vende dominios al costo y se conecta solo.
- **El sitio de Netlify se queda como está**, en línea y congelado. No lo
  borres todavía: sirve de respaldo hasta que Cloudflare lleve unos días
  funcionando.

---

## Lo que ya está hecho en el repositorio

- `functions/_middleware.js` — la función de vistas previas, traducida a
  Cloudflare. La de Netlify se queda donde estaba, por si acaso.
- `sitio/_routes.json` — hace que esa función solo corra en la portada. Sin
  esto, Cloudflare la ejecutaría en cada imagen y cada archivo del sitio, y
  eso sí se cobra.
- `netlify.toml` — ahora se salta la publicación cuando el commit no toca
  el sitio. Si vuelves a Netlify en diciembre, los cambios de `docs/` y
  `sql/` ya no van a gastar créditos.

---

*Preparado por Claude, 2026-11-18.*
