# CRUSH.md for wow-addon-helloworld

## Build Commands
- `build`: The project uses GitHub Actions to build a zip file containing `*.toc` and `*.lua` files. A local equivalent would involve:
  1. Creating a temporary directory (e.g., `helloworld`).
  2. Copying `*.toc` and `*.lua` files into this directory.
  3. Zipping the directory.
  (See `.github/workflows/build.yaml` for details.)

## Lint/Test Commands
- **Linting**: No explicit linting setup found. `luacheck` is a common Lua linter.
- **Testing**: No automated unit tests found. Testing is typically done in-game.

## Code Style Guidelines

### Formatting
- **Indentation**: 2 spaces (from `.editorconfig`).
- **Line Endings**: LF (from `.editorconfig`).
- **Trailing Whitespace**: Trimmed (from `.editorconfig`).
- **Final Newline**: Inserted at end of file (from `.editorconfig`).

### Naming Conventions
- **Addon/Global Objects**: `PascalCase` (e.g., `HelloWorld`).
- **Local Variables**: `camelCase` (e.g., `name`, `thisZone`).
- **Functions**: `PascalCase` (e.g., `OnInitialize`, `SlashCommand`).

### Imports
- Libraries are "imported" using `LibStub` (e.g., `LibStub("AceAddon-3.0"):NewAddon`).

### Error Handling
- Error handling is primarily done through conditional checks and `self:Print` statements to the chat.

### Comments
- Single-line comments use `--`.

## Cursor/Copilot Rules
- No specific Cursor or Copilot rule files found in the repository.
