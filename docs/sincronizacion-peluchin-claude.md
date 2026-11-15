# Sincronización entre Peluchín y Claude — Open Sky Archive (OUAP)

> **Para Claude:** este documento lo escribió Peluchín, el asistente personal de Omar,
> para que los dos trabajemos en sintonía sobre el mismo proyecto. Léelo completo
> antes de responder. Al final hay una solicitud concreta: un informe del estado
> actual del sitio.

## Quiénes somos

- **Omar Molina** es el dueño del proyecto. Todo lo que hagamos es para su sitio.
- **Peluchín** (yo, quien escribe esto) soy su asistente personal. No escribo código
  en el sitio: investigo, reviso, modero reportes, preparo contenido y redacto
  las especificaciones de mejoras que tú implementas.
- **Claude** (tú) eres quien implementa los cambios de código en el sitio.

## Qué se va a hacer con el repositorio

El objetivo es que el repositorio sea el lugar único de trabajo compartido entre
Peluchín y Claude, para que ninguno de los dos trabaje a ciegas:

1. **Peluchín prepara, Claude implementa.**
   - Peluchín entrega especificaciones en archivos `.md` dentro del repositorio
     (por ejemplo `mejoras-open-sky-archive.md` y
     `mejoras-open-sky-archive-v2.md`), con prioridades, criterios de aceptación
     y restricciones.
   - Claude implementa esos cambios en el código y verifica cada cambio
     recargando el sitio y probando el flujo afectado.
2. **Contenido y moderación.**
   - Peluchín ya cargó 25 reportes de avistamientos (con fotos reales) y moderó
     el panel como @DRKM15. Estado actual: 22 reportes publicados, 0 pendientes,
     4 descartados (Phoenix Lights, Coyame, Roswell, Los Ángeles) que solo se
     publican con autorización explícita de Omar.
   - Peluchín puede seguir preparando contenido y reportes; Claude no debe
     modificar, borrar ni publicar reportes existentes sin autorización de Omar.
3. **Reglas de trabajo en el repositorio.**
   - No cambiar el concepto (agencia ficticia OUAP), la estética de terminal
     clasificada, ni la estructura general de la página.
   - No tocar la lógica de moderación existente salvo lo indicado en las
     especificaciones.
   - No enviar reportes reales ni modificar datos de Supabase salvo en pruebas
     con datos de prueba.
   - Hacer los cambios en una rama y describir qué se cambió, para que Omar y
     Peluchín puedan revisarlo antes de publicar.
   - Si algo de una especificación no es viable tal como está escrita, decirlo
     y proponer la alternativa, no improvisar en silencio.
4. **Cómo nos comunicamos.**
   - Peluchín y Claude no tienen un canal directo entre ellos. Omar es el puente:
     él pasa los archivos y mensajes de uno al otro. Por eso este documento vive
     en el repositorio: para que cualquier cosa que uno deje escrita, el otro la
     encuentre aquí.

## Estado conocido del sitio (lo que Peluchín ya verificó)

- Sitio: https://open-sky-archive.netlify.app — alojado en Netlify.
- Datos: Supabase (base de datos, autenticación y almacenamiento de fotos).
- Mapa: imágenes © Esri; búsqueda de lugares Photon / OpenStreetMap.
- Lado público: globo 3D, franja "ÚLTIMO CONTACTO", panel "Contactos
  registrados" con periodos (24 h / 7 días / 30 días / Todo), botón
  "Reproducir", vistas Radar / Calor, filtros por tipo (FANI, Críptido alado,
  Bestia atmosférica, Varillas (rods), Serpiente del cielo, Sin clasificar),
  sección "Reportes" con buscador, sección "Oleadas", tarjetas de reporte en
  modal, formulario "Registrar contacto" de 4 pasos, selector ES/EN, enlace de
  Ko-fi (https://ko-fi.com/open_sky_archive/support).
- Panel de administración (/admin): pestañas Pendientes, No identificados, IFO,
  Datos insuficientes, Descartados; por reporte: estado, nota interna, Guardar
  y Eliminar. Sin buscador, sin acciones en lote, sin estadísticas y sin
  exportación.
- Ronda 1 de mejoras (archivo `mejoras-open-sky-archive.md`): en su mayor parte
  aplicada por Omar/Claude — quedan pendientes conocidos: la geocodificación
  sigue duplicando "Saltillo, Coahuila, Mexico", el globo no cierra el panel de
  registro al hacer clic, y quedan textos en español en modo EN.
- Ronda 2 de mejoras (archivo `mejoras-open-sky-archive-v2.md`): respaldo y
  exportación de Supabase, antispam, verificación de fotos, URL propia por
  reporte, panel con buscador y lote, notificaciones, simplificación de
  categorías vacías y "Oleadas", y plan de monetización (Ko-fi Membresías
  primero, video/redes, merch, afiliados, premium para investigadores después).

## Solicitud a Claude: informe del estado actual del sitio

Por favor, genera un informe del estado actual del sitio **tal como está en el
repositorio y tal como está desplegado**, para que Peluchín y Omar sepamos desde
dónde partimos. El informe debe incluir:

1. **Estructura del proyecto:** pila tecnológica, framework/librerías, estructura
   de carpetas y archivos principales, y qué hace cada parte (globo, filtros,
   formulario, panel de administración).
2. **Cómo se despliega:** ¿Netlify está conectado al repositorio (despliegue
   automático) o es manual? ¿Qué rama se despliega? ¿Cómo se prueba en local?
3. **Base de datos (Supabase):** tablas existentes, qué guarda cada una, y qué
   variables de entorno o configuración hacen falta para que el sitio funcione.
4. **Qué está aplicado y qué no:** de la ronda 1 de mejoras, qué quedó hecho y
   qué sigue pendiente; y una primera lectura de la ronda 2 (qué es viable tal
   como está escrita, qué necesitaría ajustarse y qué falta por definir).
5. **Problemas conocidos:** errores, deuda técnica o cosas frágiles que hayas
   visto en el código (por ejemplo, la geocodificación duplicada, los textos en
   español en modo EN, la pérdida de reportes que ocurrió una vez).
6. **Qué necesitas de Omar:** accesos, decisiones o información que te falte
   para trabajar (por ejemplo, si el repositorio no es este, dónde está el
   código real del sitio).

El informe debe ser honesto sobre lo que no puedas verificar. Si el código del
sitio no está en este repositorio, dilo claramente en el punto 6: es el dato
más importante del informe.

---

*Documento preparado por Peluchín para Omar y Claude, 2026-11-14.*
