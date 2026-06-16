# FreeW Roadmap — build the full word processor, reuse FreeX

**Goal:** grow the FreeW scaffold into a real word processor (`.docx`, rich editing,
ribbon, file lifecycle, print), reusing as much of FreeX / the `Free.Shared.*` tier as
possible. Build it as a continuous series of small, verified, pushed increments.

## Working agreement (every increment)
1. Pick the next unchecked `[ ]` item below (top-to-bottom unless a dependency forces reorder).
2. Implement it, **reusing first**: prefer a `Free.Shared.*` API; if the reusable thing still
   lives in `FreeX.App.Host`/`FreeX.Core.*`, extract it to the shared tier (behind an interface
   if it's grid-coupled) rather than copying.
3. Verify: `dotnet build FreeW.slnx -c Release` must be 0/0; if shared/ or FreeX changed, also
   `dotnet build FreeX.slnx -c Release` + `dotnet test FreeX.DefaultTests.slnx --no-build`.
   For editing/IO logic add FreeW tests (new `freew/FreeW.*.Tests` + a `FreeW` test lane).
4. Commit a small buildable unit; reconcile `origin/main` (it races — merge, don't force) and push.
5. Check the item off here in the same commit. Keep this file the single source of truth.

## Reuse map (what FreeW pulls from where)
- Ribbon model/builder → `Free.Shared.Ribbon`. WPF ribbon renderer → extract `RibbonWpfRenderer`
  from `FreeX.App.Host` to a shared WPF ribbon lib (coordinate w/ the active ribbon work).
- Undo/redo → `Free.Shared.Commands` (`UndoRedoStack`). Define a FreeW command context.
- OPC/OOXML packaging → `Free.Shared.Opc`; widen via Phase 3b (`XlsxPackagePath` split,
  `IFileAdapter<TDocument>`) so docx `_rels`/docProps/styles/theme are shared.
- Storage/recent/autosave/diagnostics/settings → `Free.Shared.AppServices` (FreeW identity set).
- Dialog/window/backstage chrome → `Free.Shared.Shell` (+ finish the Phase 5 shell extraction).
- Find/replace, spell-check, print-to-PDF → extract the engine bits from `FreeX.*` to shared,
  leaving grid-specifics behind.

## Milestone A — rich document model + editing core
- [x] A1. Expand `FreeW.Core.Model`: run formatting (font family/size/color, bold/italic/
      underline/strike), paragraph props (alignment, spacing before/after, line spacing, indent,
      list level), document defaults + named styles, sections. *(RunFormatting/ParagraphFormatting
      records, DocumentStyle catalog w/ Normal/Heading1/Title, PageSettings, document defaults.)*
- [x] A2. Editing surface: a document control (FlowDocument-backed first) bound to the model;
      caret + selection; typing/delete/enter map to model edits. *(DocumentView : RichTextBox —
      LoadModel renders model→FlowDocument resolving run/para formatting through styles+defaults;
      CommitToModel maps the edited view back. Verified rendering on screen.)*
- [x] A3. Wire `Free.Shared.Commands`: `IDocumentCommandContext`, commands for insert/delete text
      and apply run/paragraph formatting; undo/redo via the shared `UndoRedoStack`. *(IDocumentCommand
      + DocumentCommandBus over the shared UndoRedoStack; Insert/Delete/SetParagraph/SetRun/
      FormatParagraphRuns commands w/ snapshot revert; bus wired into DocumentView w/ redraw-on-change.)*
- [x] A4. FreeW test project + lane (`freew/FreeW.Core.Model.Tests`); model + command tests.
      *(10 tests: model/styles/PlainText + DocumentCommandBus undo/redo/redo-invalidation/snapshot
      revert; added to FreeW.slnx. `dotnet test FreeW.slnx` = the FreeW lane. 10/10 green.)*

## Milestone B — ribbon wired to editing
- [x] B1. Implement `IRibbonCommandRegistry` for FreeW; wire Home commands (bold/italic/underline,
      align L/C/R, cut/copy/paste, grow/shrink font) to editing ops through the command bus.
      *(FreeWRibbonCommands builds a RibbonCommandRegistry mapping ids → WPF EditingCommands/
      ApplicationCommands on the editor; bold/italic/underline are IRibbonStatefulCommand. Renderer
      wires button Click → command.Execute and disables unregistered ids. Launches clean.)*
- [ ] B2. Selection-driven toggle state (bold on when selection is bold) via the shared ribbon
      state store.
- [ ] B3. Reuse the real WPF ribbon renderer: extract `RibbonWpfRenderer` (+ adaptive panel/keytips)
      from `FreeX.App.Host` into a shared WPF ribbon library; FreeW renders with it instead of the
      placeholder. (Localization via `IShellStrings`; coordinate with concurrent ribbon edits.)

## Milestone C — .docx I/O
- [ ] C1. Phase 3b prerequisite: split `XlsxPackagePath` → format-neutral OPC core in
      `Free.Shared.Opc`; add `_rels`/content-types/docProps helpers.
- [ ] C2. `FreeW.Core.IO`: docx reader (WordprocessingML `document.xml` paragraphs/runs/rPr/pPr,
      `styles.xml`) on `Free.Shared.Opc`.
- [ ] C3. docx writer; `[Content_Types].xml` + rels + docProps.
- [ ] C4. Round-trip fidelity tests on a small docx corpus.

## Milestone D — app shell + file lifecycle
- [ ] D1. New/Open/Save/Save As wired to `FreeW.Core.IO`; file dialogs via `Free.Shared.Shell`;
      dirty-state + title bar via `Free.Shared.AppServices` document state.
- [ ] D2. Recent files (shared `RecentFilesStore`) + autosave/recovery (shared `AutosaveSnapshotStore`).
- [ ] D3. Backstage/File menu + Options, reusing the shared shell frames (finish Phase 5 extraction
      as needed).

## Milestone E — word-processor features
- [ ] E1. Find/Replace (extract reusable search from FreeX where possible).
- [ ] E2. Spell-check (reuse `FreeX` `SpellCheckService`; extract to shared).
- [ ] E3. Print + Export PDF (reuse FreeX print pipeline / PDFsharp; extract the generic frame).
- [ ] E4. Page layout: margins/orientation/size, paginated page view.
- [ ] E5. Tables, inline images (DrawingML via shared OPC), bulleted/numbered lists, styles gallery.

## Status log (newest first)
- 2026-06-16: Scaffold complete — FreeW builds + runs on `Free.Shared.*`, Word-style ribbon from
  the shared model, own product identity. Roadmap created; beginning Milestone A.
