# FreeW Linux Port

**Last updated:** 2026-06-20

FreeW is the word-processor sibling of FreeX. This document describes its Linux port:
the Avalonia shell, packaging, CI lane, and feature coverage, mirroring the FreeX Linux port.

> FreeW is not affiliated with, endorsed by, or sponsored by Microsoft. Microsoft Word is a
> trademark of Microsoft Corporation. FreeW reads/writes the Word `.docx` format for interoperability.

## Architecture

FreeW mirrors FreeX's layering:

- **Portable core** (`freew/FreeW.Core.Model`, `freew/FreeW.Core.IO`, `net10.0`): the `TextDocument`
  model (paragraphs, runs, tables, styles, images), a `DocumentCommandBus` + `IDocumentCommand`
  undo/redo engine (over the shared `Free.Shared.Commands.UndoRedoStack`), and `DocxReader`/`DocxWriter`.
- **Shared portable tiers** (`shared/Free.Shared.{AppServices,Commands,Opc,Ribbon}`, `net10.0`, WPF-free):
  app identity/storage, the command engine, OPC/XML helpers, and the ribbon definition model.
- **Windows shell** (`freew/FreeW.App.Host`, WPF, `net10.0-windows`): the Windows-only host. Not used on Linux.
- **Cross-platform shell** (`freew/FreeW.App.Avalonia`, this port): an Avalonia `net10.0` app that
  replaces the WPF host on Linux (and runs anywhere Avalonia does). It consumes the portable core +
  shared tiers; it does **not** reference the WPF `Free.Shared.Shell`.

### The Editing Surface

Avalonia has no `FlowDocument`, so `Editing/DocumentView.cs` is a custom `Control`:

- A per-character layout engine (word wrap, paragraph alignment, mixed-run formatting), caret +
  selection + click hit-testing.
- All edits (type/Backspace/Delete/Enter, bold/italic/underline, alignment, font size, paste) route
  through the shared `DocumentCommandBus`, so undo/redo come from the shared command stack.
- Renders bullet/numbered lists (markers in a hanging-indent gutter), tables (a real grid:
  per-column widths, wrapped cell text, header/banded fills, borders; double-click opens a modal cell
  text editor), and inline images (PNG decoded to a bitmap, crash-proof with a placeholder fallback).
- Named-style resolution cascades a paragraph's `StyleId` through the document style's BasedOn chain,
  run formatting, and paragraph formatting for display, while model runs stay raw so the style link
  round-trips.

### The Ribbon

`Ribbon/FreeWRibbon.cs` authors a portable `Free.Shared.Ribbon.RibbonDefinition` (File, Home with
Clipboard / Font / Paragraph / Styles / Editing groups) and wires command ids to the `DocumentView` /
shell. `Ribbon/AvaloniaRibbonRenderer.cs` renders the definition into an Avalonia `TabControl`,
dispatching through the `RibbonCommandRegistry`.

## Packaging & Install

`freew/FreeW.App.Avalonia/Packaging/linux/` produces three install formats from a self-contained
publish (freedesktop/XDG layout: `.desktop`, hicolor icon, AppStream metainfo):

- **Tarball** (`package-linux-app.sh`) with `install.sh`/`uninstall.sh` (per-user `~/.local` by default).
- **Debian package** (`build-deb.sh`, `dpkg-deb`, amd64/arm64).
- **AppImage** (`build-appimage.sh`).

FreeW opens standard Word `.docx`, so it relies on `shared-mime-info` rather than registering a custom
MIME type. No system .NET runtime is required.

## CI

`.github/workflows/freew-linux.yml` (manual `workflow_dispatch`, `linux-x64` + `linux-arm64`):
runs the `FreeW.Core` model/IO suites and `FreeW.App.Avalonia.Tests` on Linux, builds + publishes the
self-contained app, validates the desktop assets, builds the tarball + `.deb` (+ optional AppImage) with
SHA-256 checksums, runs the headless `--packaging-smoke` (DOCX round-trip) and the Xvfb `--launch-smoke`
(window-shown + glyphs laid out, hard-gated), captures a screenshot, and uploads the bundle.

## Feature Coverage

| Area | Status |
| --- | --- |
| Rich-text editing (type/caret/selection/undo-redo) | Done |
| Bold / italic / underline, alignment, font size | Done |
| Bullet / numbered lists (render + edit; Enter continues the list) | Done |
| Tables | Render + modal cell text editing; in-cell caret editing pending |
| Inline images | Render |
| Named paragraph styles + quick styles (Normal/Heading/Title) | Done, including BasedOn chains |
| DOCX open / save | Done |
| OS clipboard cut / copy / paste | Done |
| Word-style ribbon | Done |
| Packaging: tarball / .deb / AppImage | Done |
| Headless DocumentView layout tests | Done |

## Pending

- **In-cell table editing**: double-click modal text editing is supported, but the caret model is still
  `(block, offset)`; rich in-place editing inside table cells needs a richer
  `(block -> cell -> paragraph -> offset)` model.
- Real Avalonia ribbon icons (buttons are text today).

## Coordination

FreeW feature development (the WPF host + `FreeW.Core` + shared tiers) is driven separately. This
Avalonia shell is additive and self-contained, so features landing on `FreeW.Core` inherit into the
Linux shell for free, and the `freew-linux` lane validates `FreeW.Core` on Linux.
