# Avalonia FreeX Grid AutoFit parity, Wave166

## Scope

This slice closes the strict Linux Docker physical grid AutoFit selector for the
production Avalonia FreeX desktop at `1280x820`, `96 DPI`. The existing Wave165
product behavior remains authoritative: a four-pixel header movement threshold
preserves manual resize drag, and a sub-threshold collapsed-boundary click reaches
the contiguous hidden-row AutoFit path for rows `4:5`.

## Harness diagnosis and fix

Wave165 retained artifacts showed genuine hidden-row growth (`66,66`) and unhide,
but ordinary column and visible-row double-clicks could read back unchanged sizes.
The probe helper was named `xdotool_mousemove_sync`, bounded its invocation with
`timeout`, but called asynchronous `xdotool mousemove`; the following click could
therefore be delivered before the pointer reached the calibrated header coordinate.

Wave166 keeps the existing timeout and click threshold and changes only that helper
to use `xdotool mousemove --sync`. No selector count, schema, threshold, expected
growth, calibration, or postcondition was relaxed. A deterministic services test
pins the delivery wait and timeout contract.

## Current-source reproduction before the fix

The first genuine current-source run used the dedicated Release Linux publish and
owned Docker image `sha256:5480c8741284a8de2697a828cdd321545432a3f1b1262ae1469ecc0244d4e24a`,
at `1280x820`, `96 DPI`. Session:
`artifacts/linux-interactive/freex/sessions/20260806T044343209Z`.

It unexpectedly completed the strict selector with `3 passed, 0 failed`:

- column `70 -> 396`,
- visible row `26 -> 66`,
- hidden rows `4:5`: `0,0 -> 66,66`, `hiddenRowsAfter=[]`, `unhidden=true`, `sized=true`.

The retained screenshots show the calibrated selection geometry and the reopened
wrapped hidden-row cells. This is diagnostic evidence only; final Wave166 credit
requires the authoritative post-fix validation result below.

## Post-fix bounded attempt ledger

Attempt 1 after the first helper change used report
`artifacts/linux-interactive/freex/interaction-validation/20260806T044702Z` and
session `artifacts/linux-interactive/freex/sessions/20260806T044731479Z`.
Calibration passed, visible row and hidden-row proofs passed, but the column
postcondition was `70 -> 0` and the after capture showed the whole A column
selected. The runner stopped its owned container and exited 1. This artifact
confirmed that move synchronization alone did not separate the settled header
hit target from the dependent double-click.

Attempt 2 after separating the move and chained click used report
`artifacts/linux-interactive/freex/interaction-validation/20260806T045210Z` and
session `artifacts/linux-interactive/freex/sessions/20260806T045327103Z`.
Calibration passed and the strict selector returned `3 passed, 0 failed`:

- column `70 -> 396`,
- visible row `26 -> 66`,
- hidden rows `4:5`: `0,0 -> 66,66`, `hiddenRowsAfter=[]`, `unhidden=true`,
  `sized=true`.

## Final authoritative result

Commit `32dd9f5ce215b66c2b968773a413be63a69fb184` is the source provenance for
the final run. Report:
`artifacts/linux-interactive/freex/interaction-validation/20260806T045515Z`.
Physical session:
`artifacts/linux-interactive/freex/sessions/20260806T045915621Z`.
The owned app image was
`sha256:66b2b8d5edeaeb0b02e03cf4a6af2a58d69d16447d332e252ed8bdb2277a1920`.

The authoritative strict selector returned `3 passed, 0 failed, 3 total` with
calibration passed at `1280x820`, `96 DPI`:

- column `70 -> 396`, boundary `88,226`;
- visible row `26 -> 66`, boundary `14,272`;
- hidden rows `4:5`: `0,0 -> 66,66`, boundary `14,292`,
  `hiddenRowsAfter=[]`, `unhidden=true`, `sized=true`.

Three calibrated post-implementation attempts were used: attempt 1 exposed the
whole-column-selection race, attempt 2 passed before commit, and attempt 3 is the
SHA-linked final result above. The deterministic pointer-helper regression passed
`1/1`; the full `FreeX.App.Services.Tests` lane passed `2625/2625`. No selector,
schema, threshold, expected-growth, calibration, or postcondition residual remains
in this Wave166 slice. Broader Linux interaction surfaces remain outside this
focused selector's scope.
