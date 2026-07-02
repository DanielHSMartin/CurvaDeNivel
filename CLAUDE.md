# Curva de Nivel — QGIS Plugin

QGIS Processing plugin that generates contour lines from elevation data (INPE TOPODATA for Brazil, Copernicus GLO-30 globally). Downloads DEM tiles, caches them locally, clips/merges/smooths, and produces a styled contour layer.

- **Key files**:
  - `curva_de_nivel_algorithm.py`: core Processing algorithm — DEM tile selection/download, clipping, contour generation, smoothing, symbology, hillshade overlay.
  - `curva_de_nivel_provider.py`: registers the algorithm with QGIS Processing.
  - `curva_de_nivel.py`: plugin entry point (`initGui`/`unload`).
  - `gdal_calc.py`: **vendored** upstream GDAL utility, not our code — don't "fix" its style/patterns to match the rest of the plugin.
  - `metadata.txt`: plugin listing metadata for plugins.qgis.org — `version=` and `changelog=` live here.

## This folder is the git repo — commit here directly

This directory doubles as the live QGIS plugin install (QGIS loads plugins straight from `~/.../QGIS3/profiles/default/python/plugins/`) AND the git working copy tracking `github.com/DanielHSMartin/CurvaDeNivel` (`origin/main`). There's no separate monorepo — this is the whole project.

- Commit here directly on `main` after the user approves a change. Do NOT push without an explicit go-ahead — `main` here is the public plugin repo.
- `.claude/` (this session's local config) is gitignored — never commit it.

## Releasing to the QGIS plugin repository (plugins.qgis.org)

ALWAYS build the upload zip with `./package.sh` (**NOT** `make zip`/`make package` — the Makefile's `PY_FILES` list is stale, it only lists `__init__.py` and `curva_de_nivel.py` and silently omits `curva_de_nivel_algorithm.py`, `curva_de_nivel_provider.py`, and `gdal_calc.py`).

Before building: bump `version=` in `metadata.txt` and add a `changelog=` entry for it.

`package.sh` runs 4 gate checks before zipping and aborts on failure. The QGIS server re-runs its own equivalents on every upload and flags the plugin for **manual review (can take weeks)** on failure — a passing local run is necessary but this only actually protects an upload if the local check scans every file that ships. Excluding a shipped file from bandit to make a local run pass (rather than fixing the finding) is worthless — the server scans it regardless. This exact mistake happened for v1.1.3 (see incident note below); the fix is always to resolve the finding in the source (suppress with a correctly-placed `# nosec`, or fix the code), never to exclude a shipped file from the local scan.

1. **Secrets detection** (`detect-secrets` — `pip install detect-secrets`): no hardcoded secrets/high-entropy strings. This plugin ships no credentials today; if one is ever added, mark intentionally-public values with `# pragma: allowlist secret`.
2. **metadata.txt parses** with Python `configparser` (BasicInterpolation): a raw `%` in any value (e.g. "80%") breaks the upload — reword or escape as `%%`.
3. **Bandit security scan** (`pip install bandit`), zero Medium/High findings:
   ```
   bandit -r . -x ./test/,./plugin_upload.py,./scripts/ --severity-level medium -q
   ```
   `test/`, `scripts/`, and `plugin_upload.py` are excluded here because they're dev-only and never ship — excluding a *shipped* file just to silence a real finding is exactly the mistake that got a v1.1.3 upload flagged for manual review (see incident note below). `gdal_calc.py` IS scanned; its one real finding (`eval()`, B307, inherent to vendored GDAL's `--calc` feature) is suppressed with an inline `# nosec B307` comment **on the exact line with `eval(`** — Bandit only honors `# nosec` as a trailing comment on the flagged line itself, not a comment above it. If this plugin ever builds a SQL/OGR query, never use f-strings or concatenation to build it (Bandit B608) — use two static query strings conditioned on a boolean instead of interpolating a clause.
4. **Suspicious files**: after zipping, the script verifies no hidden (dot-prefixed) file made it into the archive. If you add a new dev-only dotfile/dir, add it to `EXCLUDES` in `package.sh`.

NEVER package: hidden files (`.git`, `.vscode`, `.claude`, `.DS_Store`, ...), `__pycache__`/`*.pyc`, `CLAUDE.md`, or the dev-only `test/`, `help/`, `i18n/`, `Support/`, `scripts/`, `Makefile`, `pb_tool.cfg`, `pyrightconfig.json`, `pylintrc`, `plugin_upload.py`. `package.sh`'s `EXCLUDES` list is the single source of truth for this — check it before adding new top-level dev files.

Upload is outward-facing — do NOT run it automatically; it needs the user's credentials: `python3 plugin_upload.py -u USER -w PASS ../curva_de_nivel_<version>.zip` (or the plugins.qgis.org web UI).

## Known pre-existing issue

`.DS_Store` is accidentally tracked in git history (from an old commit) even though `.gitignore` lists it. `package.sh` excludes it from the shipped zip regardless, so it's cosmetic — worth a `git rm --cached .DS_Store` cleanup at some point, but hasn't been done.

## Incident: v1.1.3 flagged for manual review

`gdal_calc.py` had a correctly-placed trailing `# nosec B307` on its `eval()` call that successfully suppressed the finding. A PEP8 line-length reflow of that line (bundled into the v1.1.2 lint-cleanup commit) moved the comment onto its own line *above* `eval(` — Bandit silently stopped honoring it, since `# nosec` must be a trailing comment on the exact flagged line. Rather than noticing the suppression broke, `package.sh`'s bandit check was given a blanket `-x .../gdal_calc.py` exclusion, which made the *local* check pass while leaving the real finding live in every shipped zip. plugins.qgis.org's own scan caught it on the v1.1.3 upload and flagged the plugin for manual review. Fixed by moving `# nosec B307` back onto the `eval(` line and removing the exclusion — always verify a `# nosec` suppression actually works (check bandit's "issues skipped" count) instead of assuming it does.
