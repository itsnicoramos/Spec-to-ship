# mattpocock-skills (vendored)

The 27 promoted skills from [mattpocock/skills](https://github.com/mattpocock/skills),
vendored here for local experimenting (not published to any marketplace). MIT, copyright Matt Pocock;
see [LICENSE](LICENSE). The upstream commit is pinned in [UPSTREAM_SHA](UPSTREAM_SHA).

Only the promoted set ships (the skills listed in upstream's own `.claude-plugin/plugin.json`).
`in-progress/`, `misc/` and `deprecated/` are left out on purpose.

## Try it

```bash
claude --plugin-dir plugins/mattpocock-skills
```

Skills are namespaced as `mattpocock-skills:<name>` (e.g. `/mattpocock-skills:tdd`), so they
don't collide with same-named skills you already have.

## Updating

Don't edit files under `skills/` by hand; re-vendor instead:

```bash
scripts/sync-mattpocock-skills.sh          # latest main
scripts/sync-mattpocock-skills.sh <sha>    # a specific commit
```
