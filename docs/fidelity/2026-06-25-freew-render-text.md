# FreeW Text/Layout Fidelity Render Triage — 2026-06-25

Corpus: 11 .docx files in `freew-fidelity-corpus/files/text/`
Rendered by: `FreeW.FidelityRender` Release build (FidelityRender.dll) → 816×1056 px PNGs
Render path: DocxReader → TextDocument → DocumentView.Render() → FlowDocument → WPF Paginator
Word baselines: NOT generated (Word COM deferred per instructions; VS-WORD flag marks items needing it)

---

## Per-File Triage

### 01-heading-styles.docx
**Features exercised:** Title, Heading1, Heading2, Heading3, Normal paragraph styles applied via `paragraph.StyleId`.

**FreeW render verdict: BROKEN**

All five paragraphs — Title, H1, H2, H3, and Normal — render in identical Calibri 11pt plain black text. The heading hierarchy is visually indistinguishable from body copy. There are no size differences, no bold treatment, no colour, no spacing differentiation.

**Issues:**

| # | Severity | What is seen | Suspected cause |
|---|----------|--------------|-----------------|
| H1 | BLOCKER | H1/H2/H3/Title all render at Calibri 11pt plain black, same as Normal | `DocxWriter.BuildStyles` (DocxWriter.cs ~5571) only writes styles present in `doc.Styles`. A freshly authored `TextDocument` has an empty `Styles` dict (no `DocumentStyleSet.Apply` called), so no `<w:style>` elements appear in styles.xml. When DocxReader parses the file it finds nothing and `document.Styles` stays empty. `DocumentView.Resolve()` (DocumentView.cs ~11245) then finds no match for the paragraph's `StyleId` and falls back to the document default run/paragraph formatting — identical for all paragraphs. Root fix: `DocxWriter` should seed built-in heading styles when a paragraph references them and the `Styles` dict lacks them. |

**VS-WORD?** Yes — confirms Word renders the correct semantic sizes (16/13/12/28pt) while FreeW collapses all to 11pt.

---

### 02-char-formatting.docx
**Features exercised:** Bold, italic, underline, strikethrough, combined bold+italic+underline, superscript/subscript, highlight, font colour, all-caps, small-caps, multiple font families and sizes, character spacing (expand/condense).

**FreeW render verdict: MOSTLY OK — 2 minor issues**

Most character formatting renders correctly:
- Bold, italic, underline, strikethrough, combined formatting: correct
- Superscript (mc²) and subscript (H₂O): both render with correct baseline shift and reduced glyph size
- Highlight yellow: solid yellow background behind the sample text — correct
- Font colours red and blue: correct colour rendering
- All-caps: text renders in uppercase — correct
- Small-caps: renders in small capitals — correct
- Font family/size combos: Times New Roman 14pt, Courier New 10pt, Georgia 16pt bold all render distinctly — correct
- Expanded/condensed character spacing: visibly wider/narrower inter-character spacing — correct

**Issues:**

| # | Severity | What is seen | Suspected cause |
|---|----------|--------------|-----------------|
| CF1 | MINOR | The "Character Formatting Showcase" heading renders in plain Calibri 11pt (same as Normal), no visual distinction from the body lines | Same Heading1 style-miss as issue H1 above — `StyleId = "Heading1"` is set but the style has no definition |
| CF2 | MINOR | Character spacing "Expanded +2pt" text is wider than baseline but the change looks small — hard to confirm magnitude without Word baseline | VS-WORD: confirm that +2pt spacing is faithfully reflected at this scale |

---

### 03-lists.docx
**Features exercised:** Bullet list (level 0 and level 1 nesting), numbered list (level 0), multilevel (outline) list with 3 indent levels.

**FreeW render verdict: MOSTLY OK — 2 issues**

Bullets render with filled circle glyphs at level 0. Level 1 ("Nested sub-item", "Another nested sub-item") also shows a filled bullet — but at the **same indent level** as the top-level items. The visual indent does not increase for level 1; all six bullet items appear left-aligned at the same horizontal position.

Numbered list renders "1. First step" through "4. Fourth step" with correct sequential numbering and visible left indent.

Multilevel outline renders correctly with numeric prefixes: 1, 2, 2.1, 2.2, 2.2.1, 3, 3.1, 3.2, 4 — formatting matches expected outline style.

**Issues:**

| # | Severity | What is seen | Suspected cause |
|---|----------|--------------|-----------------|
| L1 | MAJOR | Bullet list level 1 items ("Nested sub-item", "Another nested sub-item") are NOT indented further than level 0 items — all bullets appear at the same left margin | The bullet list indent is driven by `ListLevel` in `ParagraphFormatting`. In `BuildParagraph` (DocumentView.cs ~6250), the left margin is set from `paraFmt.IndentLeftPt * PxPerPoint`. For a list paragraph the `IndentLeftPt` comes from the resolved style/formatting. The DocxWriter maps `ListLevel` to a `w:ilvl` on the numbering definition but does NOT set a corresponding `w:ind` override on the paragraph itself — nested list paragraphs have zero `IndentLeftPt` in the model. Word reads the indent from the abstractNum level definition; FreeW's `DocxReader` does not read back numbering level indents into the paragraph's `IndentLeftPt`. |
| L2 | MINOR | "Unordered (bullet) list:" and "Ordered (numbered) list:" and "Multilevel (outline) list:" all render at Calibri 11pt plain black — the Heading2 style is not applied | Same Heading2 style-miss as H1. |

---

### 04-para-alignment.docx
**Features exercised:** Left, Center, Right, Justify alignment across a 3-sentence test block.

**FreeW render verdict: MOSTLY OK — 1 minor issue**

All four alignment modes render correctly on their own terms:
- LEFT: text starts at the left margin and wraps naturally — correct
- CENTER: each line is centred within the text area — correct
- RIGHT: each line ends flush with the right margin — correct
- JUSTIFY: text is spread to fill the full line width — correct

**Issues:**

| # | Severity | What is seen | Suspected cause |
|---|----------|--------------|-----------------|
| A1 | MINOR | The "Paragraph Alignment" heading renders at Calibri 11pt plain (Heading1 style not applied) | Same root cause as H1 |

No issues with the alignment behaviour itself.

---

### 05-line-spacing.docx
**Features exercised:** Multiple spacing at 1.0, 1.15, 1.5, 2.0; At Least 18pt; Exact 24pt; Space Before 24pt; Space After 24pt.

**FreeW render verdict: MOSTLY OK — 2 issues, 1 correctness concern**

The progression Single → 1.15 → 1.5 → Double is visually apparent — each successive paragraph is taller than the previous. "At Least 18pt" and "Exact 24pt" paragraphs are taller than 1.0 and 1.15 respectively. "Space Before 24pt" has a visible gap above it. "Space After 24pt" has a visible gap below it.

**Issues:**

| # | Severity | What is seen | Suspected cause |
|---|----------|--------------|-----------------|
| S1 | MINOR | The visual gap between Double (2.0) and "At Least 18pt" is smaller than expected — 2.0-spaced paragraph appears nearly the same height as "At Least 18pt" | At Least approximated as exact in `BuildParagraph` (DocumentView.cs ~6270): `LineStackingStrategy = MaxHeight` for AtLeast vs BlockLineHeight for Exact. The doc default is 11pt Calibri, and 2× natural height ≈ ~25px ≈ "At Least 18pt" visually — at this small font size the difference is subtle. VS-WORD needed for confirmation. |
| S2 | MINOR | Heading "Line Spacing & Paragraph Spacing" renders at Calibri 11pt plain | Same Heading1 style-miss |

---

### 06-indents.docx
**Features exercised:** No indent (baseline), left 36pt, right 36pt, both 36pt, first-line +36pt, hanging indent (left=36, first-line=-36), deep left 72pt, deep hanging 72/−36.

**FreeW render verdict: OK — 1 minor heading issue**

All eight indent variants render with the correct visual offsets. "Left indent 36pt" is clearly indented left. "Right indent 36pt" text wraps at a narrower right margin. "Both 36pt" is indented on both sides. "First-line +36pt" has only its first line indented. "Hanging -36pt" has the first line hanging back left while continuation lines are indented. "Deep left 72pt" and "deep hanging 72/−36" both render correctly at greater offset.

**Issues:**

| # | Severity | What is seen | Suspected cause |
|---|----------|--------------|-----------------|
| I1 | MINOR | "Paragraph Indentation" heading renders at Calibri 11pt plain | Same Heading1 style-miss |

---

### 07-tab-stops.docx
**Features exercised:** Right-aligned tab at 396pt with dot leader (TOC style), right-aligned tab at 360pt with dash leader, centre-aligned tab at 216pt, decimal-aligned tab at 288pt.

**FreeW render verdict: BROKEN — tab leaders and custom alignment absent**

The rendered output shows the text on each side of the `\t` character but the tab gap is not filled with any leader character. "Introduction  1" shows a raw gap with no dots between the title and the page number. Similarly no dashes appear for the dash-leader section. The "Centered text" column is not centred around the 216pt position. The decimal values (1234.56, 89.9, 7.25) are not decimal-aligned — they appear left-aligned at the tab position.

The text is still readable and the tab jump occurs (values appear to the right), but all custom tab stop functionality is absent.

**Issues:**

| # | Severity | What is seen | Suspected cause |
|---|----------|--------------|-----------------|
| T1 | BLOCKER | All tab leaders (dots, dashes) are absent — the gap between label and value is empty whitespace | WPF FlowDocument has no custom tab stop API. `BuildParagraph` (DocumentView.cs ~6311) explicitly documents this: "WPF's FlowDocument Paragraph has no tab-stop API, so tab stops cannot be rendered with custom positions/alignments (default tab rendering applies visually)." Tab stops are stored only in the `ParagraphTag` for round-trip; they never influence the visual render. |
| T2 | BLOCKER | Tab stop alignment (right, centre, decimal) is not honoured — all tab-separated values appear at the default left-tab position | Same root cause as T1: no WPF FlowDocument equivalent. The tab character jumps to the default 36pt-interval tab stop rather than the explicitly set position. |

---

### 08-drop-cap.docx
**Features exercised:** Drop cap applied via `DropCap.ApplyDropCap()` at 42pt (first paragraph) and 56pt (second paragraph). One normal comparison paragraph.

**FreeW render verdict: PARTIALLY OK — drop cap letter renders large but not truly "dropped"**

The large bold "O" (42pt) and "E" (56pt) glyphs are visible at the start of their paragraphs and are correctly bold and enlarged. However, they are rendered as inline large glyphs that push the first line taller rather than being dropped into the body text area (i.e., the "O" sits above the text baseline with the rest of the sentence on line 1, then line 2 continues at the left margin — rather than the "O" sinking 2-3 lines deep while the text wraps around it on its right).

This is a structural limitation: Word's drop-cap uses a floating frame (a text frame positioned in the margin), which is not modelled in FreeW's drop cap implementation (`DropCap.ApplyDropCap` in DropCap.cs simply enlarges the first run's font size, without any frame). FreeW's `DropCap.ApplyDropCap` enlarges the first character's run in-place within the paragraph flow. This is what the render sees.

**Issues:**

| # | Severity | What is seen | Suspected cause |
|---|----------|--------------|-----------------|
| D1 | MAJOR | Drop cap renders as an oversized inline character that pushes its line taller, not as a classic drop cap that sinks into the body text with text wrapping alongside | `DropCap.ApplyDropCap` (DropCap.cs) only sets `FontSizePt` and `Bold = true` on the first run — no floating frame. Word stores a true drop cap as a floating `w:framePr` text frame; FreeW's model has no equivalent. The oversized glyph is in the normal inline flow so WPF just increases the line height for that run. |

---

### 09-multicolumn.docx
**Features exercised:** 2-column layout (`ColumnCount = 2`, `ColumnSpacingPt = 36`, `ColumnsLineBetween = true`).

**FreeW render verdict: BROKEN — columns not rendered, no line between**

The page renders as a single full-width column — all 6 paragraphs flow vertically one after another from top to bottom across the full text width. No two-column split is visible. No vertical rule appears between columns.

**Issues:**

| # | Severity | What is seen | Suspected cause |
|---|----------|--------------|-----------------|
| M1 | BLOCKER | Multi-column layout is completely absent — page renders as single column | `ApplyColumnLayout` (DocumentView.cs ~5390) is correct in implementation but the render path in `FidelityRender` may not call it. More specifically: the FidelityRender tool creates a `FlowDocument` from the model but may not invoke the same render setup as the live editor. Alternatively, `ColumnCount` from `Page` must be set on the FlowDocument — if the FidelityRender tool's render path does not call `ApplyColumnLayout`, columns are skipped. VS-WORD needed to confirm expected two-column output. |
| M2 | BLOCKER | Column separator line absent | Consequence of M1 — `flow.ColumnRuleWidth` never set. |

---

### 10-section-break.docx
**Features exercised:** Next-page section break with Section 2 in landscape (11"×8.5"), narrower margins.

**FreeW render verdict: BROKEN — section break not honoured, no page switch, all on one portrait page**

Both Section 1 and Section 2 content render on a single portrait page. There is no page break before Section 2, no width change to landscape, no margin change. The "(Section 1 ends — next-page break)" annotation and "Section 2 — Landscape, Narrower Margins" heading both appear inline on the same portrait page.

**Issues:**

| # | Severity | What is seen | Suspected cause |
|---|----------|--------------|-----------------|
| SB1 | BLOCKER | Section break (next-page) does not create a new page — all content collapses onto one portrait page | The FidelityRender tool renders the document to a single `FlowDocument` / paginator. When it reads the document through `DocumentView`, `BuildParagraph` (DocumentView.cs ~6242) sets `BreakPageBefore` only when `paraFmt.PageBreakBefore` is set or the paragraph has an `IsPageBreak` run — NOT when the paragraph carries a `SectionBreak`. The section break's page-break semantics are not honoured by the FlowDocument paginator path for rendering. |
| SB2 | BLOCKER | Landscape page dimensions not adopted for Section 2 — rendered at 816×1056 portrait throughout | Section 2's `PageSettings` (792×612, landscape) is present in the model on the `SectionBreak`, but the FidelityRender tool uses a fixed 816×1056 canvas (Letter portrait). Multi-section page-size variation requires per-section page canvases, which the current single-FlowDocument path cannot provide. |
| SB3 | MINOR | "Section 2 — Landscape, Narrower Margins" heading renders in Calibri 11pt plain | Same Heading1 style-miss |

---

### 11-page-border-watermark.docx
**Features exercised:** Double-line dark blue page border (`PageBorder` with `BorderLineStyle.Double`, width 2.25pt, color `#003366`). Diagonal grey DRAFT watermark (`WatermarkOptions`, text "DRAFT", Calibri 72pt, `#C0C0C0`, 40% opacity).

**FreeW render verdict: BROKEN — both page border and watermark absent**

The rendered page shows only plain white background with the body text. No border appears around the page edge. No "DRAFT" watermark is visible behind the text.

**Issues:**

| # | Severity | What is seen | Suspected cause |
|---|----------|--------------|-----------------|
| PB1 | BLOCKER | Page border is completely absent | `DocumentView` applies the page border at render time (DocumentView.cs ~4427) by adding a `Border` element to the page's visual tree. The FidelityRender tool renders via a WPF paginator wrapping a FlowDocument — it builds the FlowDocument content but the page border is applied to `DocumentView`'s own XAML page-frame element (`_pageBorderElement` or equivalent), not to the FlowDocument. If FidelityRender does not replicate that page-border XAML layer, it simply does not appear. |
| PB2 | BLOCKER | Watermark is completely absent | `DocumentView` sets `Background = BuildWatermarkBrush(...)` (DocumentView.cs ~4443-4446) on the FlowDocument itself. If FidelityRender creates a fresh `FlowDocument` without copying this background brush, the watermark is invisible. The actual `BuildWatermarkBrush` (DocumentView.cs ~5230) works correctly in the editor but the FidelityRender tool may not invoke this path. |

---

## Summary Table (prioritized by severity)

| Rank | File | Feature | Severity | Issue summary |
|------|------|---------|----------|---------------|
| 1 | 01-heading-styles | Heading styles H1/H2/H3/Title | BLOCKER | All headings render at 11pt Calibri identical to Normal — style catalog not seeded in authored docs |
| 2 | 07-tab-stops | Tab leaders (dots/dashes) | BLOCKER | No leader fill rendered — WPF FlowDocument has no tab-stop API |
| 3 | 07-tab-stops | Tab stop alignment (right/center/decimal) | BLOCKER | Not honoured — same root cause as above |
| 4 | 09-multicolumn | 2-column layout + column rule | BLOCKER | Single-column only — `ApplyColumnLayout` not invoked in FidelityRender path |
| 5 | 10-section-break | Next-page section break | BLOCKER | No page break, no landscape switch — section break semantics not in FlowDocument paginator |
| 6 | 10-section-break | Per-section page size (landscape) | BLOCKER | Section 2 rendered at portrait dimensions — single-FlowDocument cannot vary page size |
| 7 | 11-page-border-watermark | Page border | BLOCKER | Absent — page-border XAML layer not replicated in FidelityRender |
| 8 | 11-page-border-watermark | Watermark | BLOCKER | Absent — `BuildWatermarkBrush` background not applied in FidelityRender path |
| 9 | 03-lists | Bullet list nesting indent | MAJOR | Level-1 bullets not indented — numbering-level indent not read from abstractNum into model |
| 10 | 08-drop-cap | Drop cap layout | MAJOR | Renders as oversized inline glyph, not true dropped cap — no floating frame in model |
| 11 | 01-heading-styles | Title/H1/H2/H3 visual treatment | (covered by rank 1) | — |
| 12 | 02-char-formatting | Heading label in char-fmt doc | MINOR | Heading1 style not applied — same root cause |
| 13 | 05-line-spacing | Heading label in spacing doc | MINOR | Heading1 style not applied |
| 14 | 06-indents | Heading label in indent doc | MINOR | Heading1 style not applied |
| 15 | 04-para-alignment | Heading label in alignment doc | MINOR | Heading1 style not applied |

**Character formatting (02), paragraph alignment (04), line spacing (05), and indents (06) all render correctly** for their primary feature. These are solid passes on the core text formatting model.

---

## Root-cause analysis: two distinct systemic issues

**Issue class A — Style catalog not populated for authored docs (affects 01, and the heading labels in 02-06)**
`DocxWriter.BuildStyles` writes only styles already in `doc.Styles`. A freshly constructed `TextDocument` (as in corpus generators) has no entries. `DocxReader` then finds nothing and `DocumentView.Resolve` falls back to defaults for every `StyleId`. Fix: `DocxWriter` should seed built-in heading/Normal styles when they are referenced but absent, or the corpus generator should call `DocumentStyleSet.Apply(doc, DocumentStyleSet.Default)` before writing.

**Issue class B — FidelityRender render path incomplete (affects 09, 10, 11)**
The FidelityRender tool creates a `FlowDocument` and paginates it but does not replicate the full `DocumentView.Render()` setup — specifically: `ApplyColumnLayout`, page border XAML layer, and watermark background brush are not applied. Section-break page-size variation also requires per-section page canvases that the single-FlowDocument path cannot support.

**Issue class C — WPF FlowDocument architectural limitation (affects 07)**
Tab stop custom positions, alignment and leader fills cannot be represented in a WPF `FlowDocument`. This is a known, documented limitation (comment at DocumentView.cs ~6311). The model round-trips correctly to docx but the render is visually inaccurate. A future fix would require custom `InlineUIContainer` tab-rendering or a non-FlowDocument render path.
