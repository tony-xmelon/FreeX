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
| 3 | **Charts** | 20→20 (was 20→29) | **A** | **FIXED / not-reproducing** | Rebuilt chain detaches the source package, so the drawing-merge never runs and there is no duplicate frame; merge-path hardened anyway (see §3) |
| 4 | **Fonts** | 11623/14363 | **B** | defer | Explicit font (e.g. "Segoe UI Light") drops to theme-minor on a cell's xf during ClosedXML style round-trip; font part itself is preserved |
| 5 | **NumberFormats** | 3590/3590 OK | — | OK | No longer flagged on the rebuilt chain |
| 6 | **Fills** | 14349/14363 | **B** | defer | 14 dropped style-only cells (see §5–9) |
| 7 | **Borders** | 14307/14363 | **B** | defer | 14 dropped style-only cells + 42 shared-edge collapses (see §5–9) |
| 8 | **Alignment** | 14349/14363 | **B** | defer | Same 14 dropped style-only cells as Fills |
| 9 | **ColumnWidths** | 173/293 → **293/293 OK** | **A** | **FIXED** | Genuine FreeX bug: a styled narrow/near-default modelled width was dropped on reload; fixed in the save path |

**Net effect (2026-06-19 update):** rebuilt-chain bug count is **6 → 5**. ColumnWidths is FIXED (class A, this change). Charts is OK (20→20) on every chain. The remaining 5 are CellValues (1 apostrophe cell), Fonts, Fills, Borders, Alignment — all class B (inherent ClosedXML / model-enum limitations), deferred with precise root causes below. Other chains unchanged.

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

## 3. Charts — **OK (20→20); duplicate-frame path hardened** (2026-06-19)

**Current state:** Charts is **20→20 OK on every chain** (`fxl`, `patch`, `rebuilt`, `xltx`, `ods`). The `20→29` over-count the original triage described does **not reproduce** on the rebuilt chain, because the harness detaches the source package for `xlsx-rebuilt` (`ChainRunner` calls `XlsxFileAdapter.DetachSourcePackage` before the rebuilt save). With no source package, `PreserveSourcePackageParts` (and therefore `XlsxWorksheetDrawingPartMerger`) never runs, so the chart writer's drawing is the only one — no duplicate frame. The merge-path duplication is thus a **latent** bug only reachable when a source package IS present AND a chart sheet is dirtied enough to force a full chart rewrite while still merging.

**Hardening applied (defense-in-depth, low-risk):**
- `XlsxWorksheetDrawingPartMerger.MergeDrawingPart` now de-dups anchors by their **resolved chart-part target** (not just anchor identity). After rel-id remap, a source chart anchor's rel resolves into the target drawing's rels; if that chart target is already anchored in the target (because the chart writer emitted it), the source frame is skipped. This prevents two graphicFrames for one chart even when the cNvPr name differs (`"Chart 2"` vs `"Chart 14"`).
- `XlsxWorksheetDrawingParts.ReadChartParts` now counts each resolved chart-part path **at most once per drawing**, so even a file that already contains duplicate frames loads (and re-saves) the chart only once.

Both were verified not to regress the merge path: `--chain=patch` (which keeps the source package and exercises the merger) stays Charts 20→20, Images 18→18, 0 BUG, and `tests/FreeX.Core.IO.Tests` (incl. chart/drawing preservation) is green.

**Capability-profile note:** Charts stays `Lossy` on `xlsx-rebuilt`. The comparer tolerates a *drop* as lossy but flags an *increase* as a BUG, so a future regression that re-introduces duplicate frames would still surface. No profile change.

---

## 4. ColumnWidths 173/293 → **293/293 OK** — **class A (FIXED, FreeX save-path bug)** (2026-06-19)

**Root cause (ground truth, byte-verified):** the 120 dropped columns were NOT lost by ClosedXML — they were correctly written to the rebuilt worksheet (`Calendar` rebuilt `<cols>` had `<x:col min="1" … width="1.7109375" style="1" customWidth="1"/>` for every gutter) but **dropped on RELOAD**. `XlsxWorksheetRowColumnLayoutReader.ReadColumnLayout` treats any `<col>` with a `style` attribute and `width <= 9.2` as a styling-only carrier and discards the width. ClosedXML's full save stamps a **non-default** style index (`style="1"`) on every column that carries cell formatting, so the genuinely narrow Calendar widths (1.71/3.71/5.71/6.71/2.71 — all `<= 9.2`) and the near-default Inputs widths (8.14/8.29/8.43/8.57/8.71) all matched the carrier heuristic and were dropped. Only the wide col (35.42 `> 9.2`) survived.

**Why the heuristic exists (and why it must stay):** a true ClosedXML carrier — a column with NO modelled width that only formats empty cells — is stamped with `style` + an auto width (8.43..~9.14 depending on the font) and `customWidth="1"`. The `generated-objects-001` corpus fixture exercises exactly this: a hyperlink-styled column reloads with a spurious 9.14 width unless suppressed. So narrowing the read heuristic alone would resurrect those spurious widths (and did, until corrected).

**Fix (FreeX-side, low-risk):** the **writer** discriminates, not the reader. `XlsxWorksheetColumnWidthWriter` only runs for genuinely-modelled widths (`sheet.ColumnWidths`), and now **strips the ClosedXML-stamped `style` from any modelled width in the carrier band (`<= 9.2`)**. FreeX has no per-column style model, so that stamped style is always ClosedXML's (the underlying cell styles are preserved per-cell). A genuine width therefore arrives at the reader **style-less** and is kept; a real carrier (no modelled width → the writer never touches it) keeps its style and is still dropped. The reader's `<= 9.2` heuristic is unchanged. Result: ColumnWidths **173/293 → 293/293**, and `generated-objects-001` still has zero spurious widths. Unit coverage: `tests/FreeX.Core.IO.Tests/ColumnWidthRoundTripTests.cs::StyledColumnWithNarrowOrNearDefaultWidth_RoundTripsExactly` (1.71 / 5.71 / 8.14 / 8.43 / 8.71).

## 5–9. Remaining style drift (Fonts / Fills / Borders / Alignment / CellValues) — **class B (inherent limitation, defer)**

These are introduced by the full ClosedXML rebuild and were chased to ground truth (cell-by-cell ref-vs-got style dump). They split into three distinct root causes:

- **14 dropped style-only cells** (drives Fills 14/14363, Alignment 14/14363, and 14 of the Borders mismatches; all on `todo`, e.g. `C4`/`E4`/`F10`). These are **empty styled cells** (`<c r="C4" s="284"/>`) whose only styling is a border whose Excel style is `hair` (border 79: `right="thin"`, `bottom="hair"`). FreeX's `BorderStyle` enum has **no `hair`** (only None/Thin/Medium/Thick/Dashed/Dotted/Double), so `hair` reads as `Style=None` while keeping its color. A border that is `None`-with-color collapses to an effectively-empty style, and on the rebuild the style-only cell is not re-emitted at all (verified: `C4` is absent from the rebuilt `todo` sheet). Fixing requires extending the `BorderStyle` enum (`Hair`, and likely the other missing Excel line styles) across the model + every reader/writer/adapter and the style-only-cell emission — a core-model change, deferred.
- **42 shared-edge border collapses** (the rest of Borders, e.g. `Output!B5` bottom, `Shift Calendar!B3` right). Both a cell and its neighbor carry a full thin box (border 35, all four edges thin/gray); on the ClosedXML round-trip one shared edge is dropped from one of the two cells (the neighbor keeps it). This is ClosedXML's border-model edge de-duplication in its serializer — fixable only by replacing/patching ClosedXML's border handling. Deferred.
- **Fonts** (11623/14363, the largest delta): a cell's effective font re-points off an explicit family (e.g. `Calendar!C1` "Segoe UI Light" → theme-minor "Aptos Narrow") during ClosedXML's style-model round-trip. The `<font>` definition itself survives in `styles.xml`; the cell's `xf` loses the explicit `fontId`. ClosedXML style-serializer territory — deferred.
- **CellValues** (9354/9356, the 1 remaining apostrophe cell `Happy Holidays!F5` `'Over' / 'On - Under' Budget`): ClosedXML strips the leading apostrophe as a quote-prefix marker on rebuild. Cosmetic, 1 cell; a fix risks mishandling genuine `quotePrefix` cells. Deferred (unchanged from the original triage).

**Why class B and not C (profile mis-mark):** the harness keeps style dimensions at `Cap.Full` on `xlsx-rebuilt` and only suppresses loss when a dim is `Cap.None`. Downgrading to `Lossy` would **not** silence them (`DimensionComparer.Classify` flags any style mismatch regardless of `Lossy`/`Full`); downgrading to `None` would over-suppress (it would also hide a future *total* style-loss regression). These are genuine rebuild-ceiling imperfections — extending the border-style model or replacing ClosedXML's style/border serializer — and are explicitly the deep core-path work the task says to defer. They stay flagged so the gate is honest about the rebuild's style ceiling. **No profile change is warranted.**

---

## Capability-profile (`CapabilityProfile.cs`) — no change required

The existing `xlsx-rebuilt` profile (`CF`/`Charts`/`Images` = `Lossy`, `VBA` = `None`, everything else `Full`) already matches reality for the dimensions in scope:
- **Hyperlinks** stays `Full` — the apparent loss was a harness counting artifact (fixed in the snapshot), not a real rebuild ceiling.
- **Charts** stays `Lossy` — it round-trips 20→20, and `Lossy` still flags any *increase* (duplicate-frame regression).
- **ColumnWidths** stays `Full` — it is now fixed and round-trips 293/293; it must keep flagging any future drop.
- **Style dims** stay `Full` — see §5–9; a `Lossy`/`None` mark would either not silence them or would over-suppress real regressions.

---

## What was fixed vs deferred

**Fixed earlier (low-risk, FreeX-side):**
- Emoji `_xHHHH_` decode on the formula-string read path (`XlsxClosedXmlCellMapper.DecodeUnresolvedXmlHexEscapes`) + 9 unit tests. CellValues 9331→9355 of 9356.

**Fixed now (2026-06-19, low-risk, FreeX-side):**
- **ColumnWidths** (§4) — styled narrow/near-default modelled widths dropped on reload. `XlsxWorksheetColumnWidthWriter` now strips the ClosedXML-stamped column style from a genuinely-modelled width in the `<= 9.2` carrier band so the loader keeps it. 173/293 → 293/293; +5 round-trip test cases. The reader heuristic and the `generated-objects-001` carrier-suppression are unchanged.
- **Charts duplicate-frame path** (§3) — hardened (de-dup drawing anchors by resolved chart-part target in `XlsxWorksheetDrawingPartMerger`; de-dup chart elements per drawing in `ReadChartParts`). The rebuilt chain already round-tripped 20→20 (source package detached), so this is defense-in-depth for the latent merge-path case; verified non-regressing via `--chain=patch` and the IO test suite.

**Corrected earlier (harness honesty):**
- Merged-region hyperlink counting (`WorkbookSnapshot.CountEffectiveHyperlinks`). Hyperlinks 27→11 reframed as 11→11 OK.

**Deferred (with reason):**
- **Style drift** (§5–9, Fonts/Fills/Borders/Alignment) — three distinct ClosedXML/model-enum limitations: (a) 14 style-only cells with an unmodelled `hair` border collapse and are dropped (needs `BorderStyle` enum extension across the core model + all adapters); (b) 42 shared-edge border collapses in ClosedXML's serializer; (c) explicit-font xf re-point in ClosedXML's style round-trip. All are deep core-path / ClosedXML-replacement work — explicitly out of the "low-risk only" scope. The highest-yield follow-up is extending `BorderStyle` (recovers the 14 style-only cells across Fills+Align+Border at once).
- **Leading-apostrophe strip** (1 cell, §1) — ClosedXML quote-prefix behavior; cosmetic, risky to "fix" without breaking genuine `quotePrefix` cells.

**Verification (2026-06-19):** `dotnet test tests/FreeX.Core.IO.Tests` green (2753 passed, 53 skipped) — no regression. Harness `--chain=rebuilt`: **6 → 5 BUG** (ColumnWidths cleared); `--chain=patch` 0 BUG (Charts 20→20, Images 18→18); fxl/xltx/csv/txt chains unchanged.
