# Cómo trabajamos en este repositorio

Reglas para Luna (antes Peluchín) y para Claude. Omar es el dueño: cuando algo aquí choque
con lo que él diga, gana él.

## Quién toca qué

| Carpeta | Luna | Claude |
|---|---|---|
| `docs/` | **escribe** | escribe |
| `sitio/` | solo lee | escribe |
| `sql/` | solo lee | escribe |
| `netlify/`, `netlify.toml` | solo lee | escribe |
| `DECISIONES.md` | solo lee | escribe, cuando Omar decide algo |

La razón del reparto: todo lo que llega a `main` se publica solo en el sitio
real en menos de un minuto. Un cambio equivocado en `sitio/` sale al aire de
inmediato.

## Cómo se entrega algo

1. **Nunca directo a `main`.** Siempre en una rama propia:
   `luna/<tema>` o `claude/<tema>`.
2. **Abrir un Pull Request** cuando la rama esté lista, con dos líneas que
   digan qué trae y qué hay que revisar. Omar lo aprueba desde el botón verde,
   o pide que lo revise el otro asistente primero.
3. **Una entrega, un archivo**, con fecha en el nombre:
   `docs/2026-11-14-respaldo-diario.md`.
4. **Al unir la rama, borrarla.** No dejar ramas viejas dando vueltas.

## Antes de escribir una especificación

- **Leer el código real**, no la memoria ni la interfaz: `sitio/index.html`,
  `sitio/admin.html` y el SQL correspondiente.
- **Leer `DECISIONES.md`.** Manda sobre cualquier documento.
- Decir qué archivo habría que tocar y qué no hay que tocar.
- Poner criterios de aceptación: cómo se comprueba que quedó bien.
- Si algo no es viable tal como está escrito, decirlo y proponer alternativa.

## Lo que nunca se escribe aquí

El repositorio es **público**. Cualquiera puede leerlo, hoy y dentro de un año.

- **Correos** (ni el del administrador ni el de nadie), contraseñas, claves de
  API, la clave `service_role` de Supabase, tokens.
- **Datos de testigos:** nombres, ubicaciones exactas, contactos.
- **Respaldos de la base.** Van en un repositorio privado aparte.

Si algo así se cuela, no basta con borrarlo en un commit nuevo: hay que
avisarle a Omar para que cambie lo que haya quedado expuesto.

## Lo que no se toca sin permiso de Omar

- Publicar, borrar o modificar reportes existentes.
- Los 4 casos descartados (Phoenix Lights, Coyame, Roswell, Los Ángeles).
- El concepto, el nombre y la estética del proyecto.
- Enviar reportes reales: para probar, datos de prueba.
