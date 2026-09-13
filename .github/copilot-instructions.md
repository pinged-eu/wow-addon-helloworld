# Copilot Instructions for wow-addon-helloworld

A World of Warcraft addon (Ace3-based) used as a learning/testing project for GitHub + WoWUp deployment. Not intended to be feature-complete.

## Build / Test / Lint

- **No local build step, linter, or automated test suite exists.** Testing is done in-game by loading the addon in WoW.
- **`.pkgmeta`** (repo root): controls `BigWigsMods/packager` for both workflows below. `package-as: HelloWorld` sets the packaged folder name; the `ignore:` list excludes repo/tooling files (docs, README, CHANGELOG, license/REUSE files, `.github`, `.gitlab*`, editor/CI config, etc.) from the shipped zip. Everything else in the repo (all `.toc` files, `HelloWorld.lua`, `embeds.xml`, `Locales/`, `options/`, `epgp/`, `Libs/Ace3/`, `assets/`) is included by default. When adding new top-level files/folders, decide whether they belong in the shipped addon or need adding to `ignore:`.
- **CI alpha build** (`.github/workflows/build.yaml`): runs on every push except version tags (`tags-ignore: v*`), after a REUSE license-compliance check. Uses `BigWigsMods/packager@v2` with `args: -d` (skip uploading) to build the same package the real release would produce, but without a tag the packager auto-detects it as an **alpha build** (`@alpha@` code blocks are kept, version string includes the git describe suffix, e.g. `v12.1.0-10-g6dc80de`). The resulting zip is uploaded as the `helloworld-addon-alpha` GitHub Actions artifact (14-day retention) from `.release/*.zip` — this is a real, loadable addon package, not a partial one.
- **Release** (`.github/workflows/zip.yml`): triggered on `v*` tags, uses `BigWigsMods/packager` with the same `.pkgmeta`, and additionally uploads/publishes to CurseForge/WoWInterface/Wago/GitHub Releases as configured.
- **Local dev install**: run `install.develop.ps1` (as Administrator) to symlink/junction this repo into a local WoW installation's `Interface/AddOns/HelloWorld` for each flavor (`_retail_`, `_classic_`, `_classic_era_`, `_ptr_`, `_beta_`, `_anniversary_`).
- `pre-commit` hooks are configured (`.pre-commit-config.yaml`): trailing whitespace, EOF fixer, YAML/TOML/XML checks, CRLF normalization, prettier. Run `pre-commit run --all-files` if installed.
- Git config requirement: set `core.eol lf` and `core.autocrlf input` (see `docs/git.config.adoc`).

## Architecture

- **Entry point**: `HelloWorld.lua` creates the addon via `LibStub("AceAddon-3.0"):NewAddon("HelloWorld", "AceConsole-3.0", "AceEvent-3.0")` and implements Ace3 lifecycle callbacks (`OnInitialize`, `OnEnable`, `OnDisable`) plus event handlers (e.g. `ZONE_CHANGED`).
- **Libraries**: All third-party Ace3 libs live under `Libs\Ace3\...` and are wired in via `embeds.xml` (`<Include>`/`<Script>` entries). New libraries must be added both to `Libs` and to `embeds.xml`.
- **Multiple `.toc` files** exist per game version/flavor: `HelloWorld.toc` (retail/Midnight), `HelloWorld_Cata.toc`, `HelloWorld_Classic.toc`, `HelloWorld_Mists.toc`, `HelloWorld_TBC.toc`, `HelloWorld_Wrath.toc`. Each declares its own `## Interface:` build number and file load order (`embeds.xml`, `Locales\Locales.xml`, `HelloWorld.lua`, `options\options.lua`, `epgp\epgp.xml`). When changing shared load order or adding files, update **all** relevant `.toc` files.
- **Options UI**: `options/options.lua` defines an `AceConfig-3.0` options table and registers it via `HelloWorld:RegisterOptions()`, called from `OnInitialize` if defined.
- **Localization**: `Locales/Locales.xml` includes per-language files (`enUS.lua`, `deDE.lua`), each calling `LibStub("AceLocale-3.0"):NewLocale("HelloWorld", "<locale>", ...)` with a table of string keys mapped to functions/strings. Addon code accesses strings via `L["key"]`.
- **Persistence**: `AceDB-3.0` manages saved variables (`HelloWorldDb`, declared in the `.toc`), with `defaults.profile` set in `HelloWorld.lua` and profile-change callbacks wired to `RefreshConfig`.
- **epgp/** contains a separate EPGP (loot priority) module (`epgp.lua`/`epgp.xml`) loaded from the `.toc` files.

## Conventions

- **Naming**: Addon/global objects and Ace3 callback functions use `PascalCase` (e.g. `HelloWorld`, `OnInitialize`, `SlashCommand`); local variables use `camelCase`.
- **Formatting** (`.editorconfig`): 2-space indentation, LF line endings, trimmed trailing whitespace, final newline.
- Libraries are consumed exclusively through `LibStub`, never required/imported directly.
- Branching model uses `git-flow`: `develop` is the active WoW Retail branch; release branches are named per expansion (`dragonflight`, `wotlk`, `cataclysm`, `mop`, `thewarwithin`, `midnight` = current live). Feature branches: `feat/<name>`; fixes: `fix/FIXNAMEORID` (applied to both the live release branch and `develop`); translations: `i18n/TRANSLATIONNAMEORID`.
- New localizations require adding both a new `Locales/<locale>.lua` file and a matching entry in `Locales/Locales.xml`, plus `-<locale>` suffixed `Title`/`Notes` fields in every `.toc` file.
- Versioning follows semver (`.semver-version`, `cliff.toml`/`CHANGELOG.adoc` via `git-cliff`); the version must be kept in sync across the `.semver-version` file and the `## Version:` line of every `.toc` file.
