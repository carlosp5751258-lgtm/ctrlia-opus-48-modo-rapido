# Claude Code Opus 4.8: el modo rápido acaba el 30-nov, pasa a 5.5

[Read in English](README.en.md)

Desde el 30-nov-2026 las peticiones en modo rápido con Opus 4.8 darán error (CHANGELOG de Claude Code 2.1.316). Este repo trae un script que busca dónde tienes Opus 4.8 fijado y los ajustes para pasar a Opus 5.5.

La receta completa (a quién afecta, migrar en tres pasos, precio y esfuerzo de Opus 5.5, activar el modo rápido sin pagar de más y los errores típicos):

- Español: https://ctrlia.dev/recetas/opus-48-modo-rapido.html
- English: https://ctrlia.dev/en/recetas/opus-48-modo-rapido.html

## Qué incluye

| Archivo | Para qué |
| --- | --- |
| `buscar-opus-48.sh` | Busca `claude-opus-4-8` y `fastMode` en `settings*.json`, en `ANTHROPIC_MODEL` / `ANTHROPIC_DEFAULT_OPUS_MODEL` y en `*.sh`, `*.yml` y `*.yaml`. Sale con `1` si encuentra Opus 4.8 |
| `settings-despues.json` | `"model": "claude-opus-5-5"` con `"fastMode": true` |
| `settings-equipo.json` | `fastModePerSessionOptIn: true`: cada sesión empieza con el modo rápido apagado |

## Cómo usarlo

```bash
git clone https://github.com/carlosp5751258-lgtm/ctrlia-opus-48-modo-rapido.git
cd ctrlia-opus-48-modo-rapido
./buscar-opus-48.sh                       # revisa ~/.claude y la carpeta actual
./buscar-opus-48.sh ~/proyectos ~/.claude # o las carpetas que le pases
```

Si encuentra algo, cambia `claude-opus-4-8` por `claude-opus-5-5` (o por el alias `opus`) donde uses el modo rápido. En scripts y CI:

```bash
# antes (dará error a partir del 30-nov-2026)
claude -p --model claude-opus-4-8 --settings '{"fastMode": true}' "Revisa los tests"
# después
claude -p --model claude-opus-5-5 --settings '{"fastMode": true}' "Revisa los tests"
```

Para los ajustes, junta la clave que necesites con tu `~/.claude/settings.json` (no lo sobrescribas). Opus 5.5 empieza con esfuerzo `medium` (Opus 4.8, `high`): si lo notas, `/effort high`. El modo rápido se paga con créditos de uso, también con suscripción.

## Qué se probó

`bash -n` del script, `python3 -m json.tool` de los ajustes y el script en carpetas de prueba: un proyecto con `settings.json` y un workflow de CI con Opus 4.8 (lo encuentra y sale con `1`), uno ya migrado (sale con `0` y no se encuentra a sí mismo), `ANTHROPIC_MODEL=claude-opus-4-8` en el entorno (sale con `1`) y una carpeta que no existe (sale con `0`). Con Claude Code **2.1.316**, `/effort status` en Opus 5.5 respondió «auto (currently medium)». No se activó el modo rápido (cuesta créditos de uso) y el error posterior al 30-nov no se puede reproducir antes de esa fecha.

## Licencia

MIT. Ver [LICENSE](LICENSE).

---
Parte de **[Ctrl+IA](https://ctrlia.dev/)**: programa con Claude Code como un pro, en español. Hecho por Carlos P.
