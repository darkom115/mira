// Vista previa en redes sociales para los enlaces ?caso=<id>
//
// Es la misma función que había en netlify/edge-functions/caso.js, escrita
// para Cloudflare Pages. Se quedan las dos: si algún día el sitio vuelve a
// Netlify, aquella sigue ahí y no hay que rehacer nada.
//
// Cuando alguien comparte https://tu-sitio/?caso=XXXX en WhatsApp, X o
// Facebook, esos servicios piden la página y leen sus etiquetas <meta>.
// Como el sitio es una sola página, todas dirían lo mismo. Esto intercepta
// la petición, busca ese caso en Supabase y reescribe título, descripción
// e imagen.
//
// Está escrita para no romper nunca el sitio: si algo falla, devuelve la
// página normal.
//
// Solo se ejecuta en "/" gracias a sitio/_routes.json. Sin ese archivo,
// Cloudflare la ejecutaría en cada imagen y cada archivo del sitio.

const SUPABASE_URL = "https://qaseuvsoghhlwkmnisln.supabase.co";
const SUPABASE_KEY = "sb_publishable_iCFgjYpkNpC89MU--Im12w_IMmMx7cq";

const CATEGORIAS = {
  fani: "FANI",
  criptido_alado: "Críptido alado",
  bestia_atmosferica: "Bestia atmosférica",
  varillas: "Varillas (rods)",
  serpiente: "Serpiente del cielo",
  sin_clasificar: "Sin clasificar"
};

const limpiar = (s) => String(s ?? "")
  .replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;");

export const onRequest = async ({ request, next }) => {
  // Sin ?caso= no hay nada que reescribir: la página tal cual, sin tocarla.
  let id = null;
  try { id = new URL(request.url).searchParams.get("caso"); } catch (e) { /* nada */ }
  if (!id) return next();

  const respuesta = await next();

  // Solo se reescribe HTML. Cualquier otra cosa pasa de largo.
  const tipo = respuesta.headers.get("content-type") || "";
  if (!tipo.includes("text/html")) return respuesta;

  let html;
  try {
    // A partir de aquí ya no podemos devolver "respuesta" (su contenido
    // quedó consumido), sino una copia del texto.
    html = await respuesta.text();

    const r = await fetch(
      `${SUPABASE_URL}/rest/v1/reportes?id=eq.${encodeURIComponent(id)}&select=categoria,lugar,fecha,descripcion,foto_url&limit=1`,
      { headers: { apikey: SUPABASE_KEY } }
    );
    const [caso] = await r.json();
    if (!caso) return new Response(html, { status: respuesta.status, headers: respuesta.headers });

    const fecha = new Date(caso.fecha).toLocaleDateString("es-MX", { dateStyle: "long" });
    const titulo = `${CATEGORIAS[caso.categoria] || "Caso"} · ${caso.lugar} — MIRA`;
    const desc = `${fecha}. ${String(caso.descripcion).slice(0, 180)}`;
    const imagen = caso.foto_url || "";

    const metas = `
  <meta property="og:title" content="${limpiar(titulo)}">
  <meta property="og:description" content="${limpiar(desc)}">
  <meta property="og:type" content="article">
  <meta property="og:url" content="${limpiar(request.url)}">
  ${imagen ? `<meta property="og:image" content="${limpiar(imagen)}">` : ""}
  <meta name="twitter:card" content="${imagen ? "summary_large_image" : "summary"}">
  <meta name="description" content="${limpiar(desc)}">
`;
    const nuevo = html.replace("</head>", metas + "</head>")
                      .replace(/<title>[^<]*<\/title>/, `<title>${limpiar(titulo)}</title>`);

    const cabeceras = new Headers(respuesta.headers);
    cabeceras.set("content-type", "text/html; charset=utf-8");
    return new Response(nuevo, { status: respuesta.status, headers: cabeceras });
  } catch (e) {
    // Ante cualquier problema, la página tal cual.
    if (html !== undefined) {
      return new Response(html, { status: 200, headers: { "content-type": "text/html; charset=utf-8" } });
    }
    return respuesta;
  }
};
