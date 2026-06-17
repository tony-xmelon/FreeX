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
- [x] F1. Hyperlinks. Run-level `Run.HyperlinkUrl`; docx `w:hyperlink` + `word/_rels` external rels
      (one rel per distinct URL, dedup); rendered as a clickable WPF `Hyperlink` (opens http/https) that
      round-trips through edit; Insert > Links > Link prompts for a URL. 5 tests (round-trip/formatting/
      external-rel/dedup).
- [x] F2. Document properties. `DocumentProperties` + `TextDocument.Properties`; writer emits
      `docProps/core.xml` (Dublin Core, `dcterms:created/modified` W3CDTF) + content-type + package rel;
      reader populates (graceful when absent); Properties dialog from the title bar. 3 tests.
- [x] F3. Text colour + highlight. `RunFormatting.HighlightColorHex`; highlight encoded as
      `w:shd w:fill` (mirrors `w:color` foreground, exact hex round-trip); Home > Font palette pickers
      for Text Colour + Highlight applied to the selection; rendered via inline Background. 2 tests.
- [x] F4. Table & image editing UX (view/ribbon + reversible model commands, no IO). Insert/delete
      row & column on the caret's table + set selected-image size, all undoable via the bus; Insert tab
      "Table Tools" group + Image Size dialog. 8 command tests.

## Milestone G — round-trip fidelity + chrome (next tranche)
Closes real `.docx` fidelity gaps + editor chrome. Avoids the WPF-ribbon-renderer / shell code the
other session churns. G1–G3 share TextDocument/Formatting/DocxReader/DocxWriter → integrate
sequentially; G4 is disjoint (MainWindow/DocumentView status only).
- [x] G1. Headers & footers (incl. a page-number field). `TextDocument.Header`/`Footer` (`HeaderFooter`
      of paragraphs) + `Run.PageNumberField()` (`RunFieldKind`); writer emits `word/header1.xml`/
      `footer1.xml` parts + content types + rels + `w:headerReference`/`footerReference` in `sectPr`,
      PAGE field as `w:fldSimple`; reader resolves them back; `HeaderFooterPaginator` draws header/footer
      (live page number) on every previewed/printed page; Insert > Header & Footer group. 6 tests.
- [x] G2. List persistence to docx. Editor maps WPF `List`↔model `ListKind`/`ListLevel` on render/commit;
      writer emits `word/numbering.xml` (bullet `numId=1`, decimal `numId=2`, 9 levels) + content type +
      rel + `w:numPr` in list paragraphs; reader maps `numbering.xml`/`w:numPr` back. 5 tests.
- [x] G3. Paragraph borders & shading. `ParagraphBorder` record + `ShadingColorHex` on
      `ParagraphFormatting`; writer/reader map `w:pBdr` + paragraph `w:shd`; `DocumentView` renders via
      `Paragraph.BorderBrush`/`Background`; Home > Paragraph toggle + shading palette. 3 tests.
- [x] G4. Word count + live status bar (disjoint). Pure `WordCount`/`DocumentStats` in the model;
      `MainWindow` status bar shows live Words/Characters/Paragraphs, updated on every edit. 5 tests.

## Milestone H — character/paragraph polish + chrome (next tranche)
More real `.docx` fidelity + editor chrome. Avoids the WPF-ribbon-renderer / shell the other session
churns. H1 (rPr) and H2 (pPr) touch the docx reader/writer in different element scopes; H3 is mostly
ribbon/model; H4 is disjoint (view chrome). Integrate H1→H2→H3 sequentially, H4 anytime.
- [x] H1. Character effects. `VerticalAlign` enum (Baseline/Superscript/Subscript) + `SmallCaps`/`AllCaps`
      on `RunFormatting`; writer/reader map `w:vertAlign`/`w:smallCaps`/`w:caps` in `rPr`; `DocumentView`
      renders via `BaselineAlignment`+shrink and `Typography` capitals; Home > Font toggles. 4 tests.
- [x] H2. Tab stops. `TabStop(PositionPt, TabStopAlignment)` + `ParagraphFormatting.TabStops` (default
      empty); writer/reader map `w:tabs`/`w:tab` (dxa + left/center/right/decimal); preserved across edit
      via the WPF paragraph `Tag` (FlowDocument has no tab-stop API). 2 tests.
- [x] H3. Line & paragraph spacing UI. `DocumentView.SetLineSpacing`/`ToggleSpaceBefore`/`ToggleSpaceAfter`
      over the selection via the reversible `SetParagraphFormattingCommand`; Home > Paragraph line-spacing
      combo + space-before/after toggles; also fixed `LineSpacing` read-back on commit. 2 command tests.
- [x] H4. Zoom (disjoint). Pure `ZoomLevels` math (clamp/step/percent) in the model; `DocumentView.ZoomLevel`
      + `ZoomChanged` scaling via `LayoutTransform` `ScaleTransform` + Ctrl+wheel; status-bar slider/±/% (50–200%). 13 tests.

## Milestone I — structured content (next tranche)
Larger Word constructs. Avoids the WPF-ribbon-renderer / shell the other session churns. I2/I3 add new
docx parts/elements (sequential integration); I1 is model/view/ribbon (light IO); I4 is disjoint UI.
- [x] I1. Real paragraph styles. Added built-in Heading 2/3, Subtitle, Quote; a Styles `freew.style`
      ComboBox sets selected paragraphs' `StyleId` via a reversible `SetParagraphStyleCommand`;
      `DocumentView` resolves StyleId through the catalog on render; round-trips via `pStyle`/styles.xml.
- [x] I2. Footnotes. `Footnote` store on `TextDocument` + `Run.FootnoteReference(id)`; writer emits
      `word/footnotes.xml` (separators + footnotes) + content type + rel + `w:footnoteReference`; reader
      parses them; superscript marker in `DocumentView` (preserved across edit) + Insert > Footnote.
- [x] I3. Bookmarks + internal links. `Paragraph.BookmarkName` + `Run.HyperlinkAnchor`; writer emits
      `w:bookmarkStart`/`End` + `w:hyperlink w:anchor`; reader parses them (external `r:id` links intact);
      internal links scroll to the bookmark; Insert > Bookmark / Link to Bookmark. Bookmarks preserved
      across edit via a combined paragraph `Tag`.
- [x] I4. Insert Symbol + Date & Time (disjoint). `DocumentView.InsertText` through the edit/undo path;
      a 36-glyph symbol picker + a date/time dialog (pure `DateTimeFormats` helper); Insert > Symbols.

## Milestone J — review + navigation + polish (next tranche)
Avoids the WPF-ribbon-renderer / shell the other session churns. J1/J2 touch the docx reader/writer
(sequential); J3/J4 are disjoint (view/editor only, no IO).
- [x] J1. Comments (review). `Comment` store on `TextDocument` + `Run.CommentId`/`IsCommentReference`;
      writer emits `word/comments.xml` + content type + rel + `w:commentRangeStart`/`End` +
      `w:commentReference`; reader parses them; pale-yellow highlight + author/text tooltip (preserved
      across edit); Review > New Comment over the selection. 4 tests.
- [x] J2. Table cell shading + per-cell width. `TableCell.ShadingColorHex`/`WidthPt` + `Table.ColumnWidthsPt`;
      writer emits `w:tcPr/w:shd` + `w:tcW` + `w:tblGrid/w:gridCol`; reader parses them; `DocumentView`
      renders cell `Background` + column `Width`; Table Tools > Cell Shading. 2 tests.
- [x] J3. Navigation pane (disjoint). Pure `DocumentOutline.Of` (Title/HeadingN paragraphs → entries with
      levels); toggleable left pane in `MainWindow` listing headings, click scrolls to the heading
      (`DocumentView.BringBlockIntoView`); View > Navigation Pane toggle. 11 tests.
- [x] J4. AutoCorrect / smart typing (disjoint). Pure `AutoCorrect.Evaluate` (smart quotes open/close,
      `--`→en dash, `(c)`/`(r)`/`(tm)`, `...`→…, sentence caps); wired into `DocumentView.OnPreviewTextInput`
      through the edit/undo path (toggleable, default on). 38 tests.

## Milestone K — long-document features (next tranche)
Avoids the WPF-ribbon-renderer / shell the other session churns. K1/K3 touch the docx reader/writer
(sequential); K2 is light-IO (reuses `DocumentOutline`); K4 is disjoint (insert helpers).
- [x] K1. Track changes (revisions). `Run.Revision` (`RevisionKind` None/Inserted/Deleted) + author/date;
      writer coalesces runs into `w:ins`/`w:del` (+`w:delText`); reader parses them; insertions render
      underlined-coloured, deletions strikethrough (preserved across edit); Review > Track Changes toggle +
      Accept All / Reject All (pure `TrackChanges` ops). 3 IO + 4 model tests.
- [x] K2. Table of Contents. Pure `TableOfContents.Build` from `DocumentOutline` ("Contents" heading +
      level-indented entries with TOC styles); Insert > Table of Contents + Update TOC (removes the
      style-marked region and rebuilds), reversibly via the bus. Round-trips as styled paragraphs. 10 tests.
- [x] K3. Columns (multi-column layout). `PageSettings.ColumnCount` + `ColumnSpacingPt`; writer/reader
      `sectPr/w:cols w:num/w:space`; editor + print preview render N equal columns via FlowDocument
      `ColumnWidth`/`ColumnGap`; Layout > Columns cycles 1→2→3. 4 tests.
- [x] K4. Cover page + horizontal rule + page break. Pure `DocumentOps` (cover page from Properties,
      bottom-only-border rule, page-break paragraph); `ParagraphBorder.BottomOnly` + `ParagraphFormatting.
      PageBreakBefore` (both round-trip via `w:bottom`/`w:pageBreakBefore`); Insert > Pages wired. 5 model + 4 IO tests.

## Milestone L — references + finishing touches (next tranche)
Avoids the WPF-ribbon-renderer / shell the other session churns. L1/L2 touch the docx reader/writer
(sequential); L3/L4 are disjoint (editor/view + pure helpers).
- [x] L1. Page borders + watermark. `PageSettings.PageBorder` (`PageBorder` record) + `Watermark`;
      writer emits `sectPr/w:pgBorders` + persists the watermark as a `docProps/custom.xml` custom property;
      reader recovers both; editor + print preview render the border frame + faint rotated watermark;
      Layout > Page Background. 3 tests.
- [x] L2. Citations & bibliography. `Source` + `TextDocument.Sources`; pure `Citations` helpers (in-text
      `(Author, Year)`, APA-flavoured bibliography entries, `BuildBibliography` sorted by author); Insert >
      Citation (pick/add source) + Insert > Bibliography (reversible). Persists as ordinary text/paragraphs. 15 tests.
- [x] L3. Advanced Find & Replace + Go To. Pure `TextSearch.FindAll` (match-case + whole-word boundaries);
      Find/Replace dialog gains Whole-word, Replace-All-in-selection, and a Go To (headings via
      `DocumentOutline` / doc start/end). No model/IO change. ~12 tests.
- [x] L4. Drop cap + Clear All Formatting. Pure `DropCap.ApplyDropCap` (split first letter into a 42pt
      bold run) + `ClearFormatting` (reset runs to default); reversible via the bus (`ReplaceParagraphRunsCommand`);
      Home > Clear Formatting + Insert > Drop Cap. 6 tests.

## Milestone M — editor power tools (next tranche)
Avoids the WPF-ribbon-renderer / shell the other session churns. Mostly disjoint/model this round
(low docx-IO conflict surface). M2 touches the reader/writer; M1/M3/M4 are editor/model/ribbon.
- [x] M1. Format Painter. Pure `FormatPainterClipboard` (Capture/ApplyTo, wholesale-replace); wired the
      `freew.format-painter` placeholder — capture from the selection, arm, apply run+paragraph formatting
      to the next selection on mouse-up, then disarm. 5 tests. (View-only.)
- [x] M2. Captions + figure/table numbering. Pure `Captions` helper (`CaptionLabel`, `NextCaptionNumber`
      counts existing same-label captions, `BuildCaption`) + a `Caption` built-in style; Insert > Caption
      inserts a numbered "Figure/Table N: …" under the caret's block (reversible), auto-picking Table in a
      table. Round-trips as a styled paragraph. 9 tests.
- [x] M3. Document themes. Pure `DocumentTheme` (Office/Slate/Berlin/Ion) + `Apply(doc, theme)` rewriting
      the style catalog's heading/body fonts + Title/Heading colours (body runs inherit through styles);
      Design tab theme dropdown re-renders. 8 tests.
- [x] M4. Read mode + selection stats. `MainWindow.ToggleReadMode` hides chrome + shows a centered reading
      column (restores prior layout on exit); status bar shows live selection word/char count (falls back to
      document counts); View > Views toggle. (View-only.) +1 test theory.

## Milestone N — structured docs + power features (next tranche)
Avoids the WPF-ribbon-renderer / shell the other session churns. N2 touches the docx reader/writer
(sequential); N1/N3/N4 are model/view/disjoint.
- [x] N1. Cross-references. Pure `CrossReferences` (`CrossRefType`, `Targets` from headings/bookmarks/
      captions/footnotes, `ReferenceText`); Insert > Cross-reference dialog inserts a clickable internal
      link for anchored targets, else plain text. Model + view; no new IO. ~10 tests.
- [x] N2. Content controls (`w:sdt`). `ContentControl(Kind, Tag, Alias, Checked)` + `Run.Control`
      (PlainText / CheckBox); writer coalesces runs into `w:sdt` (`w:text` / `w14:checkbox`); reader parses
      them; shaded control region (preserved across edit), checkbox toggles ☐/☒ on click; Insert > Controls. 5 tests.
- [x] N3. AutoText / Quick Parts. Pure `QuickPart`/`QuickPartStore`; `QuickPartLibrary` persists snippets
      as `quickparts.json` under FreeW's data folder (in-memory fallback); Insert > Quick Parts (Save
      Selection / Insert). 15 tests.
- [x] N4. Document statistics dialog. Pure `DocumentStatistics.Compute` (words/chars/paragraphs/sentences/
      syllables/reading-time/avg-wps/Flesch reading ease); Review > Proofing > Word Count dialog. View only. ~12 tests.

## Milestone O — collaboration + automation (next tranche)
Avoids the WPF-ribbon-renderer / shell the other session churns. O1 touches the docx writer/reader
(settings.xml); O2/O3/O4 are model/view/pure.
- [x] O1. Restrict editing / document protection. `ProtectionSettings`/`ProtectionMode` (None/ReadOnly/
      CommentsOnly/TrackChangesOnly) on `TextDocument`; writer emits `word/settings.xml`
      `w:documentProtection` (content type + rel); reader parses it; editor honours protection via
      RichTextBox `IsReadOnly`; Review > Protect > Restrict Editing (stateful toggle). 5 tests.
- [x] O2. Compare documents. Pure `DocumentCompare.Compare(original, revised, author)` — two-level LCS
      (paragraph anchors + word-level token diff) marking Inserted/Deleted runs; Review > Compare opens a
      second .docx and loads the tracked-changes comparison. Deterministic, no DateTime.Now. ~6 tests.
- [x] O3. Mail merge. Pure `MailMerge` (field discovery, `MergeData.FromCsv`, `Substitute`, `MergeRecord`,
      `MergeAll`); fields are `«Field»` (plain text, round-trips); Mailings tab: Set Data / Insert Field /
      Preview Record (next-prev) / Finish & Merge (records concatenated, page-broken). 19 tests.
- [x] O4. Sort + Convert text↔table. Pure `ParagraphSort` (paragraphs + table rows, stable, asc/desc +
      case) + `TextTableConvert` (text→table with ragged padding, table→text); `ReplaceBlocksCommand`
      (reversible); Layout > Data: Sort + Convert to Table + Convert to Text. 13 tests.

## Milestone P — references + layout finishing (next tranche)
Avoids the WPF-ribbon-renderer / shell the other session churns. P1/P4 touch the docx writer/reader;
P2/P3 are model/view.
- [ ] P1. Endnotes. Mirror footnotes at the document end: `Endnote` store + `Run.EndnoteId`; writer emits
      `word/endnotes.xml` + content type + rel + `w:endnoteReference`; reader parses it; superscript marker
      (roman/i style is a plus); Insert > Endnote. Round-trip tests.
- [ ] P2. Index. Mark index entries (an `XE` run mark or a stored entry list) and generate an alphabetical
      index region (pure build helper from the marked entries → styled paragraphs). References > Mark Entry
      + Insert Index. Tested on the pure build.
- [ ] P3. Indentation controls (disjoint — editor/model). Increase/Decrease Indent, and a paragraph dialog
      for left/right/first-line/hanging indents (model already has the indent fields); applied to the
      selection through the bus. Pure indent-step helper (tested).
- [ ] P4. Line numbers. `sectPr/w:lnNumType` (continuous, restart-each-page, countBy) → `PageSettings`
      fields; writer/reader; show line numbers in print preview margin; Layout > Line Numbers. Round-trip tests.

## Status log (newest first)
- 2026-06-17: Milestone O complete. Restrict editing, document compare, mail merge, sort + convert
  text/table — built in parallel by subagents and integrated (O4 disjoint + O3 auto-merged; O1
  auto-merged; O2 hand-resolved against O1 on the Review-tab ribbon groups + command classes). Each
  verified 0/0 build + green before push. FreeW lane now 366 tests (289 model, 77 IO). origin/main @
  f947acfd6. **Ten milestones (F–O, 40 features) shipped this session.**
- 2026-06-17: Milestone N complete. Cross-references, content controls (`w:sdt`), quick parts/autotext,
  document statistics — built in parallel by subagents and integrated (N4 disjoint + N1 auto-merged; N3
  hand-resolved against N1 on the tangled ribbon dialog classes; N2 hand-resolved on the registration
  block). Each verified 0/0 build + green before push. FreeW lane now 324 tests (252 model, 72 IO).
  origin/main @ 4bc5e80b9. **Nine milestones (F–N, 36 features) shipped this session.**
- 2026-06-17: Milestone M complete. Format painter, captions + numbering, document themes, read mode +
  selection stats — built in parallel by subagents and integrated (all four auto-merged clean; chained
  ribbon `Build` overloads + new Design/View tabs composed without conflict). Each verified 0/0 build +
  green before push. FreeW lane now 264 tests (197 model, 67 IO). origin/main @ 4f8571b93. **Seven
  milestones (F–M, 32 features) shipped this session.**
- 2026-06-17: Milestone L complete. Page borders + watermark, citations & bibliography, advanced
  find/replace + Go To, drop cap + clear formatting — built in parallel by subagents and integrated
  (all four auto-merged clean; no hand-resolution needed). Each verified 0/0 build + green before push.
  FreeW lane now 239 tests (172 model, 67 IO). origin/main @ bc305f003. **Six milestones (F–L, 28
  features) shipped this session.**
- 2026-06-17: Milestone K complete. Track changes, table of contents, multi-column layout, cover
  page/rule/break — built in parallel by subagents and integrated (K2 TOC + K3 columns auto-merged clean;
  K4 + K1 hand-resolved against each other on the DocumentView insert methods + ParagraphFormatting
  read-back + interleaved round-trip tests). Each verified 0/0 build + green before push. FreeW lane now
  201 tests (137 model, 64 IO). origin/main @ a51c046e2.
- 2026-06-17: Milestone J complete. Comments/review, table cell shading + widths, navigation pane,
  autocorrect — built in parallel by subagents and integrated (J3/J4 disjoint + J2 auto-merged clean;
  J1 comments hand-resolved on the ribbon View-vs-Review tab). Each verified 0/0 build + green before
  push. FreeW lane now 172 tests (119 model, 53 IO). origin/main @ 2cc04ccc4.
- 2026-06-17: Milestone I complete. Paragraph styles, footnotes, bookmarks + internal links, insert
  symbol/date — built in parallel by subagents and integrated (I1 styles + I4 symbol/date auto-merged
  clean; I2 footnotes + I3 bookmarks hand-resolved against each other on the ribbon command classes +
  DocumentView insert methods). Each verified 0/0 build + green before push. FreeW lane now 115 tests
  (68 model, 47 IO). origin/main @ b04ac5dd9.
- 2026-06-17: Milestone H complete. Character effects, tab stops, line/para spacing UI, editor zoom —
  built in parallel by subagents and integrated (H4 zoom + H1 effects + H2 tabs all auto-merged clean;
  H3 spacing auto-merged). Each verified 0/0 build + green before push. FreeW lane now 100 tests
  (62 model, 38 IO). origin/main @ 525859908.
- 2026-06-17: Milestone G complete. Four features built in parallel by subagents and integrated
  sequentially (G4 word-count disjoint; G2 lists, G3 para borders/shading, G1 headers/footers share the
  docx writer/reader → hand-resolved conflicts, esp. G1's `Write`/content-types/rels combining with G2's
  numbering). Each verified 0/0 build + green before push. FreeW lane now 76 tests (44 model, 32 IO).
  origin/main @ bf39839f1.
- 2026-06-17: Milestone F complete. Four features built in parallel by subagents (isolated worktrees)
  and integrated sequentially — hyperlinks, document properties, text colour + highlight, table & image
  editing — each verified 0/0 build + green tests before push; F1's overlap with F2/F3/F4 on the docx
  writer/ribbon/tests resolved by hand. FreeW lane now 44 tests (26 model, 18 IO). origin/main @ 22c6d7753.
- 2026-06-17: E4 + E5 fully done. Three features built in parallel by subagents and integrated
  sequentially (tables → images → page-view), each verified 0/0 build + green tests before push:
  tables (block model + docx + Insert Table), inline images (DrawingML + Insert Picture), paginated
  print preview + page-aware print. FreeW lane now 27 tests (18 model, 9 IO). origin/main @ cb3c4c45d.
- 2026-06-16: Scaffold complete — FreeW builds + runs on `Free.Shared.*`, Word-style ribbon from
  the shared model, own product identity. Roadmap created; beginning Milestone A.
