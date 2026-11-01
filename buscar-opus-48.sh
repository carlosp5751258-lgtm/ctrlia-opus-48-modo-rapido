#!/bin/bash
# ¿Te afecta la retirada del modo rápido de Opus 4.8 (error desde el 30-nov-2026)?
# Busca claude-opus-4-8 y fastMode en ajustes, variables de entorno, scripts y CI.
# Uso: ./buscar-opus-48.sh [carpeta ...]   (por defecto: ~/.claude y la carpeta actual)
# Sale con 1 si encuentra claude-opus-4-8 (útil en CI) y con 0 si no.
set -euo pipefail
if [ $# -gt 0 ]; then carpetas=("$@"); else carpetas=("$HOME/.claude" "."); fi
yo=$(basename "$0")
# --include van antes que --exclude: en GNU grep, si la primera es --exclude, los archivos que no coinciden se incluyen
modelo='claude-opus-4-8'
encontrado=0

echo "== Ajustes (settings*.json): model y fastMode"
grep -rn --include='settings*.json' -e "$modelo" -e 'fastMode' "${carpetas[@]}" 2>/dev/null || echo "(nada)"
grep -rqs --include='settings*.json' -e "$modelo" "${carpetas[@]}" && encontrado=1

echo "== Variables de entorno"
env | grep -E '^ANTHROPIC_(DEFAULT_OPUS_)?MODEL=' || echo "(ninguna)"
env | grep -qE "^ANTHROPIC_(DEFAULT_OPUS_)?MODEL=$modelo" && encontrado=1

echo "== Scripts y CI (*.sh, *.yml, *.yaml)"
grep -rn --include='*.sh' --include='*.yml' --include='*.yaml' --exclude="$yo" -e "$modelo" "${carpetas[@]}" 2>/dev/null || echo "(nada)"
grep -rqs --include='*.sh' --include='*.yml' --include='*.yaml' --exclude="$yo" -e "$modelo" "${carpetas[@]}" && encontrado=1

if [ "$encontrado" -eq 1 ]; then
  echo "Tienes Opus 4.8 fijado: cámbialo por claude-opus-5-5 (o el alias opus) donde uses el modo rápido."
  exit 1
fi
echo "Sin fijaciones a Opus 4.8: no tienes que hacer nada."
