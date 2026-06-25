# FreeW Avalonia Parity Plan

**Branch:** `avalonia-parity/wave1-*` (new series)
**Reference:** WPF shell at `freew/FreeW.App.Host` — 585 ribbon commands, full Word parity, merged to `main`.
**Target:** Avalonia shell at `freew/FreeW.App.Avalonia` — 22 ribbon commands today; bring toward full WPF parity.
**Scope of this doc:** Architecture map, command gap analysis, render capability audit, phased plan.

---

## 1. Architecture Contrast

### Shared tier (NOT touched by this plan)
| Layer | Project | Status |
|-------|---------|--------|
| Document model | `FreeW.Core.Model` | Complete. TextDocument, Paragraph, Table, Run, InlineImage, Shape, Equation, ContentControl, Section, HeaderFooter, Footnote, Endnote, Comment, Revision, etc. |
| File I/O | `FreeW.Core.IO` | Complete. DOCX/DOCM/DOTX/DOTM/RTF/HTML/MHTML/TXT/PDF-import. All formats shared. |
| Presentation planners | `FreeW.App.Presentation` | Shared. Backstage planners, reveal-formatting logic, file-workflow abstraction. |
| Ribbon definition model | `Free.Shared.Ribbon` | Shared. `RibbonDefinition`, `RibbonCommandRegistry`, `RelayCommand`. |
| Ribbon renderer (Avalonia) | `Free.Shared.Ribbon.Avalonia` | Shared. `AvaloniaRibbonRenderer` already wired in the Avalonia shell. |
| PDF export | `Free.Shared.Pdf` + `Free.Shared.Pdf.Skia` | Shared. PDF export already works in Avalonia. |

### WPF shell (`FreeW.App.Host`)
- **`DocumentView.cs`** — 12,474 lines. Subclasses `RichTextBox`. Renders a WPF `FlowDocument` built from the model. All 585 commands delegate to editor methods or WPF editing commands. The model-to-FlowDocument bridge + FlowDocument pagination do all the heavy lifting.
- **`FreeWRibbon.cs`** — 1,332 lines. Declarative ribbon definition (10 tabs + 8 contextual tabs, 585 command IDs).
- **`FreeWRibbonCommands.cs`** — 9,187 lines. Command registry: one `Register()` call per command binding actions to WPF APIs.
- **`MainWindow.cs`** — 3,106 lines. Shell orchestration: ruler, floating-object canvas, docked panes, zoom, view modes, Print Preview, Read Mode, PagedEdit.
- **37 dialog files** — Font, Paragraph, Table Properties, Page Setup, Insert Chart, etc.

### Avalonia shell (`FreeW.App.Avalonia`)
- **`DocumentView.cs`** — 1,828 lines. Custom `Control` (NO FlowDocument). Lays out and renders glyphs per character. Supports PrintLayout (paginated), WebLayout, Draft. All edits routed through `DocumentCommandBus` (shared, undo/redo).
- **`FreeWRibbon.cs`** — 167 lines. 22 command IDs across 5 tabs.
- **`MainWindow.cs`** — 821 lines. Thin shell: ribbon + status bar + find bar + docked panes + ScrollViewer + DocumentView.
- **`BackstageView.cs`** — 663 lines. 8-pane file screen. Already feature-complete.
- **No command registry file** — commands wired inline in `MainWindow`'s `BuildRibbon()` callbacks.

**Key structural difference:** The WPF shell registers commands via a dedicated 9k-line `FreeWRibbonCommands.cs`. The Avalonia shell has no equivalent; commands are ad-hoc lambdas in `MainWindow`. A `FreeWAvaloniaRibbonCommands.cs` will need to be created as the command surface expands.

---

## 2. Render Capability Audit (Avalonia DocumentView TODAY)

What the Avalonia DocumentView **can** render and edit right now:

| Feature | Render | Edit | Notes |
|---------|--------|------|-------|
| Plain text paragraphs | ✓ | ✓ | Full text flow, wrapping, line breaks |
| Bold / Italic / Underline | ✓ | ✓ | Via run formatting toggles |
| Strikethrough | ✓ | ✓ | `DrawDecoration()` |
| Font family / size | ✓ | ✓ | `FormattedText` per glyph |
| Text color | ✓ | ✓ | `BrushFor(hex)` |
| Text alignment (L/C/R) | ✓ | ✓ | `AlignmentOffset` in `EmitLinePaged` |
| Quick styles (Normal/H1/H2/Title) | ✓ | ✓ | `StyleChain` cascade |
| Bullet lists | ✓ | ✓ | `•` marker, indent |
| Numbered lists | ✓ | ✓ | `1.` counter, indent |
| Inline images (flow) | ✓ | read-only | Decoded bitmap, aligned, scaled to fit |
| Tables (grid) | ✓ | modal-only | Cell borders, header fill, banded rows, column widths, cell spans, hit-test |
| Page chrome (PrintLayout) | ✓ | — | Grey desk, page rect, shadow, border |
| Multi-page pagination | ✓ | — | `ReserveContentY` / `ContentYToPageSpaceY` |
| Find/Replace | ✓ | ✓ | `DocumentSearch` + `FindReplaceDialog` |
| Selection highlight | ✓ | ✓ | Block/offset anchor model |
| Caret | ✓ | ✓ | Focused, blinks |
| Undo/Redo | ✓ | ✓ | Via `DocumentCommandBus` |
| Navigation pane (headings) | ✓ | — | `NavigationPane` + `DocumentOutline` |
| Reveal Formatting pane | ✓ | — | `RevealFormattingPane` |
| Reviewing pane | ✓ | — | `ReviewingPane` (tracked changes display) |

What the Avalonia DocumentView **cannot** render or edit yet:

| Feature | Gap type | Notes |
|---------|----------|-------|
| Superscript / Subscript | Render-only | Model exists (`VerticalAlign`); just needs Y-offset in glyph placement |
| Text highlight (background color) | Render-only | Model exists (`HighlightColorHex`); just needs fill rect before glyph |
| Justify alignment | Render-only | Model exists; needs word-spacing expansion in `EmitLinePaged` |
| Font color via dialog | Command | `SetSelectionFontFamily` pattern exists; needs color picker command |
| Paragraph spacing (before/after) | Render | Model has `SpaceBeforePt`/`SpaceAfterPt`; layout loop ignores them |
| Paragraph indents (left/right/first-line) | Render | Model has `IndentLeftPt`; layout loop ignores them |
| Tabs | Render | Model has `TabStops`; layout loop ignores them |
| Line spacing (exact/multiple/at-least) | Render | Model has `LineSpacingRule`; layout loop uses default only |
| In-place table cell editing | Edit | Currently modal-only. In-place caret inside cells needed for parity |
| Headers / Footers | Render | Model has `SectionHeadersFooters`; DocumentView has no header/footer region |
| Multi-column sections | Render | Model has `PageSettings.Columns`; layout ignores it |
| Floating images / shapes | Render | Model has `ImageWrapping` modes and `Shape`; DocumentView only does inline |
| Shapes (inline/floating) | Render | `Shape` model exists; no render path |
| Equations | Render | `Equation` model exists; no render path |
| Content controls | Render | `ContentControl` model exists; no render path |
| Tracked changes (visual) | Render | Model has `Revision`; `ReviewingPane` shows list but inline markup not drawn |
| Comments (inline indicators) | Render | Model has `Comment`; no balloon or margin indicator |
| Footnote/Endnote indicators | Render | Model has `FootnoteId`/`EndnoteId`; no superscript reference or note region |
| Page numbers / field rendering | Render | `RunFieldKind` model exists; no field-to-value resolution |
| Watermark | Render | Model has `Watermark`; no page-level overlay |
| Page borders | Render | Model has `PageBorders`; not rendered |
| SmartArt | Render | Placeholder model only; no render |
| Charts (inline) | Render | No chart render path |
| Read Mode view | Arch | WPF has distinct ReadMode control; not in Avalonia shell |
| PagedEdit (in-page caret) | Arch | WPF's 12k-line innovation; not attempted in Avalonia yet |
| Rulers | Arch | WPF has Ruler.cs; Avalonia shell has none |
| Floating-object canvas | Arch | WPF has a Canvas overlay; Avalonia shell has none |
| Print Preview | Arch | WPF has PrintPreviewWindow.cs; Avalonia shell has BackstageView placeholder |

---

## 3. Command Gap Analysis

### Avalonia today — 22 commands
| Tab | Commands |
|-----|----------|
| File | freew.backstage, freew.open, freew.save |
| Home | freew.cut, freew.copy, freew.paste, freew.font-family, freew.bold, freew.italic, freew.underline, freew.font-size, freew.bullets, freew.numbering, freew.align-left, freew.align-center, freew.align-right, freew.undo, freew.redo, freew.style-normal, freew.style-heading1, freew.style-heading2, freew.style-title, freew.find-replace-dialog |
| Insert | freew.insert-table |
| View | freew.printlayout, freew.weblayout, freew.draftview, freew.navigationpane, freew.reveal-formatting |
| Review | freew.reviewingpane |

### Gap by backing type

#### Type (a): Model-backed, DocumentView ALREADY renders the result — CHEAP
These commands mutate the shared model via `DocumentCommandBus` calls that the existing `DocumentView` already handles correctly. The only work is wiring the command into the ribbon + `FreeWAvaloniaRibbonCommands.cs`.

| Command group | WPF count | Notes |
|--------------|-----------|-------|
| Clipboard: Paste (plain text), Paste Special | 2 | `PasteAsync()` exists; add paste-plain-text variant |
| Font: Strikethrough toggle | 1 | `RunFormatting.Strikethrough` — already rendered |
| Font: Grow Font / Shrink Font | 2 | Adjust font size by step |
| Font: Clear Formatting | 1 | Reset run formatting |
| Paragraph: Increase/Decrease Indent | 2 | `ListLevel` / indent adjustments |
| Paragraph: Show/Hide ¶ | 1 | Overlay toggle in DocumentView |
| Styles: Apply any named style | ~10 | `ApplyQuickStyle` call with style id |
| Editing: Select All | 1 | |
| View: Zoom (100%, Page Width, custom) | 3 | `_zoom` ScaleTransform in MainWindow |
| File: New Document | 1 | `_fileWorkflow.NewDocument()` |
| File: Print (route to PDF) | 1 | `ExportPdfAsync()` already exists |
| Review: Accept/Reject All Changes | 2 | Model mutation (tracked changes accept/reject all) |

**Estimated type (a) count: ~27 commands** — trivial one-command-per-day velocity.

#### Type (b): Model-backed BUT DocumentView render not yet capable — MEDIUM COST
These commands mutate the model correctly, but DocumentView's layout/render loop has gaps that prevent the result from showing. The render gap must be fixed before the command is testable.

| Feature | Commands | Render work needed |
|---------|----------|-------------------|
| Superscript / Subscript | 2 | Y-offset in `EmitLinePaged`; scale factor already in model |
| Text highlight color | 1 | Fill rect before glyph in `Render()` |
| Justify alignment | 1 | Word-spacing expansion in `EmitLinePaged` |
| Paragraph spacing before/after | 2 | Add space reservation in `LayoutParagraphPaged` |
| Paragraph indents (L/R/first-line) | 3 | Apply indent offsets in `LayoutParagraphPaged` |
| Line spacing (exact/multiple/at-least) | 3 | Apply line-height multiplier in `EmitLinePaged` |
| Tabs | 1 | Tab-stop resolution in glyph advance calculation |
| Header/footer insert/edit | ~8 | Need a header/footer region in DocumentView (or a separate pane) |
| Page numbers (field) | 3 | Field resolution in run rendering |
| Track Changes: visual inline markup | ~6 | Revision run coloring/strikethrough overlay in `Render()` |
| Comments: inline indicator | 2 | Margin balloon or inline marker in `Render()` |
| Footnote/Endnote indicators | 4 | Superscript reference + note region at page bottom |

**Estimated type (b) count: ~36 commands**, requiring 12–15 targeted render additions to DocumentView. Most are isolated and additive (no architectural surgery).

#### Type (c): Need Avalonia-native dialogs — MEDIUM COST (dialog work)
Commands that are backed by the model and render fine, but are fronted by a dialog that must be built in Avalonia.

| Dialog | WPF file | Commands it fronts |
|--------|----------|--------------------|
| Font Dialog | `FontDialog.cs` | Font family/size/style/effects/advanced — ~15 commands |
| Paragraph Dialog | (WPF inline) | Alignment/spacing/indents/tabs/borders — ~12 commands |
| Insert Table Dialog | (WPF inline) | Table rows/cols/auto-fit — 1 command |
| Table Properties Dialog | `TablePropertiesDialog.cs` | Table/row/column/cell sizing — ~8 commands |
| Page Setup Dialog | `PageSetupDialog.cs` | Margins/orientation/paper/headers — ~10 commands |
| Columns Dialog | `ColumnsDialog.cs` | Multi-column section — 1 |
| Borders & Shading Dialog | `BordersAndShadingDialog.cs` | Paragraph borders, shading — ~4 |
| Sort Dialog | `SortDialog.cs` | Sort by column — 1 |
| Symbol Picker | `SymbolPickerDialog.cs` | Insert symbol — 1 |
| Zoom Dialog | `ZoomDialog.cs` | Custom zoom — 1 |
| Style Dialog (manage styles) | `StyleDialog.cs` | ~3 |
| Find/Replace Dialog (already exists) | — | Already done |

**Estimated type (c) dialog count: ~12 dialogs fronting ~57 commands.** Each dialog is 100–300 lines of Avalonia `Window`.

#### Type (d): Architecture-new for Avalonia — EXPENSIVE
These require substantial new infrastructure in the Avalonia shell that does not exist at all:

| Feature | WPF reference | Avalonia cost |
|---------|--------------|---------------|
| In-place table cell editing (caret inside cells) | Part of `DocumentView` / FlowDocument | DocumentView layout + caret needs to route into cell paragraphs |
| Floating images (non-inline wrap modes) | `FloatingObjectCanvas` overlay in `MainWindow` | New overlay Canvas + hit-test routing in DocumentView |
| Shapes (inline or floating) | `SmartArtRenderer`, shape path drawing | Shape geometry renderer in Avalonia (Avalonia has `StreamGeometry`) |
| Charts (inline) | WPF chart render | Needs chart-to-bitmap pipeline or native Avalonia chart render |
| Headers / Footers (page-level) | Docked pane + per-page-box rendering | Header/footer region per page in DocumentView `Render()` |
| Multi-column layout | FlowDocument columns | Layout engine change: column flow in `Relayout()` |
| Read Mode | Separate WPF control | New Avalonia control or mode in DocumentView |
| Rulers | `Ruler.cs` (WPF) | New Avalonia `Ruler` control + `MainWindow` wiring |
| Equations | OMML render | Complex: needs OpenType math or linear-text fallback |
| SmartArt | `SmartArtRenderer.cs` (WPF) | Large; defer |

**Estimated type (d) count spans ~200+ commands (contextual tabs for shapes/charts/pictures, floating objects, header/footer tools, etc.)** — these are the WPF contextual tab surface (Drawing Format, Picture Format, Chart Design/Format, SmartArt Design, Header & Footer Design = ~185 commands).

### Summary command breakdown

| Type | Count | Effort per command |
|------|-------|--------------------|
| (a) Model-backed, already renders | ~27 | Tiny (ribbon wire-up only) |
| (b) Model-backed, render gap | ~36 | Small–medium (render patch + wire-up) |
| (c) Dialog-fronted | ~57 | Medium (dialog + wire-up) |
| (d) Architecture-new | ~465 | Large–XL (new render/layout infrastructure) |
| **Total gap** | **~585** | |

Note: WPF total is ~585; Avalonia has 22 wired; gap ≈ 563. The count above approximates the remaining gap.

---

## 4. Key Architectural Risks

### Risk 1 — In-place table cell editing is a layout-engine prerequisite
Today table cells are edited via a modal dialog (`CellEditDialog`). Word-parity means the caret must move freely into and out of table cells. This requires the layout engine to track `DocPosition` inside cells and route `OnKeyDown`/`OnTextInput` into cell paragraphs. This is non-trivial but bounded — the existing `_cellHits` hit-test infrastructure is the right foundation. **Must land before any Table contextual-tab commands are useful.**

### Risk 2 — Floating objects require a Canvas overlay
Floating images and shapes in WPF live on a separate `Canvas` that sits above the `DocumentView`. In Avalonia the `ScrollViewer → DocumentView` chain has no such overlay. Adding floating-object support requires either:
- A `Panel` wrapping `DocumentView` with an overlay canvas (clean), or
- Rendering floating objects directly in `DocumentView.Render()` (works but merges layout concerns)
The overlay-Canvas approach mirrors WPF and is recommended. **This is Phase C gating work.**

### Risk 3 — Headers/Footers need per-page page-space rendering
The current `Render()` loop draws pages as white rectangles and places text in the content area. Headers and footers would need to be drawn in the top/bottom margin of each page rectangle. This is additive to `Render()` and `Relayout()` but requires DocumentView to carry the header/footer model state and render it per page. **Tractable but not trivial (estimated 300–500 lines).**

### Risk 4 — Multi-column layout requires a real column-flow engine
`Relayout()` currently maintains a single content column. Multi-column means each block must be assigned to a column and the content-Y must balance across columns. This is the most invasive layout-engine change. **Defer to late Phase C.**

### Risk 5 — No `FreeWAvaloniaRibbonCommands.cs` exists
The WPF shell's 9,187-line `FreeWRibbonCommands.cs` is the registry for all 585 commands. The Avalonia shell currently has 22 ad-hoc lambdas in `MainWindow.BuildRibbon()`. As the command surface grows, this must be extracted into a proper `FreeWAvaloniaRibbonCommands` class; otherwise `MainWindow.cs` will become unmaintainable. **This refactor should be Wave 1.**

### Risk 6 — No Avalonia render/parity capture tooling
The WPF side has `FreeW.FidelityRender` (composite captures) and `FreeW.RibbonShot` (ribbon screenshots). The Avalonia shell has `PrintLayoutCaptureTests.cs` (11 tests, headless xUnit) and `LaunchSmoke.cs`. There is no Avalonia analog of FidelityRender for visual regression. The headless test suite should be extended with per-wave baseline captures before each wave ships.

---

## 5. Phased Plan

### Phase A — Ribbon command surface + cheap model-backed commands
**Goal:** Wire up ~120 commands that are already backed by the model and already render correctly. Extract command registry. No new render work.

| Wave | Slice | Key files | Est. commands |
|------|-------|-----------|--------------|
| A-1 | Extract `FreeWAvaloniaRibbonCommands.cs`; expand Home tab: Strikethrough, Grow/Shrink Font, Clear Formatting, Select All, paste variants, Show/Hide ¶ | `Ribbon/FreeWAvaloniaRibbonCommands.cs` (new), `MainWindow.cs`, `FreeWRibbon.cs` | +10 |
| A-2 | Expand styles gallery: all named styles from model; Styles dropdown; Manage Styles stub | `FreeWRibbon.cs`, `FreeWAvaloniaRibbonCommands.cs`, `DocumentView.cs` | +15 |
| A-3 | Full Insert tab basic surface: Insert Blank Page, Insert Page Break, Insert Column Break, Insert Section Breaks (Next Page/Continuous/Even/Odd), Insert Horizontal Rule | `FreeWRibbon.cs`, command registry | +8 |
| A-4 | Full View tab: Zoom (100%/Page Width/Two Pages/custom), Ruler toggle (stub), Gridlines toggle, Split Window stub | `FreeWRibbon.cs`, `MainWindow.cs` | +8 |
| A-5 | Review commands: Accept/Reject tracked changes (all/current), Next/Previous Change, Word Count dialog, Spelling stub | `FreeWRibbon.cs`, command registry | +10 |
| A-6 | Design tab: Themes (apply from model), Style Sets, Colors, Fonts, Paragraph Spacing presets, Watermark (text-only render) | `FreeWRibbon.cs`, command registry, `DocumentView.cs` (watermark overlay) | +10 |
| A-7 | Layout tab: Margins/Orientation/Paper Size (via PageSettings model mutations, no dialog yet), Line Numbers toggle stub, Hyphenation stub | `FreeWRibbon.cs`, command registry | +8 |
| A-8 | References tab: Table of Contents (insert/update stub), Mark Index Entry, Next/Previous Footnote | `FreeWRibbon.cs`, command registry | +8 |
| A-9 | Mailings basic: Start Mail Merge mode, Select Recipients (placeholder), Preview Results | `FreeWRibbon.cs`, command registry | +6 |

**Phase A total: ~85 new commands across 9 waves. ~9 sub-agent sessions.**

---

### Phase B — Render patches + dialogs (type (b) + type (c))
**Goal:** Fill the render gaps that block type-(b) commands; build the ~12 core dialogs that front type-(c) commands.

#### Phase B1 — DocumentView render patches (no dialog work)

| Wave | Slice | Key files | Render additions |
|------|-------|-----------|-----------------|
| B1-1 | Superscript/Subscript render + commands | `DocumentView.cs` (~`EmitLinePaged`), command registry | Y-offset, scale |
| B1-2 | Text highlight + paragraph indent/first-line render | `DocumentView.cs` (`Render()`, `LayoutParagraphPaged`) | Fill rect, indent offset |
| B1-3 | Paragraph spacing before/after + line spacing | `DocumentView.cs` (`LayoutParagraphPaged`, `EmitLinePaged`) | Height multiplier, space reservation |
| B1-4 | Justify alignment + tab stops | `DocumentView.cs` (`EmitLinePaged`, `LayoutParagraphPaged`) | Word-spacing expansion, tab advance |
| B1-5 | Tracked changes inline visual (insertion color, deletion strikethrough) + comment margin indicator | `DocumentView.cs` (`Render()`) | Revision color overlay |
| B1-6 | Footnote/Endnote superscript reference + note region at page bottom | `DocumentView.cs` (`Relayout()`, `Render()`) | Reserved note area per page |
| B1-7 | Field rendering (page number, date, filename) in run | `DocumentView.cs` (run render loop) | Field-to-string resolution |

**Phase B1 total: ~7 waves, ~36 commands unblocked.**

#### Phase B2 — Dialogs (type (c))

| Wave | Slice | Key files | Dialog |
|------|-------|-----------|--------|
| B2-1 | Font Dialog (family/size/style/effects/color picker) | New `FontDialog.cs` (Avalonia Window) | ~15 commands |
| B2-2 | Paragraph Dialog (alignment/spacing/indents/line spacing/tabs) | New `ParagraphDialog.cs` | ~12 commands |
| B2-3 | Table Insert Dialog + Table Properties Dialog | New `InsertTableDialog.cs`, `TablePropertiesDialog.cs` | ~9 commands |
| B2-4 | Page Setup Dialog (margins/orientation/paper/section) | New `PageSetupDialog.cs` | ~10 commands |
| B2-5 | Columns Dialog + Borders & Shading Dialog (paragraph) | New `ColumnsDialog.cs`, `BordersAndShadingDialog.cs` | ~5 commands |
| B2-6 | Zoom Dialog + Sort Dialog + Symbol Picker | New `ZoomDialog.cs`, `SortDialog.cs`, `SymbolPickerDialog.cs` | ~3 commands |
| B2-7 | Style Manager Dialog (edit/create/delete styles) | New `StyleDialog.cs` | ~3 commands |

**Phase B2 total: ~7 waves, ~57 commands unblocked.**

**Phase B total: ~14 waves, ~93 commands unblocked.**

---

### Phase C — Render-heavy: in-place tables, headers/footers, images, floating objects
**Goal:** Unlock the contextual-tab command surface (Drawing Format, Picture Format, Table Design/Layout, Header & Footer). These require new architectural work in DocumentView and MainWindow.

#### Phase C1 — In-place table cell editing
**Prerequisite for Table Design/Layout contextual tabs (~36 commands).**

| Wave | Slice | Key files |
|------|-------|-----------|
| C1-1 | Extend `DocPosition` + caret routing into table cells; `OnKeyDown` inside cells navigates by Tab/arrow | `DocumentView.cs` |
| C1-2 | Cell selection, column selection, row selection; cut/copy/paste within cell | `DocumentView.cs`, command registry |
| C1-3 | Table Design contextual tab (Style Options: header/banded/first/last; Table Borders, Shading) | `FreeWRibbon.cs`, command registry, `DocumentView.cs` |
| C1-4 | Table Layout contextual tab (Insert Row/Col above/below/left/right, Delete Row/Col/Table, Merge/Split Cells, Cell Size, Alignment, Text Direction, Repeat Header) | `FreeWRibbon.cs`, command registry |

**Phase C1 total: ~4 waves, ~36 commands unblocked.**

#### Phase C2 — Headers and Footers
**Prerequisite for Header & Footer Design contextual tab (~8 commands).**

| Wave | Slice | Key files |
|------|-------|-----------|
| C2-1 | Header/footer regions in `DocumentView.Render()` (draw content in page top/bottom margin areas per page); header/footer model state plumbed into view | `DocumentView.cs` |
| C2-2 | Header/Footer enter/exit (click into margin activates editing in that region; mode-switch like WPF's docked pane) | `DocumentView.cs`, `MainWindow.cs` |
| C2-3 | Header & Footer Design contextual tab (Different First Page, Different Odd/Even, Insert Page Number/Date/Document Info, Navigation, Close) | `FreeWRibbon.cs`, command registry |

**Phase C2 total: ~3 waves, ~8 commands unblocked.**

#### Phase C3 — Inline images (extend) + floating images
**Prerequisite for Picture Format contextual tab (~92 commands).**

| Wave | Slice | Key files |
|------|-------|-----------|
| C3-1 | Inline image selection + size handles (click an image to select; drag to resize) | `DocumentView.cs` |
| C3-2 | Floating-object Canvas overlay in `MainWindow` (Panel wrapping DocumentView + overlay Canvas) | `MainWindow.cs`, new `FloatingObjectCanvas.cs` |
| C3-3 | Floating image render + drag/drop/z-order | `FloatingObjectCanvas.cs`, `DocumentView.cs` |
| C3-4 | Picture Format contextual tab: Arrange (Wrap Text, Position, Rotate, Z-order, Align, Group), Size | `FreeWRibbon.cs`, command registry |
| C3-5 | Picture Format: Picture Styles gallery, Adjust (Color, Corrections, Crop, Border, Effects) | command registry, `DocumentView.cs` render for effects |

**Phase C3 total: ~5 waves, ~92 commands unblocked.**

#### Phase C4 — Shapes and Drawing Format
**Prerequisite for Drawing Format contextual tab (~108 commands).**

| Wave | Slice | Key files |
|------|-------|-----------|
| C4-1 | Shape geometry rendering in Avalonia (`StreamGeometry` paths from `Shape.ShapeKind`) | `DocumentView.cs` or new `ShapeRenderer.cs` |
| C4-2 | Inline and floating shape placement + text-box content | `DocumentView.cs`, `FloatingObjectCanvas.cs` |
| C4-3 | Drawing Format contextual tab: Insert Shapes gallery, Shape Styles, Text Direction, WordArt Styles | `FreeWRibbon.cs`, command registry |
| C4-4 | Drawing Format: Effects (Shadow, Glow, Reflection, Bevel), Arrange, Size, Alt Text | command registry |

**Phase C4 total: ~4 waves, ~108 commands unblocked.**

#### Phase C5 — Multi-column layout
| Wave | Slice | Key files |
|------|-------|-----------|
| C5-1 | Column-flow engine in `Relayout()`: assign blocks to columns, balance content Y across columns | `DocumentView.cs` |
| C5-2 | Columns Dialog backing (already built in B2-5); column break insertion | `DocumentView.cs`, command registry |

**Phase C5 total: ~2 waves, ~5 commands unblocked (columns dialog commands already in B2-5).**

#### Phase C6 — Charts and SmartArt (deferred, high cost)
Charts require a chart-to-bitmap pipeline (either Avalonia-native drawing or rasterizing WPF output). SmartArt has complex layout geometry. Recommend deferring until C1–C5 are complete.

| Wave | Slice | Key files |
|------|-------|-----------|
| C6-1 | Chart render: rasterize chart model to `IImage` using Skia or shared PDF pipeline, display as inline image placeholder | New `AvaloniaChartRenderer.cs` |
| C6-2 | Chart Design/Format contextual tabs | command registry |
| C6-3 | SmartArt render placeholder + SmartArt Design tab | command registry |

**Phase C6 total: ~3 waves, ~37 commands unblocked.**

**Phase C total: ~21 waves, ~286 commands unblocked.**

---

## 6. Verification Strategy

### Per-wave test protocol
1. Extend `DocumentViewHeadlessTests.cs` (currently 566 lines) with headless assertions for each new render feature.
2. Add `RibbonAndDocumentTests.cs` cases for each new command (currently 145 lines).
3. `PrintLayoutCaptureTests.cs` (currently 212 lines) — add a baseline capture per wave for visual regression.

### Parity capture tooling (create in Phase A)
- **`FreeW.AvaloniaParityCapture`** (new tool): headless `--parity-grid` capture that renders a test document to PNG for comparison against WPF output. Mirror the pattern from FreeX's `AvaloniaRenderCompare`. Key file: `tools/FreeW.AvaloniaParityCapture/Program.cs`.

### No WPF-side regression risk
The Avalonia shell is entirely separate from the WPF shell. All changes land in `freew/FreeW.App.Avalonia/` and `freew/FreeW.App.Avalonia.Tests/`. The shared `FreeW.Core.Model` and `FreeW.Core.IO` must not be modified (they are already complete).

---

## 7. Recommended First Wave

**Wave A-1** is the correct entry point:

1. Create `freew/FreeW.App.Avalonia/Ribbon/FreeWAvaloniaRibbonCommands.cs` — extract existing 22 ad-hoc lambdas from `MainWindow.BuildRibbon()` into a proper registry class, then add the 10 new commands (Strikethrough, Grow Font, Shrink Font, Clear Formatting, Select All, Paste Plain Text, Show/Hide ¶, New Document, Increase/Decrease Indent).
2. Expand `freew/FreeW.App.Avalonia/Ribbon/FreeWRibbon.cs` to include the new command IDs.
3. Add tests in `RibbonAndDocumentTests.cs`.

This is low-risk, high-leverage: it establishes the command registry pattern that every subsequent wave depends on, and it adds 10 visible commands on the ribbon for zero render cost.

---

## 8. Wave Count Summary

| Phase | Waves | Commands added | Render work |
|-------|-------|---------------|-------------|
| A — Cheap model-backed surface | 9 | ~85 | Minimal |
| B1 — DocumentView render patches | 7 | ~36 unblocked | DocumentView patches |
| B2 — Dialogs | 7 | ~57 unblocked | None (dialogs only) |
| C1 — In-place tables | 4 | ~36 unblocked | Caret routing in cells |
| C2 — Headers/Footers | 3 | ~8 unblocked | Per-page regions |
| C3 — Images + floating | 5 | ~92 unblocked | Canvas overlay + bitmap |
| C4 — Shapes/Drawing | 4 | ~108 unblocked | Shape geometry |
| C5 — Multi-column | 2 | ~5 unblocked | Column-flow engine |
| C6 — Charts/SmartArt | 3 | ~37 unblocked | Chart rasterize |
| **Total** | **44 waves** | **~464 commands** | |

Remaining ~100 commands (Mailings depth, Review depth, Developer content controls, Help, icon polish) fold naturally into the phases above as sub-items.

Full WPF parity is a 44-wave program. Phases A+B alone (23 waves) deliver ~178 visible commands and cover the core editing experience that everyday users need (font/paragraph/styles/formatting dialogs/tables/footnotes/tracked changes display). Phase C completes the contextual-tab surface and advanced layout features.
