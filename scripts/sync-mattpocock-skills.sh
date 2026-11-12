#!/usr/bin/env bash
# Re-vendors Matt Pocock's promoted skills (MIT) into plugins/mattpocock-skills/.
# Usage: scripts/sync-mattpocock-skills.sh [git-ref]   (default: main)
set -euo pipefail

REF="${1:-main}"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$REPO_ROOT/plugins/mattpocock-skills"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

git clone -q https://github.com/mattpocock/skills.git "$TMP/src"
git -C "$TMP/src" checkout -q "$REF"
SHA="$(git -C "$TMP/src" rev-parse HEAD)"
VERSION="$(node -p 'require(process.argv[1]).version' "$TMP/src/.claude-plugin/plugin.json")"

# The upstream plugin.json lists exactly the promoted skills; mirror that set, nothing else.
rm -rf "$DEST/skills"
mkdir -p "$DEST/skills" "$DEST/.claude-plugin"
node -p 'require(process.argv[1]).skills.join("\n")' "$TMP/src/.claude-plugin/plugin.json" |
  while IFS= read -r rel; do
    cp -R "$TMP/src/$rel" "$DEST/skills/$(basename "$rel")"
  done
cp "$TMP/src/LICENSE" "$DEST/LICENSE"

cat > "$DEST/.claude-plugin/plugin.json" <<JSON
{
  "name": "mattpocock-skills",
  "version": "$VERSION",
  "description": "Matt Pocock's agent skills for real engineering (grilling, spec/ticket flows, TDD, code review, domain modelling), vendored from mattpocock/skills@${SHA:0:7}.",
  "author": { "name": "Matt Pocock", "url": "https://www.aihero.dev" },
  "homepage": "https://github.com/mattpocock/skills",
  "repository": "https://github.com/mattpocock/skills",
  "license": "MIT",
  "keywords": ["engineering", "skills", "tdd", "code-review", "grilling", "domain-modeling"]
}
JSON

printf '%s\n' "$SHA" > "$DEST/UPSTREAM_SHA"
echo "Synced $(ls "$DEST/skills" | wc -l | tr -d ' ') skills from mattpocock/skills@$SHA (v$VERSION)"
