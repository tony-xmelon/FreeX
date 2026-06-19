# XLSX Rebuild Round-Trip Triage — `xlsx → xlsx (rebuilt)` chain

**Date:** 2026-06-19
**Harness:** `tools/FreeX.FormatFidelity` — `--chain=rebuilt`
**Asset:** `_fidelity-assets/ExcelExamples1.xlsx`
**Chain under test:** load source → `ForceRebuildMutation` (dirty one far cell so patch-save can't apply, forcing a **full ClosedXML re-save**) → reload → compare reference vs reloaded.

The rebuilt chain flagged **9 BUG** dimensions at baseline. Each was investigated to ground truth by inspecting the written package bytes (`sharedStrings.xml`, worksheet `<c>`/`<hyperlink>`/`drawingN.xml`) and by re-loading source vs rebuilt with both the FreeX adapter and bare ClosedXML. Classification key:

- **(A) Genuine FreeX-fixable loss** — the full-save (or its load) path drops/corrupts modeled content it should keep. Fixable in FreeX code.
- **(B) Inherent ClosedXML limitation** — only fixable by changing/replacing ClosedXML or widening verbatim source-preservation; out of scope for a quick fix.
- **(C) Capability-profile mis-mark** — expected loss on a rebuild; correct `CapabilityProfile.cs`.
- **(D) Harness extraction artifact** — a counting/representation difference, not a real change.

---

## Summary table

| # | Dimension | Baseline | Class | Disposition | Evidence (one-line) |
|---|---|---|---|---|---|
| 1 | **CellValues** | 9331/9356 | **A** (24 cells) + **B** (1 cell) | **FIXED** (emoji) / defer (apostrophe) | Astral emoji in cached formula-string `<v>` reload as `_xHHHH_`; 1 leftover is ClosedXML quote-prefix strip |
| 2 | **Hyperlinks** | 27→11 | **D** | **CORRECTED (harness)** | Range hyperlink over a merged cell expands per-cell on read, collapses to merge anchor on write — no real loss |
| 3 | **Charts** | 20→29 | **A** | **DEFER** (core-save surgery) | Drawing-part merger re-adds the source graphicFrame alongside FreeX's → duplicate frame per chart |
| 4 | **Fonts** | 11844/14782 | **B** | defer | Explicit font (e.g. "Segoe UI Light") drops to theme-minor on a cell's xf during ClosedXML style round-trip; font part itself is preserved |
| 5 | **NumberFormats** | 14768/14782 | **B** | defer | ~14 cells of ClosedXML style round-trip drift |
| 6 | **Fills** | 14768/14782 | **B** | defer | ~14 cells; ClosedXML fill round-trip drift |
| 7 | **Borders** | 14715/14782 | **B** | defer | ~67 cells; ClosedXML border round-trip drift |
| 8 | **Alignment** | 14745/14782 | **B** | defer | ~37 cells; ClosedXML alignment round-trip drift |
| 9 | **ColumnWidths** | 173/293 | **B** | defer | 120 columns lose their explicit width (reload = 0/absent) on a full ClosedXML rebuild |

**Net effect of this change:** rebuilt-chain bug count **9 → 8** (Hyperlinks now OK, CellValues emoji fixed but still flagged for the 1 residual apostrophe cell). The other pre-existing chains are unchanged (`fxl→fxl` 2, `xlsx→xml` 2 — both out of scope for this task).

---

## 1. CellValues — emoji `_xHHHH_` escaping — **class A (FIXED)** + 1 residual class B

**What the harness shows:** `Any Month!E10`, `I12`, `Budget v Actual!G6`, … — astral emoji turn into literal escape text, e.g.

```
SRC=[🎂Wedding Anniversary]   GOT=[_xD83C__xDF82_Wedding Anniversary]   (U+1F382 = surrogate pair D83C DF82)
```

**Ground truth:**
- The **written** rebuilt `sharedStrings.xml` stores the emoji as **raw UTF-8** (`F0 9F 8E 82`) with **zero** `_x` escapes. The write is correct.
- The affected cells are **formula cells** (`t="str"`): `Any Month!I12` is `<c t="str"><f>Calc!AF33</f><v>_xD83C__xDF82_Wedding Anniversary</v></c>` in the rebuilt worksheet — ClosedXML's **writer escaped the astral char into `<v>`**, but its **reader only un-escapes the shared/inline-string path, not the cached `<v>` value**. Loading the *source* (which stores raw `<v>🎂…`) reads correctly; loading the rebuilt file reads `_xD83C_…`. Confirmed identical behavior with **bare ClosedXML** (`cell.GetText()`), so the defect is in ClosedXML, surfaced only on the formula-result path.
- 24 of 25 CellValue mismatches are this emoji case (all `HasFormula=true`).

**Fix (FreeX-side, low-risk):** `XlsxClosedXmlCellMapper.DecodeUnresolvedXmlHexEscapes` — applied to the text branch of `MapValue(XLCellValue)`. It re-assembles `_xHHHH_` surrogate-half escapes into the real character and is **scoped to only run when a surrogate-half escape (`_xD800_`–`_xDFFF_`) is present**. A lone surrogate half is never valid in a real .NET string, so the decode can never collide with legitimate literal text (and Excel re-escapes any genuine `_x0041_`-style literal on every save, so BMP escapes never reach the model as literal text). Result: CellValues **9331/9356 → 9355/9356**. Unit coverage: `tests/FreeX.Core.IO.Tests/XlsxFormulaStringEmojiRoundTripTests.cs` (9 cases).

**Residual (1 cell, class B, deferred):** `Happy Holidays!F5` is a plain shared string whose literal value is `'Over' / 'On - Under' Budget` (leading apostrophe is a real character). On rebuild ClosedXML strips the leading `'` (interpreting it as a text/quote-prefix marker). Niche (1 cell, cosmetic), and a fix risks mishandling genuine `quotePrefix` cells — defer.

---

## 2. Hyperlinks 27→11 — **class D (harness artifact, CORRECTED in harness)**

**Ground truth:** the loss is entirely on **merged cells**.
- `Gantt Chart Template`: source 17 → got 5. 13 of the "lost" entries are row-3 hyperlinks on cells `A3..M3`, all `http://chandoo.org/wp/`. The source stores a **single** `<hyperlink ref="A3:M3">` over the **merged region `A3:AM3`**. ClosedXML's reader **expands** that range into 13 per-cell `XLHyperlink` objects (inflating the count to 27); on write only the **merge anchor `A3`** survives (Excel anchors a merged cell's hyperlink at its top-left), so the rebuilt drawing/worksheet has `ref="A3"`.
- `Quick Gantt`: source 5 → got 1, identical pattern (`ref="R3:V3"` over merged `R3:V3`).
- Verified that a fresh ClosedXML workbook with 5 distinct same-URL hyperlinks round-trips all 5 — the collapse is specifically the **merged-cell** anchoring, not ClosedXML losing hyperlinks in general.

No user-visible hyperlink is lost: each merged cell keeps its one clickable link. The `27` was an over-count produced by ClosedXML's read-time range expansion over a merge.

**Correction (harness, honest baseline):** `WorkbookSnapshot.CountEffectiveHyperlinks` now counts hyperlinks **collapsed per merged region** — a merged region contributes at most one hyperlink (its anchor), standalone hyperlinks count once. This matches what Excel renders and what round-trips. The dimension now reads **11→11 OK**. This does **not** mask a real loss: if a genuinely distinct hyperlink were dropped, the collapsed counts would still differ.

---

## 3. Charts 20→29 — **class A (genuine bug, DEFER fix)**

**Not a count artifact, and not a disk duplication of chart parts** — source and rebuilt both have **35** `chartN.xml` parts on disk. The over-count is **duplicate `graphicFrame` anchors in the worksheet drawing**.

**Ground truth:** for sheets like `Data Entry (2)` (3→6) and `Budget Summary` (3→6), the rebuilt `drawingN.xml` contains **two `<xdr:twoCellAnchor>` graphicFrames for every chart**, both referencing the **same** relationship id (`rIdFreeXChart14`):
- one clean frame FreeX's `XlsxWorksheetChartWriter` emits (empty `<xdr:xfrm/>`, `name="Chart 14"`), and
- one source-package frame (`macro=""`, original `creationId`, `name="Chart 2"`, `<a:off 0,0><a:ext 0,0>`).

`XlsxWorksheetChartWriter.WriteWorksheetCharts` *replaces* the drawing with its own anchors, but `XlsxWorksheetDrawingPartMerger.MergeDrawingPart` then **re-adds** the source-package's original anchor because its anchor-identity (`GetDrawingAnchorIdentity`) differs from the freshly-written one — yielding two frames pointing at one chart. The reader (`XlsxWorksheetDrawingParts.ReadChartParts`, which counts every `<c:chart>`/`<cx:chart>` element) then loads each chart twice.

This is a real defect (the written file has duplicate, zero-sized frames; the model loads duplicate `ChartModel`s). **Deferred** per the task's instruction not to perform risky deep surgery on the core XLSX save path: the correct fix is in `XlsxWorksheetDrawingPartMerger` (de-dup anchors by the chart relationship **target** rather than by full anchor identity, so a chart already emitted by the chart writer is not re-added from the source drawing), with a secondary hardening in `ReadChartParts` (de-dup chart elements by resolved chart-part path). Both touch the heavily-tested chart/drawing preservation path and warrant their own focused change + chart round-trip test pass.

**Capability-profile note:** Charts is already `Lossy` on `xlsx-rebuilt`, but the comparer only tolerates a *drop* (`gotVal <= refVal`) as lossy; an *increase* (20→29) correctly stays a BUG. The profile is **not** changed for this — masking the increase would hide the genuine duplication defect.

---

## 4–9. Style-fidelity drift (Fonts / NumberFormats / Fills / Borders / Alignment / ColumnWidths) — **class B (inherent ClosedXML rebuild limitation, defer)**

These are per-cell/per-column style differences introduced by a full ClosedXML rebuild round-trip:

- **Fonts** (11844/14782): a cell's effective font changes, e.g. `Calendar!C1` "Segoe UI Light" → theme-minor "Aptos Narrow". The `<font>` definition **survives** in the rebuilt `styles.xml` (grep confirms "Segoe UI Light" present in both) and the theme major/minor fonts are **identical** (`Aptos Display`/`Aptos Narrow`) — the loss is that a cell's `xf` re-points off the explicit font during ClosedXML's style-model round-trip. The largest of the style deltas (~2900 cells).
- **NumberFormats / Fills / Borders / Alignment** (14–67 cells each, ~99.9% match): small ClosedXML style round-trip drift.
- **ColumnWidths** (173/293): 120 columns (e.g. `Calendar` cols 1–6, src widths 1.71/3.71/5.71…) reload with **no explicit width** (0/absent) after a full ClosedXML rebuild; default column width is preserved (8.43→8.43).

**Why class B and not C:** the harness intentionally keeps style dimensions at `Cap.Full` on `xlsx-rebuilt` and only suppresses style loss when a dimension is `Cap.None` (→ EXPECTED-LOSS). Downgrading these to `Lossy` would **not** silence them (`DimensionComparer.Classify` flags any style mismatch regardless of `Lossy`/`Full`), and downgrading to `None` would be too coarse — it would also hide a future *total* style-loss regression. These are genuine imperfections of the ClosedXML rebuild path; closing them requires either widening verbatim source-preservation for styles or replacing ClosedXML's style serializer — out of scope for a quick fix and explicitly the kind of deep core-path work the task says to defer. They are correctly left flagged so the gate stays honest about the rebuild's style ceiling.

---

## Capability-profile (`CapabilityProfile.cs`) — no change required

The existing `xlsx-rebuilt` profile (`CF`/`Charts`/`Images` = `Lossy`, `VBA` = `None`, everything else `Full`) already matches reality for the dimensions in scope:
- **Hyperlinks** stays `Full` — the apparent loss was a harness counting artifact (fixed in the snapshot), not a real rebuild ceiling.
- **Charts** stays `Lossy` — the `20→29` increase is a genuine duplication bug, not expected loss; the profile must keep flagging it.
- **Style dims** stay `Full` — see §4–9; a `Lossy`/`None` mark would either not silence them or would over-suppress real regressions.

---

## What was fixed vs deferred

**Fixed now (low-risk, FreeX-side):**
- Emoji `_xHHHH_` decode on the formula-string read path (`XlsxClosedXmlCellMapper.DecodeUnresolvedXmlHexEscapes`) + 9 unit tests. CellValues 9331→9355 of 9356.

**Corrected now (harness honesty):**
- Merged-region hyperlink counting (`WorkbookSnapshot.CountEffectiveHyperlinks`). Hyperlinks 27→11 reframed as 11→11 OK.

**Deferred (with reason):**
- **Charts duplication** (§3) — genuine bug, but the fix is in the heavily-tested drawing-merge / chart-read core path. Recommended fix: de-dup drawing anchors by chart relationship target in `XlsxWorksheetDrawingPartMerger`, plus chart-element de-dup in `ReadChartParts`; gate with a chart round-trip test pass.
- **Style drift** (§4–9, Fonts/NumberFormats/Fills/Borders/Alignment/ColumnWidths) — inherent to ClosedXML's full-rebuild style serialization; not a quick win. The column-width drop (120 cols) is the most worth a follow-up; the per-cell style deltas (≤67 cells) are low-yield.
- **Leading-apostrophe strip** (1 cell, §1) — ClosedXML quote-prefix behavior; cosmetic, risky to "fix" without breaking genuine `quotePrefix` cells.

**Verification:** `dotnet test tests/FreeX.Core.IO.Tests` green (2651 passed, 53 skipped) — no regression. Harness `--chain=rebuilt`: 9 → 8 BUG; patch/fxl/csv/txt chains unchanged.
