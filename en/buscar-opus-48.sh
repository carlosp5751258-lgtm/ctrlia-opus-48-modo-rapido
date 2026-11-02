#!/bin/bash
# Are you affected by the retirement of Opus 4.8 fast mode (error from 30 Nov 2026)?
# Looks for claude-opus-4-8 and fastMode in settings, environment variables, scripts and CI.
# Usage: ./buscar-opus-48.sh [folder ...]   (default: ~/.claude and the current folder)
# Exits with 1 if it finds claude-opus-4-8 (useful in CI) and with 0 if not.
set -euo pipefail
if [ $# -gt 0 ]; then folders=("$@"); else folders=("$HOME/.claude" "."); fi
me=$(basename "$0")
# --include goes before --exclude: in GNU grep, if the first one is --exclude, files that don't match are included
model='claude-opus-4-8'
found=0

echo "== Settings (settings*.json): model and fastMode"
grep -rn --include='settings*.json' -e "$model" -e 'fastMode' "${folders[@]}" 2>/dev/null || echo "(nothing)"
grep -rqs --include='settings*.json' -e "$model" "${folders[@]}" && found=1

echo "== Environment variables"
env | grep -E '^ANTHROPIC_(DEFAULT_OPUS_)?MODEL=' || echo "(none)"
env | grep -qE "^ANTHROPIC_(DEFAULT_OPUS_)?MODEL=$model" && found=1

echo "== Scripts and CI (*.sh, *.yml, *.yaml)"
grep -rn --include='*.sh' --include='*.yml' --include='*.yaml' --exclude="$me" -e "$model" "${folders[@]}" 2>/dev/null || echo "(nothing)"
grep -rqs --include='*.sh' --include='*.yml' --include='*.yaml' --exclude="$me" -e "$model" "${folders[@]}" && found=1

if [ "$found" -eq 1 ]; then
  echo "You have Opus 4.8 pinned: change it to claude-opus-5-5 (or the opus alias) wherever you use fast mode."
  exit 1
fi
echo "No Opus 4.8 pins: you don't need to do anything."
