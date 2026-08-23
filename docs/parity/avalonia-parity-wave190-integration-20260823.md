# Avalonia Parity Wave 190 Integration

Date: 2026-08-23

Wave 190 processes one bounded slice per application and brings the cumulative
app-slice count to **570**. Generated command inventories continue to report
zero actionable Avalonia-missing commands across FreeX, FreeW, and FreeP. This
wave closes one physical Linux workflow blocker and makes two measured visual
improvements without changing WPF authority.

## FreeX

The production Linux X11 Date AutoFilter lane now passes **2/2**. Both Before
and After save/reopen cycles wait for the save boundary, require a newly opened
`Open Workbook` window with the FreeX process identity, and reopen through that
real dialog. After February 1 preserves `greaterThan=45323`, reads `Mar15` from
the first rendered grid slot, and independently reads semantic cell `A5` as
`Mar15`. Before February 1 remains `lessThan=45323` with `Jan01,Jan15`.

The initial follow-up was rejected during review because formula-bar state alone
did not prove the rendered grid and extra-window count alone did not prove the
dialog identity. The accepted lane requires both independent assertions and
uses the same bounded helper for both reopen cycles. A compact physical result,
window diagnostics, hashes, and two PNGs are committed under
`docs/parity/evidence/wave190-freex-autofilter-date-20260823/`.

## FreeW

The Avalonia Font dialog now uses WPF-measured vertical cadence while retaining
separate WPF metrics and leaving other compact dialogs unchanged. Across the
three canonical states, aggregate changed pixels improve from **57,620** to
**44,687**, a **22.4453%** relative reduction. Mean channel delta improves from
**9.513785** to **7.160465**, every state improves, and WPF/Avalonia painted
bounds remain exactly **421 x 321**.

The canonical route refresh changes only `font.initial`, `font.populated`, and
`font.validation-error`; all 288 non-Font rows remain structurally identical.
The report still classifies all three Font states as genuine mismatches and the
global accounting remains 141 mismatches, 80 passes, and 70 Avalonia extensions.

## FreeP

The imported `IncreasingCircleProcess` slide-09 Avalonia renderer applies a
measured text-origin correction only when the existing topology flag and the
exact resolved source signature both match. Font size, autofit, bullets, run or
body effects, spacing, geometry, non-Aptos, and mixed-font variants are negative
controls; visible strings, file names, and screenshot hashes are not consulted
at runtime.

Slide-09 Avalonia/Office improves from **1.5440%** to **0.8675%** and
WPF/Avalonia improves from **1.3657%** to **0.8540%**. WPF/Office remains
**0.9662%**. Neighboring SmartArt, deck-06 charts, deck-14 SmartArt, and deck-26
Surface3D controls are unchanged. Machine-readable metrics, hashes, the after
Avalonia PNG, and its Office diff are committed under
`docs/parity/avalonia-parity-wave190-freep-evidence-20260823/`.

## Focused Verification

- FreeX date source guards: 2/2 passed; production Linux X11 lane: 2/2 passed.
- FreeW planner/rasterization guards: 35/35 passed; Font and Legal Notices
  visual guards: 18/18 passed; canonical evidence consistency passed.
- FreeP exact-signature rendering guards: 17/17 passed; full Avalonia rendering
  suite: 288/288 passed; SmartArt/corpus presentation: 445/445 passed;
  RenderCompare evidence: 7/7 passed.
- Independent review findings were corrected before integration; the final
  follow-up review result is recorded before push.

## Integration Gates

- Cross-app dashboard generation/check, schema validation, FreeW evidence
  consistency, and whitespace validation passed.
- Repository preflight, full Release build, and the default non-UI lane run on
  the final integrated branch; exact results are recorded here before push.

## Remaining

- FreeX: physical AutoFilter color, mixed-type, multi-column, and criteria
  clear/reapply workflows.
- FreeW: the remaining Font native raster tail, Legal Notices glyph/template
  tail, then classified pagination, drawing/object, chart, table, and WordArt
  residuals.
- FreeP: the remaining imported SmartArt target residual or a genuinely new
  Surface3D/SmartArt topology with Office and control evidence.
