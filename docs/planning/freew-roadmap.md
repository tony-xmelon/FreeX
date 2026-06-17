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
- [x] B3. **DONE via parity item V1.** Extracted the real WPF ribbon renderer (`RibbonWpfRenderer` + adaptive
      panel/icons/metadata/tooltip) into shared lib `shared/Free.Shared.Ribbon.Wpf`; FreeW now renders through it
      instead of the placeholder TabControl. See the MS Word parity section (V1) for details.

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
- [x] D3. **DONE via parity item V2.** Full-window Word-style Backstage (`Backstage/BackstageView.cs`) with New/
      Open/Save/Save As/Print/Export/Info/Recent/Options panes, routed to the existing `FileCommands` (no shared
      shell-extraction dependency taken). See the MS Word parity section (V2) for details.

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
- [x] P1. Endnotes. `Endnote` store + `Run.EndnoteId`/`EndnoteReference`/`NextEndnoteId` (mirrors
      footnotes); writer emits `word/endnotes.xml` + content type + rel + superscript `w:endnoteReference`;
      reader parses it; superscript marker preserved across edit; References > Endnote. Footnotes + endnotes
      coexist. 4 tests.
- [x] P2. Index. `IndexEntry` + `TextDocument.IndexEntries` side store + `IndexHeading`/`IndexEntry` styles;
      pure `DocumentIndex.Build` (sorted, deduped, heading + entries); References > Mark Entry + Insert Index
      (reversible). Round-trips as styled paragraphs. 12 tests.
- [x] P3. Indentation controls. Pure `Indentation` (Increase/Decrease step + clamp, SetIndents with signed
      first-line = hanging convention); `DocumentView` Increase/Decrease Indent + Set Indents over the
      selection (reversible); Home > Paragraph buttons + Paragraph dialog. 7 tests.
- [x] P4. Line numbers. `PageSettings.LineNumberMode` (None/Continuous/RestartEachPage) + `LineNumberCountBy`;
      writer/reader `sectPr/w:lnNumType` (countBy + restart); print preview draws margin line numbers; Layout
      > Line Numbers cycles the mode. 5 tests.

## Milestone Q — fields, lists, outline tools (next tranche)
Avoids the WPF-ribbon-renderer / shell the other session churns. Q1/Q2 touch the docx writer/reader;
Q3/Q4 are disjoint (view/model-light).
- [x] Q1. Document fields. Extended `RunFieldKind` with Date/Time/FileName/Author/NumPages + factories;
      writer emits `w:fldSimple` with the right `w:instr` keyword; reader maps the leading keyword back
      (handles `DATE \@ "..."` switches); editor resolves DATE/TIME (app layer), Author from Properties,
      FileName from the open file; Insert > Field picker. No DateTime.Now in model/IO. ~7 tests.
- [x] Q2. Multilevel lists. `ListKind.MultiLevel` (backward-compatible); writer adds a third abstract num
      (`numId=3`, `multiLevelType="multilevel"`, accumulating `%1.%2.%3.` level text); reader maps it back;
      editor renders best-effort decimal-per-level; Home > Multilevel List + level promote/demote. 3 tests.
- [x] Q3. Outline tools. Pure `OutlineTools.Promote`/`Demote` (Heading3→…→Title; Title→Heading1→…→Heading6
      cap); `DocumentView` Promote/Demote (reversible StyleId) + view-only Collapse/Expand (hidden body
      blocks re-spliced on commit so collapse stays view-only); nav-pane context menu. 26 tests.
- [x] Q4. Custom dictionary + spelling options. Pure `CustomDictionary` store + `CustomDictionaryStore`
      persisting a `.lex` under FreeW's data folder, registered in the RichTextBox's `CustomDictionaries`;
      Review > Proofing: Add to Dictionary + Spell Check toggle. 13 tests.

## Milestone R — tables + flow control (next tranche)
Avoids the WPF-ribbon-renderer / shell the other session churns. R1/R2/R4 touch the docx writer/reader
in different scopes (tc structure / pPr / tblPr); R3 is disjoint (editor/view).
- [x] R1. Table cell merge & split. `TableCell.GridSpan` + `VerticalMergeState`; writer/reader `w:gridSpan`
      + `w:vMerge` (restart/continue); `DocumentView` renders ColumnSpan/RowSpan + reconstructs Continue cells
      on commit; reversible Merge Cells / Split Cell commands; Table Tools buttons. 3 IO + 4 model tests.
- [x] R2. Paragraph flow control. `ParagraphFormatting.KeepWithNext`/`KeepLinesTogether`/`WidowControl`;
      writer/reader `w:keepNext`/`w:keepLines`/`w:widowControl`; mapped to WPF `Paragraph.KeepWithNext`/
      `KeepTogether` (widowControl model-only); Home > Paragraph toggles. 4 tests.
- [x] R3. Paste Special. Pure `PasteText.Normalize` (CRLF/CR→LF, strip control chars, keep tab/newline);
      `DocumentView.PastePlainText`/`PasteMergeFormatting` via clipboard + InsertText (undoable); Home >
      Clipboard Paste Text Only / Merge Formatting + Ctrl+Shift+V. 8 tests.
- [x] R4. Table styles. `TableFormatting.HeaderRow`/`BandedRows`/`RepeatHeaderRow`; writer emits header
      bold+shaded + banded shading + `w:tblHeader` + `w:tblLook` (flag persistence); reader recovers flags +
      strips style fills; `DocumentView` renders header/banded styling; Table Tools toggles. 4 tests.

## Milestone S — typography + references polish (next tranche)
Avoids the WPF-ribbon-renderer / shell the other session churns. S1 touches the docx writer/reader;
S2 is pure model; S3/S4 are disjoint (view + model/view).
- [x] S1. Tab leaders. `TabLeader` enum (None/Dots/Dashes/Underline) on `TabStop` (defaulted); writer emits
      `w:tab w:leader="dot|hyphen|underscore"`, reader maps it back; carried verbatim across edit via the
      paragraph Tag (FlowDocument can't render leaders). 3 tests.
- [x] S2. Citation/bibliography styles. `CitationStyle` enum (Apa/Mla/Chicago) + style-aware `FormatInText`/
      `FormatBibliographyEntry`/`BuildBibliography` (heading References/Works Cited/Bibliography); existing
      no-arg overloads default to APA; References > Citation Style dropdown drives the flow. ~per-style tests.
- [x] S3. Show formatting marks. AdornerLayer overlay drawing ¶ at paragraph ends, · for spaces, → for tabs
      (computed from text geometry, never added to the FlowDocument so the model can't be corrupted); pure
      `FormattingMarks` helper; View > Show ¶ stateful toggle. 7 tests.
- [x] S4. Table of figures. Pure `TableOfFigures.Build` (heading + caption entries per label, Figure/Table)
      + `EnsureStyles` + marker; References > Insert/Update Table of Figures (reversible, mirrors TOC). 10 tests.

## Milestone T — page setup + styles + cleanup (next tranche)
Avoids the WPF-ribbon-renderer / shell the other session churns. T1/T3 touch the docx writer/reader;
T2 is model+view (round-trips via styles.xml); T4 is a pure model op + dialog.
- [x] T1. Page setup polish. `PageSettings.AutoHyphenation` (`settings.xml w:autoHyphenation`, settings part
      now emits when hyphenated or protected) + `VerticalAlignment` (`sectPr/w:vAlign`) + `DifferentFirstPage`
      (`sectPr/w:titlePg`); writer/reader; Layout toggles/cycle. 9 tests.
- [x] T2. Custom styles. Pure `StyleManager` (Create with safe unique-id gen + collision suffixing, Modify,
      Delete with built-in guard); New Style + Manage Styles dialogs (name/based-on/run formatting/alignment)
      applying to the selection; round-trips run formatting via styles.xml. ~per-op tests + a docx round-trip.
- [x] T3. Manage hyperlinks. `Run.HyperlinkTooltip` → `w:hyperlink w:tooltip` (external + internal, coalescing
      keyed on tooltip); `DocumentView` Edit/Remove/SetTooltip at the caret with a `HyperlinkInfo` Tag; Insert >
      Links affordances. Existing external/internal round-trips intact. 4 tests.
- [x] T4. Document Inspector. Pure `DocumentInspector.Inspect` (counts comments/revisions/properties/bookmarks)
      + in-place removal ops (RemoveComments/Revisions[=accept]/Properties/Bookmarks); Review > Inspect dialog
      with selective remove. 9 tests.

## Milestone U — editing conveniences (next tranche)
Avoids the WPF-ribbon-renderer / shell the other session churns. U2/U3 touch the docx reader/writer;
U1/U4 are disjoint (pure + view).
- [x] U1. Change Case. Pure `ChangeCase.Apply` (Upper/Lower/Sentence/Capitalize/Toggle, documented
      boundary rules); `DocumentView.ChangeSelectionCase` over the selection (undoable); Home > Font picker.
      11 tests.
- [x] U2. Image alt text + alignment. `InlineImage.AltText` (settable, default null) → `wp:docPr @descr`;
      writer/reader; image-paragraph alignment via existing infra; rendered as tooltip/automation name;
      Insert > Illustrations Alt Text + align. 3 tests.
- [x] U3. Insert text from file. Pure `DocumentMerge.CloneBlocks`/`InsertBlocksAt` (deep clone of runs/
      tables, source untouched); `DocumentView.InsertDocument` inserts a `DocxReader`-loaded doc's blocks at
      the caret (reversibly, brings missing styles via TryAdd); Insert > Text from File. 5 tests.
- [x] U4. Bookmark manager + Go To. Pure `Bookmarks.List`/`RemoveBookmark`; Bookmark Manager dialog
      (Go To via `BringBlockIntoView` / Delete) + the Find/Replace Go To now lists bookmarks; Insert > Links. 6 tests.

## MS Word parity (2026-06-17 →) — functional + VISUAL parity, excluding cloud/proprietary
New standing goal: reach MS Word parity in functionality AND look, excluding cloud/proprietary features
(co-authoring, Editor AI/Designer, online pictures/templates/services — same exclusions as FreeX). The
mainstream functional surface (F–U) is done; the gaps are **visual fidelity** and a few **hard structural
features**. Same proven pattern (roadmap → isolated agents → integrate/verify/push).

### Visual track (make it LOOK like Word)
- [x] V1. Real Word-style ribbon. Ported the app-neutral `RibbonWpfRenderer` (+`RibbonAdaptivePanel`/`RibbonIcon`/
      `RibbonMetadata`/`RibbonTooltip`) into shared WPF lib `shared/Free.Shared.Ribbon.Wpf`; `MainWindow.BuildRibbon`
      now renders each tab via `RibbonWpfRenderer.BuildTabContent` (Large/Medium/Small controls, group dividers/labels,
      vector glyphs) instead of the placeholder TabControl. FreeW supplies its command-id→glyph mapping via
      `FreeWRibbonIcons.Install()` (sets the shared `RibbonIconFactory.CommandIconKindResolver`, dependency-free
      `RibbonIconDefinitions` geometry) + `FreeWRibbonResources.xaml`. (The long-deferred B3.) Highest visual impact.
- [x] V2. Backstage / File menu. `Backstage/BackstageView.cs` — a full-window green nav-rail overlay (Info/New/
      Open/Save/Save As/Print/Export/Recent/Options/Close) wrapped over the document in MainWindow; a title-bar
      **File** button shows it, back-arrow/Esc hides it. Action entries route to the existing `FileCommands`/`Print`/
      `OpenProperties` (no file IO reimplemented); Info shows path/properties + `WordCount.Of` stats; Recent lists
      `RecentFilesStore`; Export/Options are honest placeholders (no PDF/Options back-end exists). (The deferred D3.)
- [x] V3. Paginated WYSIWYG page view. `MainWindow.TogglePrintLayout` puts the editor on a grey workspace; the
      `DocumentView` page chrome (`ApplyPageChrome`, page shadow, margins) + `PageBreakAdorner` render discrete pages
      like Word's Print Layout rather than a continuous flow. (The deferred E4 page view.)
- [x] V4. Ruler + Word-like status bar. `Editing/Ruler.cs` — code-built horizontal ruler (inch tick scale, shaded
      margin zones from `PageSettings`, read-only left/right/first-line indent markers + tab ticks from the caret
      paragraph) and a thinner vertical ruler; both zoom-scaled to the page band, shown in Print-Layout mode (drag
      not wired — read-only is the milestone). `DocumentView` gained `LayoutChanged`, `CurrentParagraphFormatting`,
      `PageInfo()`. Status bar enhanced with **Page X of Y** + a Read-Mode/Print-Layout view-switch cluster (existing
      zoom slider kept). (Current-section indicator omitted gracefully — now that W4 landed, a future polish item.)
- [x] V5. Galleries + KeyTips. `Ribbon/StylesGallery.cs` (Home → Styles: swatches rendered in each style's own resolved
      formatting + `▾` full-list popup; hover live-previews, leave reverts, click commits), `Ribbon/ThemeGallery.cs`
      (Design → Themes + theme-colour galleries via `DocumentTheme.Apply`), `Ribbon/KeyTipsOverlay.cs` (Alt shows
      KeyTip badges over tabs → tab letter activates + shows control badges → control letter invokes; Esc/Alt/click
      dismiss). `DocumentView` gained additive preview/commit methods (`PreviewParagraphStyle`/`CommitStylePreview`/
      `PreviewTheme` — preview bypasses the undo bus via snapshot/revert; commit routes through the reversible command
      path). `BuildRibbon` injects galleries into the shared-renderer group grids by stamped `CatalogId`. Shared tier untouched.

### Functional track (hard features)
- [x] W1. Equations (OMML `m:oMath`) — `Equation`/`MathRun` model carried as an inline `Run.Equation` mark
      (mirrors images/footnotes/content-controls so it flows through runs, table cells, headers); supports plain
      text (`m:r`/`m:t`), superscript (`m:sSup`), and fractions (`m:f`). Writer declares `xmlns:m`, emits inline
      `m:oMath`; reader parses `m:oMath` (unknown constructs degrade to their `m:t` text). 8 new tests (5 IO round-trip + 3 model).
- [x] W2. Shapes / text boxes. `Shape`/`ShapeKind` (Rectangle/RoundedRectangle/Ellipse/TextBox; size in pt, optional
      fill, text-box body reuses `List<Paragraph>`) carried as inline `Run.Shape` (mirrors `Run.Equation`/`Run.Image`).
      Writer declares `wp`/`a`/`wps` xmlns, emits `w:drawing`→`wp:inline`→`wps:wsp` (`a:prstGeom` + optional `a:solidFill`
      + `w:txbxContent`) with shape docPr ids above the image range; reader parses `wps:wsp` (distinguished from
      `pic:pic`). The previously-unregistered `freew.shapes` ribbon button now inserts a sample text box (DocumentView
      renders ellipse/rect/text-box, model on `Tag`). 13 new tests.
- [x] W3. Charts. `Chart`/`ChartSeries`/`ChartKind` (Column/Bar/Line/Pie, title, categories, series, size) carried as
      inline `Run.Chart`. On save each chart becomes a self-contained part `word/charts/chartN.xml` (`c:chartSpace` with
      one chart type, `c:ser` + `c:cat` string cache + `c:val` number cache, axes for cartesian kinds) with a
      content-type Override + `chart` relationship + inline `w:drawing`/`c:chart r:id`; data embedded as literal caches
      (no embedded xlsx — "Edit Data" unavailable, noted in code). Writer threads images+charts via a `RunDrawings`
      record; reader resolves the chart part and parses kind/title/categories/values. 15 new tests (incl. zip-part assertions).
- [x] W4. Multiple sections. `SectionBreakKind` (Continuous/NextPage/EvenPage/OddPage) + `Section` (own `PageSettings`
      + break kind); `Paragraph.SectionBreak` marks a section-ending paragraph (mirrors OOXML: non-final `w:sectPr` in
      the last para's `w:pPr`, final at body level). `TextDocument.Sections` is a computed view; `TextDocument.Page`
      stays the final section (fully backward-compatible). Writer refactored `BuildSectionProperties(PageSettings,
      kind)`; reader gained shared `ReadPageSettings` (also fixing pre-existing gap: pgSz/pgMar/orientation were
      written but never read — landscape now round-trips). 7 new tests + single-section regression guard.

## MS Word parity — wave 2 (2026-06-17 →)
With the first parity wave (V1–V5, W1–W4) done, wave 2 deepens parity with the remaining mainstream Word
surfaces and finally stands up an App.Host test harness. Still excluding cloud/proprietary (online video,
translate/research services, VBA/macros, 3D models).
- [x] X1. App.Host test harness. New `freew/FreeW.App.Host.Tests` (STA via `Xunit.StaFact`/`[StaFact]`) added to
      `FreeW.slnx` (CI already covers it) — 15 tests over `DocumentView.Render`/`CommitToModel`. **Both HIGH QA-backlog
      findings fixed (confirmed real, red→green):** (1) `Run.Tag` collision where revision/comment/content-control
      markers overwrote each other → composite `RunMarkers(Revision,Comment,Control)` record merged via `AddMarker`;
      (2) collapsed-heading index drift where visible-block ordinals addressed wrong `_model.Blocks` slots →
      `ModelIndexFromVisible` helper in `SelectedModelParagraphIndices`/`InsertComment`/`MarkSelectionAsRevision`
      (plus a latent fix: `Paragraph.StyleId` now round-trips on `ParagraphTag`, previously dropped on commit).
- [x] X2. WordArt / decorative text. Dedicated `WordArt` record (`Text` + `WordArtStyle` preset FillBlue/GradientFill/
      Outline/Shadow + font size) carried as inline `Run.WordArt`. Writer emits a `wps:wsp` text box whose run `a:rPr`
      carries the preset's DrawingML effect (`a:solidFill`/`a:gradFill`/`a:ln`/`a:effectLst`), reusing the shape docPr
      counter; reader (ordered BEFORE `ReadShape` since WordArt is also a `wps:wsp`) infers the preset from which effect
      is present — a plain text-box shape with no effects still reads back as `Shape`. Round-trip + model tests.
- [x] X3. Floating images + text wrapping. `ImageWrapping` (Inline/Square/Tight/TopAndBottom/Behind/InFront) +
      `HorizontalAnchor`/`VerticalAnchor` + offsets on `InlineImage` (all defaulting to inline → byte-compatible).
      Writer split `BuildDrawing` into `BuildInlineDrawing`/`BuildAnchorDrawing` sharing `BuildDocPr`/`BuildPicGraphic`;
      floating emits `wp:anchor` (`wp:positionH/V` + wrap element, `wrapNone`+`behindDoc` for Behind/InFront);
      reader parses both `wp:inline` and `wp:anchor`. `wp:wrapTight` emitted without wrapPolygon (noted). Round-trip + model tests.
- [x] X4. Accessibility checker. Pure `AccessibilityChecker.Check(doc) → AccessibilityReport` (mirrors `DocumentInspector`):
      rules for missing image alt text (Error), uninformative/bare-URL link text, heading-order gaps, tables without a
      header row, low-contrast text (self-contained WCAG relative-luminance / 4.5:1 ratio), blank cells + missing doc
      title (Tips). Issues ordered by block with document-wide last. 32 new model tests. No UI (no ribbon placeholder).

## MS Word parity — wave 3 (2026-06-17 →)
Deepening toward full parity: the last two big DrawingML object types, the remaining App.Host QA fixes (now
unit-testable on the X1 harness), and surfacing already-built model features in the ribbon UI.
- [ ] Y1. SmartArt (DrawingML diagram). Basic list/process/hierarchy diagram inserted as the DrawingML
      `dgm` parts (data/layout/style/colors) + an inline `w:drawing`; model `Run.SmartArt`; round-trip the node text.
- [ ] Y2. OLE / embedded objects. Embed a binary object (`w:object`/`o:OLEObject` + an embedded part with an
      icon image fallback); model `Run.EmbeddedObject`; round-trip the embedded bytes + ProgId.
- [x] Y3. App.Host MED/LOW QA fixes (on the X1 test harness). **All four defects were real and are fixed**
      (each red→green-verified via git-stash; +9 STA regression tests in `QaBacklogRegressionTests.cs`):
      field-run-inside-hyperlink now wraps in `BuildHyperlink` (link survives); author-set cell shading is
      stamped on a `TableCellTag` and read authoritatively (the colour-equality strip now only applies to
      editor-created cells); an emptied run keeping a comment/content-control marker is preserved as a
      zero-length marked run; `WpfList.Tag` stashes the model `ListKind` so MultiLevel no longer degrades to Number.
- [ ] Y4. Surface built features in the ribbon. Insert tab: Equation / Chart / WordArt commands (the model +
      IO already exist from W1/W3/X2); Review tab: Check Accessibility (uses `AccessibilityChecker`); status bar:
      current-section indicator (now that W4 sections exist). Wire through the existing command registry.

## Consolidation & QA (2026-06-17)
After Milestones F–U, the work pivoted from features to hardening (user choice: "Consolidate & harden"):
- **CI lane** — `.github/workflows/freew-ci.yml` builds `FreeW.slnx` Release (0 warnings enforced) + runs
  the FreeW test lane on `windows-latest`, gating PRs and direct pushes that touch FreeW/shared.
- **README / feature catalog** — `freew/README.md` (architecture, grouped feature catalog, docx fidelity,
  build/test, honest limitations). Sibling-app pointer added to the root README.
- **Windows packaging** — `freew/build/publish-windows.ps1` (self-contained `win-x64` publish + versioned
  zip to `artifacts/`, verified locally ~66 MB) + `.github/workflows/freew-release.yml` (`workflow_dispatch`)
  + `freew/build/README.md`.
- **QA pass** — three read-only audit agents (IO / model+commands / DocumentView). Fixed (with 5 regression
  tests): `w:rPr` children were emitted out of CT_RPr schema order (Word-strict-invalid for common combos;
  the order-independent reader hid it); footnote/endnote markers discarded run formatting; all inline
  pictures shared `pic:cNvPr id=0`; the `StyleManager` built-in guard named a non-existent style (left
  `TableOfFiguresEntry` deletable); `MailMerge`/`DocumentCompare` deep-clones dropped `Run.EndnoteId`/
  `HyperlinkTooltip`, `TableCell.GridSpan`/`VerticalMerge`, and several `PageSettings` fields.

### QA backlog (all in `FreeW.App.Host`) — App.Host now HAS a test assembly (parity X1)
The DocumentView audit confirmed these. **Both HIGH items are now FIXED** with regression tests, once the
App.Host STA test harness landed (parity item X1, `freew/FreeW.App.Host.Tests`):
- **[HIGH — FIXED, X1] Run `Tag` collision** (`DocumentView.BuildRun`/`ApplyCommentMarker`/`ApplyContentControlMarker`):
  revision/comment/content-control markers each overwrote `WpfRun.Tag`, so a run that is both commented and
  tracked-changed (or a content control over either) lost one mark on the next `CommitToModel`. Fixed with a
  composite `RunMarkers(Revision,Comment,Control)` record merged via `AddMarker`; `ReadInline` recovers every facet.
- **[HIGH — FIXED, X1] Collapsed-heading index drift** (`InsertComment`, `MarkSelectionAsRevision`,
  `SelectedModelParagraphIndices`): visible-ordinal indices addressed `_model.Blocks` after `MergeHiddenBlocks`
  re-splices hidden blocks, so paragraph commands mis-targeted when a heading was collapsed *before* the selection.
  Fixed with a `ModelIndexFromVisible` helper (visible→model via `_hiddenBlocks` offsets); also fixed a latent
  defect where `Paragraph.StyleId` was dropped on commit (now round-trips on `ParagraphTag`).
~~Remaining (lower priority)~~ — **ALL FIXED in parity Y3** (with 9 STA regression tests): field-run-in-hyperlink
now wraps in `BuildHyperlink`; real cell shading is stamped on `TableCellTag` and read authoritatively (colour-
equality strip restricted to editor-created cells); emptied comment/content-control run preserved as a zero-length
marked run; `WpfList.Tag` carries the model `ListKind` so MultiLevel no longer degrades to Number on edit.

## Status log (newest first)
- 2026-06-17: Consolidation & QA. FreeW CI lane + README/feature catalog + Windows packaging shipped; a
  read-only QA audit (3 agents) fixed 6 confirmed IO/model defects (rPr schema order, footnote/endnote
  marker formatting, cNvPr ids, StyleManager guard, clone-drops) with 5 regression tests; two HIGH +
  some MED/LOW App.Host findings recorded as a backlog (no App.Host test tier yet). FreeW lane now 594
  tests (465 model, 129 IO). origin/main @ ae96966ad.
- 2026-06-17: Milestone U complete. Change case, image alt text + alignment, insert text from file,
  bookmark manager + Go To — built in parallel by subagents and integrated (all four auto-merged clean;
  U1's push reconciled the other session's FreeX conditional-format work). Each verified 0/0 build + green
  before push. FreeW lane now 586 tests (459 model, 127 IO). origin/main @ aab7d3247. **Sixteen milestones
  (F–U, 64 features) shipped this session.**
- 2026-06-17: Milestone T complete. Page setup polish (hyphenation/vAlign/titlePg), custom styles, manage
  hyperlinks (ScreenTip), document inspector — built in parallel by subagents and integrated (all four
  auto-merged clean). Each verified 0/0 build + green before push. FreeW lane now 543 tests (418 model,
  125 IO). origin/main @ e9967d804. **Fifteen milestones (F–T, 60 features) shipped this session.**
- 2026-06-17: Milestone S complete. Tab leaders, citation styles (APA/MLA/Chicago), show formatting marks,
  table of figures — built in parallel by subagents and integrated (all four auto-merged clean). Each
  verified 0/0 build + green before push. FreeW lane now 497 tests (388 model, 109 IO). origin/main @
  e80635bf5. **Fourteen milestones (F–S, 56 features) shipped this session.**
- 2026-06-17: Milestone R complete. Table cell merge/split, paragraph flow control, paste special, table
  styles — built in parallel by subagents and integrated (R3 disjoint + R2 auto-merged; R1 auto-merged; R4
  hand-resolved against R1 across the shared table writer/reader/render — combined gridSpan/vMerge with
  header/banded styling). Each verified 0/0 build + green before push. FreeW lane now 469 tests (363 model,
  106 IO). origin/main @ 75ae16d70. **Thirteen milestones (F–R, 52 features) shipped this session.**
- 2026-06-17: Milestone Q complete. Document fields, multilevel lists, outline tools, custom dictionary —
  built in parallel by subagents and integrated (all four auto-merged clean; Q4's push reconciled the
  other session's FreeX protection-shell work, which rode along). Each verified 0/0 build + green before
  push. FreeW lane now 445 tests (349 model, 96 IO). origin/main @ 595dacc2d. **Twelve milestones (F–Q,
  48 features) shipped this session.**
- 2026-06-17: Milestone P complete. Endnotes, index, indentation controls, line numbers — built in
  parallel by subagents and integrated (all four auto-merged clean — P2's merge also reconciled the other
  session's FreeX work, which rode along without conflict). Each verified 0/0 build + green before push.
  FreeW lane now 393 tests (307 model, 86 IO). origin/main @ 1b52d0148. **Eleven milestones (F–P, 44
  features) shipped this session.**
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
