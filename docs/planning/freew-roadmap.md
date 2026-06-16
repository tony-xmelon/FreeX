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
- [x] B2. Selection-driven toggle state (bold on when selection is bold) via the shared ribbon
      state store. *(editor.SelectionChanged pushes bold/italic/underline state into the shared
      RibbonStateStore; toggle buttons observe StateChanged and update IsChecked live.)*
- [ ] B3. *(DEFERRED — reordered.)* Reuse the real WPF ribbon renderer: extract `RibbonWpfRenderer`
      (+ adaptive panel/keytips) from `FreeX.App.Host` into a shared WPF ribbon library; FreeW renders
      with it instead of the placeholder. **Held back because the other session is actively churning
      the WPF ribbon renderer on `origin/main` — extracting it now would conflict hard. FreeW's
      placeholder ribbon already drives real commands (B1/B2), so this is quality, not function.
      Revisit once the ribbon work settles. Proceeding to Milestone C (docx I/O), which is
      independent.**

## Milestone C — .docx I/O
- [~] C1. *(Not needed yet — reordered.)* Phase 3b prerequisite (split `XlsxPackagePath`). The docx
      reader/writer instead use `System.IO.Compression.ZipArchive` for the OPC container directly +
      the shared `Free.Shared.Opc.SecureXmlReaderSettings` (promoted to public) for hardened XML.
      Revisit the full PackagePath split when richer parts (images/rels graph) are needed.
- [x] C2. `FreeW.Core.IO`: docx reader (WordprocessingML `document.xml` paragraphs/runs/rPr/pPr,
      `styles.xml`). *(DocxReader on ZipArchive + shared SecureXmlReaderSettings; run formatting,
      paragraph formatting, style refs + styles.xml.)*
- [x] C3. docx writer; `[Content_Types].xml` + rels + sectPr + styles.xml. *(DocxWriter emits a
      minimal valid package round-trippable with the reader.)*
- [x] C4. Round-trip tests. *(FreeW.Core.IO.Tests: 5 round-trip tests — text, run formatting,
      paragraph formatting, styles+ref, non-Word rejection. 5/5 green.)*

## Milestone D — app shell + file lifecycle
- [x] D1. New/Open/Save/Save As wired to `FreeW.Core.IO`; file dialogs; dirty-state + title bar.
      *(FileCommands: New/Open/Save/SaveAs over DocxReader/Writer + Win32 dialogs, recent files via
      shared RecentFilesStore (persists under FreeW's folder), dirty flag + title-bar New/Open/Save
      buttons + Ctrl+N/O/S. Verified on screen.)*
- [x] D2. Recent files (shared `RecentFilesStore`) + autosave/recovery (shared `AutosaveSnapshotStore`).
      *(Recent ▾ menu lists the shared store's entries → OpenPath. AutosaveCoordinator writes a .docx
      snapshot + sidecar every 30s when dirty via the shared AutosaveSnapshotStore (FreeW Recovery
      folder), offers recovery of a prior session's snapshot on startup, cleans up on clean exit.)*
- [ ] D3. *(DEFERRED.)* Backstage/File menu + Options, reusing the shared shell frames. Held back —
      depends on the large/risky Phase-5 shell extraction (actively churned), and FreeW's title-bar
      File commands + Recent menu already cover the lifecycle. Revisit after the shell settles.

## Milestone E — word-processor features
- [x] E1. Find/Replace. *(Modeless FindReplaceDialog over the editing surface: TextPointer search,
      Find Next w/ wrap, Replace, Replace All, Match case; opened via Ctrl+F / Ctrl+H. FreeW text
      search is TextPointer-based rather than reusing FreeX's cell-oriented find.)*
- [x] E2. Spell-check. *(Enabled WPF RichTextBox built-in spell check on DocumentView — red squiggles
      + right-click suggestions; the right tool for a text surface vs FreeX's cell SpellCheckService.)*
- [x] E3. Print + Export PDF. *(Ctrl+P → WPF PrintDialog prints the FlowDocument paginator; "Microsoft
      Print to PDF" covers PDF export. Page size from the print dialog's printable area.)*
- [x] E4. Page layout: margins/orientation/size wired (Layout tab toggles page settings, honoured by
      docx save + print). **Paginated WYSIWYG page view DONE** — `PageLayout` (pure point→DIP/printable-
      area/page-count geometry in the model), `PrintPreviewWindow` (modeless `FlowDocumentPageViewer`
      over a display-only XAML deep-clone) + page-size-aware `Print()`; "Print Preview" on the Layout
      tab. 7 PageLayout geometry tests.
- [x] E5. Bulleted/numbered lists (wired in B1 via EditingCommands) + styles gallery (Normal/
      Heading 1/Title apply size/weight/colour to the selection). **Tables + inline images DONE** —
      block model (`Block`/`Paragraph`/`Table`/`TableRow`/`TableCell`) with `w:tbl` docx round-trip +
      Insert > Table; run-level `InlineImage` (DrawingML `w:drawing`, `word/media` PNG parts, rels +
      content-type) with Insert > Picture. Round-trip + undo/redo tests.

## Milestone F — deeper document fidelity (next tranche)
Chosen to extend real `.docx` capability while avoiding the WPF-ribbon-renderer / shell code the other
session is actively churning. IO-touching items integrate sequentially (they share TextDocument/
DocxReader/DocxWriter); the editing-UX item is disjoint.
- [ ] F1. Hyperlinks. Run-level hyperlink target; docx `w:hyperlink` + `word/_rels` external rels;
      render as a clickable/underlined link in `DocumentView`; round-trip tests.
- [ ] F2. Document properties. `docProps/core.xml` (+ `app.xml`) title/author/subject/keywords/
      created/modified; a Properties dialog from the title bar; reader populates, writer emits; tests.
- [ ] F3. Text colour + highlight. Foreground colour picker + highlight (`w:highlight`/`w:shd`) on the
      Home/Font group, applied to the selection; docx round-trip for run colour + highlight.
- [ ] F4. Table & image editing UX (disjoint — view/ribbon only, no IO). Add/delete row & column on a
      table at the caret; drag-resize or a size box for the selected image. Routes through the undo bus.

## Status log (newest first)
- 2026-06-17: E4 + E5 fully done. Three features built in parallel by subagents and integrated
  sequentially (tables → images → page-view), each verified 0/0 build + green tests before push:
  tables (block model + docx + Insert Table), inline images (DrawingML + Insert Picture), paginated
  print preview + page-aware print. FreeW lane now 27 tests (18 model, 9 IO). origin/main @ cb3c4c45d.
- 2026-06-16: Scaffold complete — FreeW builds + runs on `Free.Shared.*`, Word-style ribbon from
  the shared model, own product identity. Roadmap created; beginning Milestone A.
