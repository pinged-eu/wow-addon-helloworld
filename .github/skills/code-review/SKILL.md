---
name: code-review
description: Guide for reviewing pull requests in the wow-addon-helloworld repository. Use this when performing a code review of changes to Lua addon code, .toc files, locales, or the release/branching setup.
---

This is a World of Warcraft addon (Ace3-based) with **no automated build, lint, or test suite** — testing happens in-game. Focus review effort on correctness and consistency instead of expecting CI signals to catch problems.

## What to check in every review

1. **Packaging/CI changes.** Both zip-producing workflows use `BigWigsMods/packager` and share the root `.pkgmeta` (which sets `package-as: HelloWorld` and an `ignore:` list of repo/tooling files that must stay out of the shipped addon):
   - `.github/workflows/build.yaml` runs on every push except version tags, with `args: -d` (skip uploading). Since the commit is untagged, the packager auto-labels it an **alpha build** and names the zip with a git-describe suffix (e.g. `v12.1.0-10-gabc1234`). This produces a real, loadable addon package as the `helloworld-addon-alpha` artifact — it is not a partial/test-only build, so don't treat it as such.
   - `.github/workflows/zip.yml` runs on `v*` tags and performs the real release (same packaging, plus uploads).
   - If a PR modifies `.pkgmeta`'s `ignore:` list, verify it doesn't accidentally exclude files needed at runtime: `embeds.xml`, `Locales/`, `options/`, `epgp/`, `Libs/Ace3/`, `assets/`, or any `.toc` file.
   - If a PR adds a new top-level file/folder, check whether it should be added to `.pkgmeta`'s `ignore:` list (repo tooling/docs) or left as-is (ships with the addon).

2. **`.toc` file consistency.** This repo ships multiple `.toc` files, one per game flavor: `HelloWorld.toc` (retail/Midnight), `HelloWorld_Cata.toc`, `HelloWorld_Classic.toc`, `HelloWorld_Mists.toc`, `HelloWorld_TBC.toc`, `HelloWorld_Wrath.toc`.
   - If a PR adds/renames/removes a Lua file that must be loaded, or changes file load order, verify **all** `.toc` files were updated, not just one.
   - If the addon version changed, verify the `## Version:` line matches across every `.toc` file and matches `.semver-version`.
   - If `Title`/`Notes` text changed, check that localized variants (`Title-deDE`, `Notes-deDE`, etc.) were updated too, where applicable.

3. **Library wiring (`embeds.xml`).** New third-party libraries must be added under `Libs\Ace3\...` **and** referenced via `<Include>`/`<Script>` in `embeds.xml`. Flag PRs that add a library folder without updating `embeds.xml`, or vice versa.

4. **Localization.** Strings shown to the player should go through `L["key"]` (via `LibStub("AceLocale-3.0")`), not hardcoded English text in `HelloWorld.lua`/`options/options.lua`/`epgp/epgp.lua`.
   - New locale keys must be added to `Locales/enUS.lua` at minimum; check whether `Locales/deDE.lua` also needs the new key (missing translations are acceptable but should be flagged, not silently ignored).
   - New locale files must be registered in `Locales/Locales.xml`.

5. **Ace3 conventions.**
   - Addon-level objects and Ace3 callback functions (`OnInitialize`, `OnEnable`, `OnDisable`, event handlers, slash commands) should use `PascalCase`; local variables `camelCase`.
   - Saved variables belong under `self.db.profile`/`self.db.char`/`self.db.global` (via `AceDB-3.0`), matching the `defaults` table shape in `HelloWorld.lua`. Flag ad-hoc globals used for persistence instead of `AceDB-3.0`.
   - New user-facing options belong in `options/options.lua`'s `AceConfig-3.0` options table, following the existing `get`/`set` pattern that reads/writes `HelloWorld.db.profile`.

6. **Formatting.** 2-space indentation, LF line endings, trimmed trailing whitespace, final newline (per `.editorconfig`). CRLF or tab-indented Lua/XML changes should be flagged.

7. **Branching/versioning hygiene** (informational, not usually a blocking issue): feature branches should be named `feat/<name>`, fixes `fix/<id>`, translations `i18n/<id>`. Fixes targeting a live release branch (currently `midnight`) should generally also be applied to `develop` — call this out if a fix PR only targets one branch.

## What NOT to flag

- Missing unit tests or missing lint tooling — none exist in this repo by design, and in-game manual testing is the norm.
- Minor style nits already covered by `.editorconfig`/`pre-commit` (trailing whitespace, EOF newline) — pre-commit hooks handle these automatically.
