# Informe de usabilidad de MIRA

> Fecha: 2026-11-18. De Claude para Omar y Luna. Dos preguntas: qué tan
> práctico es mandar un reporte, y qué tan llamativo es el sitio para
> alguien que llega por primera vez.
>
> Cómo se hizo: recorrí el sitio en vivo como visitante nuevo, en pantalla
> de teléfono (375 × 812) y en escritorio, con la memoria del navegador
> limpia. Llené el formulario paso a paso sin enviarlo, para no meter datos
> de prueba en la base. Las cifras de abajo están medidas, no estimadas.

---

## Resumen en tres líneas

El formulario está bien pensado: cuatro pasos, cinco campos obligatorios,
sin necesidad de cuenta. **El problema no es lo que pide, es lo que no
avisa:** cuando falta algo, el mensaje de error se dibuja fuera de la
pantalla y el visitante ve que el botón "Siguiente" no hace nada.

El globo es lo más atractivo que tiene MIRA y en escritorio se ve muy bien.
**En teléfono el sitio pierde la línea que explica qué es**, y las etiquetas
del globo se encinan unas sobre otras.

---

# Parte 1 · Qué tan práctico es hacer un reporte

## Lo que está bien

- **No hace falta cuenta.** Se dice claramente en el formulario. Esto es lo
  más importante para que alguien reporte, y ya está resuelto.
- Cuatro pasos numerados ("Paso 2 de 4 · Dónde y cuándo"): el visitante
  siempre sabe cuánto le falta.
- Solo cinco campos obligatorios de catorce.
- La fecha viene llena con la hora actual.
- Los botones son grandes: ninguno baja de 44 píxeles, que es el mínimo
  para el dedo. Esto lo medí en los cuatro pasos.
- Las notas de privacidad están donde se necesitan ("no pedimos tu nombre",
  "la ubicación se publica redondeada a un kilómetro", "no subas fotos
  donde se vean caras o placas").

## Los problemas, del que más estorba al que menos

### 1. Los mensajes de error no se ven (lo más grave)

Cuando falta un campo obligatorio, el formulario **sí** genera el mensaje,
pero lo dibuja debajo del borde de la pantalla:

| Situación | Dónde queda el mensaje | Alto de la pantalla |
|---|---|---|
| Descripción vacía | 881 px | 812 px |
| Sin coordenadas | 930 px | 812 px |

Además el foco no salta al campo que falta y el campo no se marca de ningún
color. Para quien está usando el teléfono, **tocar "Siguiente" simplemente
no hace nada.** No hay forma de saber qué pasó.

Así es como se pierde a alguien que sí quería reportar: no cree que le falte
un dato, cree que el sitio está roto.

*Cómo se arregla:* que al faltar un campo el formulario mueva el foco a ese
campo, lo marque con borde rojo, y ponga el mensaje **arriba** del botón,
no después. Es cambio de pocas líneas.

### 2. Se exige algo que nunca se marcó como obligatorio

"Nombre del lugar" lleva asterisco. Las coordenadas no lo llevan. Pero el
formulario deja pasar sin el nombre y **no deja pasar sin coordenadas**.
Alguien que escribe "Saltillo" en el nombre del lugar y toca "Siguiente"
queda atorado sin entender por qué, porque el único campo marcado ya está
lleno.

*Cómo se arregla:* el asterisco va en "Ubicación", no en "Nombre del lugar".

### 3. "Usar mi GPS" no llena el nombre del lugar

El camino más rápido —alguien que acaba de ver algo y toca el GPS— deja las
coordenadas puestas pero **el campo obligatorio sigue vacío**, así que de
todas formas hay que escribir. Lo mismo al marcar en el globo.

En el código: `ponerUbicacion()` sí sabe llenar el nombre, pero el GPS la
llama sin pasárselo.

*Cómo se arregla:* Photon, el buscador que el sitio ya usa, también hace el
camino inverso (de coordenadas a nombre). Es la misma dirección de internet
con otros parámetros.

### 4. Se pregunta dos veces lo mismo

"¿Cuándo fue?" (de día / al atardecer / de noche) es obligatorio, pero el
paso anterior ya pidió fecha **y hora exacta**, y ya hay coordenadas. Con
esos dos datos el momento del día se calcula solo.

*Cómo se arregla:* proponerlo ya contestado a partir de la hora, y dejar
que el visitante lo corrija si quiere. Pasaríamos de cinco campos
obligatorios a cuatro sin perder ni un dato.

### 5. El texto de arriba se repite en los cuatro pasos

El encabezado fijo (la explicación, "los campos con * son obligatorios" y
"no necesitas cuenta para reportar") ocupa unos 180 píxeles, o sea **el 22 %
de la pantalla del teléfono, en cada uno de los cuatro pasos**. Ya lo leyó
en el primero.

*Cómo se arregla:* dejar ese texto solo en el paso 1.

### 6. El sello de Netlify tapa dos botones

Netlify inyecta un recuadro "Powered by Netlify" de 197 × 64 píxeles pegado
abajo a la derecha. En el paso 3, en teléfono, **tapa los botones "→ E" y
"↘ SE"** de la rosa de los vientos: no se pueden tocar.

No viene de tu código, lo mete Netlify en el plan gratuito. Hay que ver en
la configuración de Netlify si se puede quitar; si no se puede, la solución
es subir esa fila de botones para que no queden debajo.

### 7. Cosas menores

- El aviso de cookies tapa los últimos 120 píxeles hasta que se cierra, justo
  donde están la descripción y el botón "Siguiente".
- El borrador vive solo en la pantalla: si se cierra la pestaña a la mitad,
  se pierde todo lo escrito. Guardarlo en el navegador sería barato.
- La casilla "Apareció también en un radar" se dibuja encima de su texto en
  vez de a un lado.

---

# Parte 2 · Qué tan llamativo es

## Lo que funciona

- **El globo.** En escritorio se ve muy bien: la Tierra oscurecida con los
  puntos encima da exactamente la sensación de pantalla de vigilancia que
  busca el proyecto. Es el mejor activo que tiene MIRA.
- La barra roja de arriba con el último contacto ("hace 4 días · Jalisco,
  México") y el reloj en hora local: dan sensación de archivo vivo.
- El contador grande de 22.
- "▶ Reproducir" para ver los casos aparecer en el tiempo.
- El expediente se lee como un expediente de verdad, con su folio
  (MIRA-2026-C58C), su sello y la glosa de qué significa el sello.
- Cada caso tiene su propia dirección de internet y su botón de copiar
  enlace, que es lo que hace que un caso se pueda compartir.
- Carga rápido: primera imagen en 760 ms, todo en 971 ms.

## Lo que lo frena

### 1. En teléfono no dice qué es (lo más grave de esta parte)

En escritorio, debajo de "MIRA" aparece "Mapa de Incidentes y Reportes
Anómalos". **En teléfono esa línea no se muestra.** Un visitante nuevo con
el celular ve: una barra roja, la palabra MIRA, dos botones y un globo
oscuro con puntos. Nada le dice qué es esto ni por qué debería importarle.

Y la mayoría de la gente va a llegar por teléfono, porque es por donde se
comparten los enlaces.

*Cómo se arregla:* que el subtítulo se vea también en pantalla chica, aunque
sea en una línea más corta.

### 2. Las etiquetas del globo se encinan

En la vista inicial, en teléfono, **19 de las 22 etiquetas se montan sobre
otra** (17 pares encimados). Se lee "FANI FANI FANI" amontonado.

Y lo peor: **21 de los 22 casos dicen la misma palabra**, "FANI". La única
distinta es "CA". O sea que todo ese estorbo no está dando información casi
nunca.

*Cómo se arregla:* quitar el texto cuando el globo está lejos y dejar solo
el punto de color (el color ya dice la categoría), y mostrar el nombre al
tocar o al acercarse. Se gana mucho y no se pierde nada.

### 3. En escritorio hay texto encima de texto

Abajo a la izquierda, el lector de coordenadas del cursor
("28.0000, -104.0000") se dibuja **sobre** la línea del pie ("Proyecto
independiente · Reportes enviados por la comunidad"). Se encinan entre
x = 107 y x = 200. Queda ilegible.

### 4. El control "Tipo de registro" sale cortado

"Todo | Avistamientos | Documentados" no cabe en el panel: "Documentados"
aparece mordido. Pasa en escritorio y en teléfono.

### 5. La leyenda repite la lista que está justo debajo

El bloque "En el globo: FANI · CA = Críptido alado · BA = Bestia
atmosférica · VAR = Varillas (rods) · SER = Serpiente del cielo · SC = Sin
clasificar" ocupa seis renglones… y abajo está la misma lista, pero con los
nombres completos y con el número de casos de cada una. La de abajo es mejor.

### 6. El archivo parece más vacío de lo que está

- Cuatro de las seis categorías muestran 0.
- Cada expediente dice "Parece real · 0 · Parece falso · 0" y "Nadie ha
  aportado todavía".

Un visitante lee eso como "aquí no hay nadie". Esconder las categorías
vacías (ya estaba en la lista de Luna) y cambiar el texto cuando no hay
aportes ayudaría. Esto se cura solo con gente, pero mientras tanto no hay
que anunciarlo seis veces.

### 7. Una duda sobre el caso más reciente

El caso que anuncia la barra roja —lo primero que ve cualquiera— es el de
Jalisco del 14 de noviembre, con evidencia 0/5 y sin foto. Si ese es tu
reporte de prueba, conviene sacarlo, porque es la portada del archivo. Si es
un reporte real de alguien, entonces todo bien y mejor aún.

---

# En qué orden lo haría

| | Qué | Por qué primero |
|---|---|---|
| 1 | Que los errores se vean | Sin esto, el que quiere reportar no puede y no sabe por qué |
| 2 | El asterisco a "Ubicación" | Es el error que más atora |
| 3 | GPS que llene el nombre del lugar | Convierte el camino rápido en de verdad rápido |
| 4 | El subtítulo en teléfono | Es la única línea que dice qué es MIRA |
| 5 | Etiquetas del globo solo de cerca | Lo que más ensucia la primera impresión |
| 6 | Coordenadas encimadas y control cortado | Se ven como descuido |
| 7 | "¿Cuándo fue?" calculado, encabezado una sola vez, categorías vacías | Alivian, no desbloquean |

Del 1 al 3 son del formulario y se hacen juntos. Del 4 al 6 son de
presentación y también se hacen juntos.

---

*Informe preparado por Claude, 2026-11-18. Medido contra el sitio en vivo.*
