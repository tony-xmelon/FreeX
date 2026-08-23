# Avalonia Parity Wave 192 Integration

Date: 2026-08-23

Wave 192 processes one bounded slice per application and brings the cumulative
app-slice count to **576**. Generated command inventories continue to report
zero actionable Avalonia-missing commands across FreeX, FreeW, and FreeP. This
wave closes a production Linux font-color workflow, reduces another measured
FreeW Font dialog residual, and records a fully measured FreeP investigation
where both candidate changes were rejected rather than retaining a
fixture-specific or regressing correction.

## FreeX

The production Linux X11 font-color AutoFilter lane passes **1/1** through the
rendered `#00B050` swatch, save, the identity-checked production Open picker,
and reopen. It retains rendered `North,East,`, independently reads semantic
`A4=East`, and saves `cellColor=0`, `dxfId=0`, and font `FF00B050`.

The lane requires a rendered-pixel transition from white to `#00B050` before
the bounded swatch click can receive credit. The saved XLSX is then inspected
through worksheet and style XML rather than trusting the UI state. Four
rendered PNGs, the fixture and saved package, diagnostics, source hashes, Git
blob hashes, and the Docker image digest are retained under
`docs/parity/evidence/wave192-freex-autofilter-font-color-20260823/`.
Wave 191's fill-color selector and criteria guard remain covered.

Independent review found that the initially retained Wave 191 and Wave 192
workbooks had lost their modeled color criteria during a loaded-package patch
save even though the pre-save runtime parser had observed them. The production
patch writer now re-emits modeled worksheet and table AutoFilter criteria.
Both physical lanes were rerun from current source, and package-semantic tests
now open the committed XLSX files and require the expected `colorFilter` and
DXF color nodes. The corrected fill and font workbooks pass those checks.

## FreeW

The Avalonia Font dialog now aligns the complete effects lane by one pixel and
uses measured trailing margins for Underline and Small Caps. Across the three
canonical Font states, aggregate changed pixels fall from **36,053** to
**34,196**, a **5.1508%** relative reduction. Every state improves in changed
pixels and mean channel delta, while WPF and Avalonia painted bounds remain
exactly **421 x 321**.

Only the three `font.*` rows change in the 291-row canonical comparison; all
288 non-Font rows remain structurally unchanged. Global classifications remain
141 genuine visual mismatches, 80 passes, and 70 Avalonia extensions. Native
control/glyph rasterization and action-row/tab-template edges remain measured
residuals.

A tracked provenance bundle now binds the three states and six host captures
to capture dimensions, painted bounds, exact canonical comparison rows, source
hashes, and the external capture-manifest identities. The WPF/Avalonia PNGs are
not committed, so pixel regeneration still requires the capture hosts; this is
an explicit limitation rather than an opaque freshness claim.

## FreeP

No runtime rendering change is retained. Fresh 27-deck, 53-slide evidence
confirms the current corpus averages and maxima: WPF/Office **1.0309%** average
and **3.0587%** maximum; Avalonia/Office **0.9962%** average and **2.5815%**
maximum; WPF/Avalonia **0.6097%** average and **2.9091%** maximum.

Deck 25's Surface3D residual is already on the bounded authored-camera path,
and the committed corpus supplies no second non-default mesh or blank-cell
topology that could validate a general camera/material correction. A second
IncreasingCircle probe regressed Avalonia/Office from **0.8675%** to
**0.8775%** and was reverted. Wave 192 therefore preserves the measured best
runtime and records the rejected probes, target images, heatmaps, and integrity
data instead of accepting a corpus-specific overlay.

## Focused Verification

- FreeX fill and font physical Linux lanes: **1/1** each; committed package
  semantics: **4/4**; physical source/evidence guards: **8/8**; focused Core IO
  color/save lane: **57/57**.
- FreeW planner/rasterization guards: **35/35** passed; Font visual and policy
  guards: **6/6** passed; Font provenance: **3** states and **6** host captures;
  canonical evidence consistency: **291/291** rows.
- One broader FreeW dialog-dedup source guard remains **12/13** because the
  unchanged `origin/main` expectation still requires an Autosave dialog
  composer string that the current Autosave adapter no longer contains. The
  failure is outside the Wave 192 Font change.
- FreeP full Avalonia renderer: **290/290**; presentation: **5,466/5,466**;
  comparison: **88/88**. The worker run reported **106/106** current-source
  renders; those complete render outputs are not retained.
- FreeP retained integrity proves **53** unique rows across **27** decks,
  **159** comparison metrics with recomputed aggregates, **53** mapped
  PowerPoint references, **9/9** evidence image hashes and dimensions, and
  actual WPF byte stability. It does not claim to retain all 106 render PNGs.
- Cross-app dashboard generation, freshness check, behavior guard, FreeW
  evidence consistency, and `git diff --check` pass.

## Integration Gates

A second independent review, repository preflight, the full Release solution
build, and the default non-UI test lane remain to run on the final integration
commit.

## Remaining

- FreeX: physical No Fill, color-filter change/clear sequencing, mixed-type
  columns, and multi-column color criteria.
- FreeW: native Font checkbox/glyph raster tail, action-row/tab-template edges,
  Legal Notices glyph/template tail, and the remaining classified Word/dialog
  visual residuals.
- FreeP: deck 25 Surface3D requires a genuinely new Office-authored topology
  before another general projection correction. The next executable
  existing-corpus target is deck 17 slide 02 at **2.5360%** Avalonia/Office and
  **2.9091%** WPF/Avalonia.
