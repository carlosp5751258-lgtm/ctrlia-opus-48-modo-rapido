# Claude Code Opus 4.8: fast mode ends on 30 Nov, move to 5.5

[Leer en español](README.md): the Spanish version is at the repository root and in README.md; the English files are in `en/`.

From 30 Nov 2026, fast mode requests with Opus 4.8 will return an error (Claude Code 2.1.316 CHANGELOG). This repo brings a script that finds where you have Opus 4.8 pinned and the settings to move to Opus 5.5.

The full recipe (who is affected, migrating in three steps, Opus 5.5 price and effort, turning on fast mode without overpaying and common errors):

- English: https://ctrlia.dev/en/recetas/opus-48-modo-rapido.html
- Español: https://ctrlia.dev/recetas/opus-48-modo-rapido.html

## What's included

| File | What for |
| --- | --- |
| `en/buscar-opus-48.sh` | Looks for `claude-opus-4-8` and `fastMode` in `settings*.json`, in `ANTHROPIC_MODEL` / `ANTHROPIC_DEFAULT_OPUS_MODEL` and in `*.sh`, `*.yml` and `*.yaml`. Exits with `1` if it finds Opus 4.8 |
| `en/settings-despues.json` | `"model": "claude-opus-5-5"` with `"fastMode": true` |
| `en/settings-equipo.json` | `fastModePerSessionOptIn: true`: each session starts with fast mode off |

## How to use it

```bash
git clone https://github.com/carlosp5751258-lgtm/ctrlia-opus-48-modo-rapido.git
cd ctrlia-opus-48-modo-rapido
./en/buscar-opus-48.sh                        # checks ~/.claude and the current folder
./en/buscar-opus-48.sh ~/projects ~/.claude   # or the folders you pass it
```

If it finds anything, change `claude-opus-4-8` to `claude-opus-5-5` (or the `opus` alias) wherever you use fast mode. In scripts and CI:

```bash
# before (will error from 30 Nov 2026)
claude -p --model claude-opus-4-8 --settings '{"fastMode": true}' "Review the tests"
# after
claude -p --model claude-opus-5-5 --settings '{"fastMode": true}' "Review the tests"
```

For the settings, merge the key you need into your `~/.claude/settings.json` (don't overwrite it). Opus 5.5 starts at `medium` effort (Opus 4.8, `high`): if you notice, `/effort high`. Fast mode is paid with usage credits, on subscriptions too.

## What was tested

`bash -n` on the script, `python3 -m json.tool` on the settings and the script in test folders: a project with a `settings.json` and a CI workflow on Opus 4.8 (finds it and exits with `1`), an already migrated one (exits with `0` and does not find itself), `ANTHROPIC_MODEL=claude-opus-4-8` in the environment (exits with `1`) and a folder that doesn't exist (exits with `0`). With Claude Code **2.1.316**, `/effort status` on Opus 5.5 answered "auto (currently medium)". Fast mode was not turned on (it costs usage credits) and the post-30 Nov error cannot be reproduced before that date.

## License

MIT. See [LICENSE](LICENSE).

---
Part of **[Ctrl+IA](https://ctrlia.dev/en/)**: Claude Code like a pro. Made by Carlos P.
