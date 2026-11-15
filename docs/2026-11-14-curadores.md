# Para Peluchín — eres curador, y qué cambió hoy

Escrito por Claude, 14 de noviembre de 2026, después de tu revisión como
visitante. Lee también `docs/como-trabajamos.md` y `DECISIONES.md`.

## 1. Tu hallazgo del globo era real

Los marcadores sí estaban mal colocados, y la causa era una regla de CSS del
sitio (`position: relative`) que anulaba la de MapLibre: cada marcador quedaba
en el flujo del documento y caía 14 píxeles más al sur que el anterior. Medido
en el sitio publicado: desvíos de 0, 14, 28, 42, 56, 70, 84 y 98 píxeles, en
orden. Ahora el desvío es cero en los 22 casos, y hay una prueba automática que
lo vigila.

De tu revisión también quedaron hechos: la tarjeta explica el sello de estado y
el índice de evidencia sin depender del tooltip, la foto se ve sin bajar dentro
de la tarjeta, el formulario marca los campos obligatorios desde el inicio y
promete la privacidad antes de pedir la ubicación, el buscador ya no repite
lugares ni corta su texto de ayuda, hay leyenda de los códigos del globo
(CA, BA, VAR…), leyenda de la vista Calor y barra de avance en Reproducir.

Tres cosas de tu reporte no eran del código: el "EE. UU." en modo inglés es el
texto que escribiste en el campo *lugar* de cada caso, las coordenadas del
cursor sobre los paneles funcionan así a propósito, y la caja cortada "…ro"
sobre el Golfo no se pudo reproducir — manda captura si vuelve a salir.

## 2. Lo demás que cambió

- **Avistamiento o caso documentado.** Los casos tienen ahora un campo `origen`
  y otro `fuente`. La fuente salió del final de la descripción y vive en su
  propio campo; también se limpiaron los "(Estado: ...)". Los casos anteriores
  a 2020 quedaron marcados como documentados.
- **Entrar con Discord**, además del correo y la contraseña.
- **El sitio tiene ícono.**

## 3. Ahora eres curador

Hasta hoy, Omar era el único que decidía qué se publica. Eso cambió.

**Cómo funciona:**

- Entras a **https://open-sky-archive.netlify.app/revision.html** con tu cuenta
  de Discord.
- Ves la cola de pendientes, que nadie más puede ver.
- Votas una vez por caso: **publicar**, **faltan datos** o **descartar**, con
  una nota opcional para los demás curadores.
- **Cuando dos curadores coinciden, el caso se mueve solo.** La regla vive en
  la base de datos, no en la página.
- Tu voto no se puede cambiar y queda registrado con tu nombre. Cada expediente
  publicado dirá por cuántos curadores pasó.

**Lo que un curador no puede hacer:** borrar casos, mandarlos a la papelera o
tocar los ya resueltos. Eso sigue siendo de Omar.

**Para que te den acceso:** entra una vez al sitio con tu cuenta de Discord
(basta con iniciar sesión) y avísale a Omar; él te añade con una línea de SQL.

**Criterio, para que votemos parecido:**

- *Publicar* no significa dar por cierto el avistamiento. Significa que el
  reporte está completo, es de buena fe y se puede ubicar.
- *Faltan datos* es para lo incompleto pero honesto: sin fecha utilizable, sin
  lugar claro, descripción de dos palabras.
- *Descartar* es solo para spam, bromas evidentes o lo imposible de ubicar.

**Una regla nueva que te toca a ti en particular:** si tú cargaste un caso, no
lo apruebes tú. Que lo revise otro curador. No por desconfianza, sino porque un
archivo donde quien aporta también aprueba no es verificable, y eso es
justamente lo que criticaba tu propia revisión.

## 4. Lo que te pido

1. **Corrige el campo *lugar*** de los casos que escribiste con "EE. UU." para
   que funcione en inglés, cuando tengas acceso de curador o pidiéndoselo a
   Omar.
2. **Tu opinión sobre una propuesta de clasificación** que llegó de otra IA, en
   cinco niveles: testimonio, material aportado, corroboración independiente,
   evidencia instrumental e investigación documentada. Es más rigurosa que el
   índice de evidencia de 0 a 5 que tenemos. Como eres quien más ha trabajado
   el contenido, ¿la ves aplicable a los 22 casos publicados?
