# FreeW Table Rendering — Fidelity Triage (2026-06-25)

**Corpus:** 11 .docx files under `freew-fidelity-corpus/files/tables/`  
**Renders:** `freew-fidelity-corpus/runs/tables-freew/` (816×1056 px PNG, 1 page each except doc 07 = 3 pages, maxPages=2 captured)  
**Generator:** `freew/tools/_corpus_tables/Program.cs`  
**Render tool:** `FreeW.FidelityRender` (WPF FlowDocument paginator via `FreeW.App.Host.DocumentView.BuildTable`)  
**Word baseline:** NOT taken — Word COM left to orchestrator session per instructions.

---

## Priority Summary

| Rank | Issue | Severity | Source file:approx-line |
|------|-------|----------|------------------------|
| 1 | Explicit row height (`TableRow.HeightPt`/`HeightRule`) silently ignored — rows size to content only | BLOCKER | `DocumentView.cs` `BuildTable` ~6040 — no `wpfRow.MinHeight`/`Height` set |
| 2 | Banded-row fill skips every other row — off-by-one: body-row 0 (1st data row) gets no fill; body-row 1 (2nd) does | MAJOR | `DocumentView.cs` `IsBandedBodyRow` ~6208: `bodyIndex % 2 == 1` starts at odd |
| 3 | Cell vertical alignment (`TableCell.VerticalAlignment`) not applied — all text top-aligned | MAJOR | `DocumentView.cs` `BuildTable` ~6063 — no `wpfCell.VerticalAlignment` set |
| 4 | Border line style not differentiated — Double/Dotted/Dashed/Wave/Thick all render as same thin single line | MAJOR | `DocumentView.cs` `BuildTable` ~6078: `wpfCell.BorderThickness = new Thickness(0.5)` uniform, no `DashStyle` or double-rule |
| 5 | Per-edge border override collapses to first non-null edge colour for entire cell — per-edge colour control lost | MAJOR | `DocumentView.cs` `BuildTable` ~6097: `var edgeHex = (cellBorders.Top ?? cellBorders.Left ?? cellBorders.Bottom ?? cellBorders.Right)!.ColorHex` |
| 6 | AutoFit=Contents renders full content width, not shrunk to content — no visual difference from AutoFit=Window | MINOR | `DocumentView.cs` `BuildTable` / `TableColumn.Width` — WPF FlowDocument has no `Auto` column width mode |
| 7 | BandedColumns / FirstColumn / LastColumn formatting flags not rendered | MINOR | `DocumentView.cs` `BuildTable` — only `BandedRows` + `HeaderRow` are wired; column-axis flags not read |
| 8 | Header fill colour constant mismatch: `DocumentView.HeaderRowFill = #D9E2F3`; `DocxWriter` HeaderFill = `"D9E2F3"` (same value, consistent); both differ from the Avalonia DocumentView constant `#DEE9F7` | INFO | `DocumentView.cs` (WPF) line 5979 vs Avalonia `DocumentView.cs` line ~600 |

---

## Known Suspect Verdicts

### Suspect 1 — Table renders NARROWER than Word (width not honoured, auto-fits to content)
**REFUTED.**  
Table `PreferredWidthPt` and `ColumnWidthsPt` are correctly applied to WPF `TableColumn.Width` in `GridLength` units.  
Doc 01 target 460pt → measured 618px (96dpi: 460×4/3 = 613px ✓).  
Doc 09 (7-column wide table, 460pt target) → 626px ✓.  
Doc 11 Fixed-mode 460pt → ~615px ✓; Window-mode 530pt → ~687px ✓.  
No auto-fit collapse observed.

### Suspect 2 — Cell vertical padding too tight (rows shorter than Word)
**CONFIRMED — but the root cause is deeper than cell padding.**  
The `Padding = new Thickness(4, 2, 4, 2)` on `wpfCell` (line 6065) is applied. However, `TableRow.HeightPt` and `TableRow.HeightRule` (AtLeast / Exact) are **never read** in `BuildTable` — `wpfRow` receives no `MinHeight` or `Height` property. Rows are purely content-driven.  
Evidence: Doc 07 (AtLeast 80pt rows) produced a two-row table that filled ~920px across two large rows; measured height of ~460px/row vs expected 80pt = 107px. Doc 08 (Exact 60pt = 80px rows, 4-row table) rendered at 175px total ≈ 44px/row rather than 320px.  
Word respects `w:trHeight` with `w:hRule="atLeast"` / `"exact"`. FreeW does not.

### Suspect 3 — Internal border weight heavier/darker than Word table-style borders
**PARTIALLY CONFIRMED — generalised.**  
The specific claim (heavier/darker) was not directly measurable without a Word baseline. What IS confirmed:  
- All table borders render as a uniform 0.5px `Thickness` in the same grey (`#9A9A9A` when no catalog style).  
- `BorderLineStyle` values other than `Single` produce identical visual output: `Double`, `Dotted`, `Dashed`, `Thick`, and `Wave` borders all render as a thin single grey line with no style differentiation.  
- Per-cell border `WidthPt` IS applied (thick-bottom-only cell, 3pt, was visually correct), but the style (Double, Wave, etc.) and the per-edge colour individuation are lost.

---

## Per-File Findings

### 01 — Banded Rows + Header (TableGrid, 3 cols, 5 rows)

| Feature | Verdict | Detail |
|---------|---------|--------|
| Table width (460pt) | PASS | ~618px ✓ |
| Header row fill (#D9E2F3) | PASS | Row 0 rendered with correct #D9E2F3 fill |
| Header row bold | PASS | Bold text in row 0 confirmed |
| Banded rows (alternate fill) | FAIL | Body row 0 (Alice row) = WHITE; body row 1 (Bob row) = #F2F2F2 (BandedRowFill). Off-by-one: banding starts at the 2nd body row, not the 1st |
| Borders (table + cell) | PASS (style only) | All cell borders visible at 0.5px grey |

**Cause (banding off-by-one):** `IsBandedBodyRow` returns `bodyIndex % 2 == 1`, where `bodyIndex = rowIndex - 1` for tables with a header. So body row 0 (rowIndex=1) → bodyIndex=0 → 0%2=0 → NOT banded. Excel/Word convention bands the 1st body row (odd rows from top in the table body). Fix: change `== 1` to `== 0` (or invert the banding parity).

**Severity:** MAJOR — first data row never gets the band fill.

---

### 02 — Banded Columns + First/Last Column (4 cols, 3 rows)

| Feature | Verdict | Detail |
|---------|---------|--------|
| Table width (360pt) | PASS | ~478px ✓ |
| BandedColumns fill | FAIL | Not rendered — all data cells white |
| FirstColumn bold | FAIL | Not rendered |
| LastColumn styling | FAIL | Not rendered |
| HeaderRow fill | PASS | Row 0 = #D9E2F3 ✓ |
| BandedRows off-by-one | FAIL (same as #01) | Body row 0 white, body row 1 banded |

**Cause:** `DocumentView.BuildTable` only checks `fmt.BandedRows` and `fmt.HeaderRow`; `fmt.BandedColumns`, `fmt.FirstColumn`, and `fmt.LastColumn` are read from the stashed `WpfTableTag` on commit but never applied to visual rendering.

**Severity:** MINOR (column-axis banding/first-last is a secondary visual feature).

---

### 03 — Header Row Styling Only (3 cols, 4 rows, no BandedRows)

| Feature | Verdict | Detail |
|---------|---------|--------|
| Header fill | PASS | Row 0 = #D9E2F3, y=105..136 ✓ |
| Header bold | PASS | "Employee Name / Department / Status" bold ✓ |
| No banding (correct) | PASS | Body rows white since BandedRows=false |
| Border style | PASS | Uniform 0.5px grey visible |

**Verdict: PASS.** Header-only styling is the simplest case and renders correctly.

---

### 04 — Custom Borders (varied styles & colors, 4 rows)

| Feature | Verdict | Detail |
|---------|---------|--------|
| Border color overrides | PASS (partial) | Red top+bottom, green right, orange on custom cell all visible |
| Per-edge individual colours | FAIL | Multi-colour cell (red top / blue left / green right / orange bottom) renders with ONE colour for all edges — the Top edge colour wins (red) |
| Border LINE STYLE | FAIL | Double, Dotted, Dashed, Wave all render as identical thin single line |
| Border width (WidthPt) | PASS (partial) | The 3pt thick-bottom-only cell visibly thicker on the bottom edge ✓ |
| Single-edge override (thick bottom only) | PASS | Bottom border present, other edges absent ✓ |

**Cause (per-edge colour):** `DocumentView.BuildTable` line ~6097: picks `edgeHex` as the first non-null edge, applies it to the whole `wpfCell.BorderBrush`. WPF `TableCell.BorderBrush` is a single brush; per-edge colors are architecturally unsupported by WPF FlowDocument.

**Cause (line style):** WPF `TableCell` does not support `DashStyle` or double-rule rendering. All borders use the default solid pen.

**Severity:** MAJOR — per-edge colour individuation lost; all non-Single styles look identical.

---

### 05 — Cell Shading (varied fills, 3 cols, 4 rows)

| Feature | Verdict | Detail |
|---------|---------|--------|
| Explicit cell ShadingColorHex | PASS | All 8 custom shading colors (#FFCCCC, #CCE5FF, #CCFFCC, #FFF3CD, #E2CCFF, #FFD9CC, #CCFFFF, grey) render correctly |
| No-shading cells | PASS | White cells remain white |

**Verdict: PASS.** Cell shading via `ShadingColorHex` is fully applied (line 6105–6107 of DocumentView).

---

### 06 — Merged Cells (horizontal GridSpan + vertical VerticalMerge)

| Feature | Verdict | Detail |
|---------|---------|--------|
| Horizontal merge (GridSpan=2) | PASS | Header "Product Info" spans 2 cols ✓ |
| Vertical merge (Restart + Continue) | PASS | "StorageA" cell spans rows 1–2 via RowSpan=2 ✓; Continue cells skipped correctly |
| No phantom rows | PASS | Table renders cleanly |

**Verdict: PASS.** Both merge dimensions work correctly.  

*Note: earlier triage pass reported phantom rows; pixel re-examination of the actual PNG confirmed the RowSpan IS working — the Continue cells are correctly omitted from rendering at line 6056–6060.*

---

### 07 — Cell Text Direction (Rotate90, Rotate270, AtLeast 80pt rows)

| Feature | Verdict | Detail |
|---------|---------|--------|
| Text rotation Rotate90 | PASS | Text correctly rotated 90° (bottom→top) |
| Text rotation Rotate270 | PASS | Text correctly rotated 270° (top→bottom) |
| AtLeast 80pt row height | FAIL | Rows are content-driven; with RotateTransform content the rows expand to near-full page height — the table split across 3 pages instead of rendering compactly on 1 |
| Table pagination with rotation | WARN | 3 pages emitted; capture maxPages=2 cut off page 3 |

**Cause (row height):** `TableRow.HeightPt` / `HeightRule` not applied. The rotated `StackPanel` inside a `BlockUIContainer` produces a very tall WPF measure, causing each row to occupy ~460px rather than 107px (80pt).

**Severity:** BLOCKER for documents relying on `w:trHeight`.

---

### 08 — Content Alignment (all 9 H×V positions, Exact 60pt rows)

| Feature | Verdict | Detail |
|---------|---------|--------|
| Horizontal alignment L/C/R | PASS | Left, Center, Right in each column visually correct |
| Vertical alignment Top/Center/Bottom | FAIL — CANNOT VERIFY | Rows are 44px (content height); Exact 60pt = 80px not honoured; no slack for VAlign to show |
| Exact 60pt row height | FAIL | 4-row table = 175px total; expected ~320px (4×80px) |

**Cause (VAlign):** `WpfTableCell` does not set `VerticalAlignment`; the WPF default is `Stretch` but because rows have no enforced height there is no visible effect. Even if height were enforced, `modelCell.VerticalAlignment` is never mapped to `wpfCell.VerticalAlignment` in `BuildTable`.

**Severity:** BLOCKER for Exact-height rows; MAJOR for VAlign on any row with slack.

---

### 09 — Wide Table (7 columns, 460pt, banded rows + header)

| Feature | Verdict | Detail |
|---------|---------|--------|
| Width 460pt, 7 cols | PASS | ~626px, all 7 columns visible ✓ |
| Column proportions | PASS | Narrower columns visually narrower ✓ |
| Header row fill | PASS | #D9E2F3 ✓ |
| Banded rows (off-by-one) | FAIL | Same as #01 — 2nd body row banded, 1st is not |

**Verdict: MOSTLY PASS** (width/layout), with the inherited banding off-by-one.

---

### 10 — Nested Table (outer 2×2, inner 2×2 inside cell[1][1])

| Feature | Verdict | Detail |
|---------|---------|--------|
| Outer table renders | PASS | 2-col table with borders ✓ |
| Inner table renders | PASS | Inner 2×2 table visible inside the cell ✓ |
| Nesting depth | PASS | No crash or missing content |

**Verdict: PASS.** Nested tables (via `Block` children of `TableCell.Paragraphs` treated as nested document blocks) render correctly.

---

### 11 — Column Widths vs AutoFit (Fixed 460pt vs Contents vs Window)

| Feature | Verdict | Detail |
|---------|---------|--------|
| Fixed 460pt | PASS | ~615px ✓ |
| AutoFit=Window (530pt) | PASS | ~687px (full text width) ✓ |
| AutoFit=Contents | FAIL (minor) | Renders at ~687px — no visual difference from Window; content cells are all short strings so expected render should be narrower than Window |

**Cause (Contents mode):** WPF `TableColumn.Width = GridLength(pts * PxPerPoint)` uses a fixed pixel width regardless of `AutoFitMode`. WPF FlowDocument has no equivalent of `Auto` column sizing. `AutoFit=Contents` would need a measure pass to shrink columns to their content.

**Severity:** MINOR — most practical cases use Fixed or Window; Contents auto-shrink is rare.

---

## Code Locations for Each Bug

| Bug | File | Approx line | What to do |
|-----|------|-------------|------------|
| Row height not honoured | `FreeW.App.Host/Editing/DocumentView.cs` | ~6044 (`var wpfRow = new WpfTableRow()`) | After creating `wpfRow`, if `modelRow.HeightPt > 0`: set `wpfRow.MinHeight = modelRow.HeightPt * PxPerPoint` (AtLeast) or a fixed `Height`-equivalent (Exact) |
| Banding off-by-one | `DocumentView.cs` | ~6208 (`IsBandedBodyRow`) | Change `bodyIndex % 2 == 1` to `bodyIndex % 2 == 0` |
| VAlign not applied | `DocumentView.cs` | ~6063 (`var wpfCell = new WpfTableCell`) | Add `wpfCell.VerticalAlignment = modelCell.VerticalAlignment switch { Top→Top, Center→Center, Bottom→Bottom, _ → Top }` |
| Border style not differentiated | `DocumentView.cs` | ~6077 | WPF FlowDocument `TableCell` cannot render non-solid borders; workaround requires custom `Adorner` or `DrawingVisual` overlay |
| Per-edge colour lost | `DocumentView.cs` | ~6097 | WPF FlowDocument architecture limitation — `BorderBrush` is a single brush; would require per-edge overlay |
| BandedColumns/FirstColumn/LastColumn not rendered | `DocumentView.cs` | ~6037 (`var fmt = table.Formatting`) | Add per-column and per-cell position checks mirroring the `BandedRows` logic |
| AutoFit=Contents not measured | `DocumentView.cs` | ~6014 (`column.Width = new GridLength(...)`) | Needs a WPF measure pass to compute actual content widths before setting `TableColumn.Width` |

---

## Corpus Statistics

| # | File | Pages captured | Issues found |
|---|------|---------------|-------------|
| 01 | `01-banded-rows-header.docx` | 1 | Banding off-by-one |
| 02 | `02-banded-columns-firstlast.docx` | 1 | Column flags not rendered; banding off-by-one |
| 03 | `03-header-row-styling.docx` | 1 | PASS |
| 04 | `04-custom-borders.docx` | 1 | Per-edge colour lost; all styles same |
| 05 | `05-cell-shading.docx` | 1 | PASS |
| 06 | `06-merged-cells.docx` | 1 | PASS |
| 07 | `07-text-direction.docx` | 2 (of 3) | Row height BLOCKER; extra pages |
| 08 | `08-content-alignment.docx` | 1 | Row height BLOCKER; VAlign untestable |
| 09 | `09-wide-table.docx` | 1 | Banding off-by-one (inherited) |
| 10 | `10-nested-table.docx` | 1 | PASS |
| 11 | `11-column-widths-autofit.docx` | 1 | Contents mode not shrunk |

**11 corpus files. 4 PASS, 7 with issues.**  
**2 BLOCKER, 4 MAJOR, 2 MINOR.**

---

## Issue Count by Severity

| Severity | Count | Issues |
|----------|-------|--------|
| BLOCKER | 2 | Row height not honoured; VAlign untestable due to row height |
| MAJOR | 4 | Banding off-by-one; per-edge border colour lost; border style not differentiated; VAlign not applied |
| MINOR | 2 | AutoFit=Contents no-op; BandedColumns/FirstColumn/LastColumn not rendered |
| INFO | 1 | WPF vs Avalonia HeaderRowFill constant differs (#D9E2F3 vs #DEE9F7) |
