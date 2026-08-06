# Avalonia FreeW Cross Reference parity, Wave165

## Scope

This slice aligns the Avalonia Cross Reference dialog with the WPF/shared authority. The shared
`CrossReferenceDialogPlanner`, `CrossReferences.PlanInsertion`, and the newly merged bookmark-based
footnote/endnote reference behavior remain unchanged. The Avalonia dialog now uses the WPF control
types and interaction contract:

- Reference type: `ListBox` `150x170`.
- Insert reference to: `ListBox` `180x170`.
- Target list: `ListBox` `300x200`.
- WPF-matching panel, label, hyperlink, target, and action spacing.
- Focus starts on the reference-type list; OK remains default and Cancel remains cancel.
- Missing targets use the modal Avalonia warning service, matching WPF's `DialogMessageHelper` path;
  the non-authoritative inline red status row was removed.
- The compact checkbox, list-row, unfocused-selection, and neutral default-button chrome are
  app-owned render adjustments. No shared thresholds, fixtures, crops, masks, or acceptance probes
  were changed.

## Fresh evidence

Evidence was captured from synchronized source `118458c9c5` at `560x600`, `96x96 DPI`, using the
route-only inventory and the WPF authority capture. `initial`, `populated`, and `validation-error`
are identical for this route because the current WPF harness fixture has no editable Cross Reference
fields and does not fabricate an acceptance warning. All six final captures passed full and target
pixel-content gates.

| State | Fresh WPF/Avalonia comparison | Changed pixels | Changed ratio | Mean channel delta |
| --- | --- | ---: | ---: | ---: |
| initial | captured/captured | 20,731 / 336,000 | 6.1699405% | 4.8313780 |
| populated | captured/captured | 20,731 / 336,000 | 6.1699405% | 4.8313780 |
| validation-error | captured/captured | 20,731 / 336,000 | 6.1699405% | 4.8313780 |

The final result is non-regressing against the proven gate of `6.1705357%` and `4.8861181` in all
three states. The comparer still reports `genuine-visual-mismatch` because the remaining difference
is above its existing classification threshold; it reports no semantic difference.

## Attempt ledger

| Attempt | Result |
| --- | --- |
| Current-source baseline | 31,937 / 336,000 (`9.5050595%`), mean `5.7631349`, all three states |
| ListBox/layout/state correction | 25,681 / 336,000 (`7.6431547%`), mean `5.6106399` |
| Compact checkbox, focus, neutral default, row-height correction | 20,733 / 336,000 (`6.1705357%`), mean `4.8861181` |
| Final unfocused-selection and post-open neutral-button tweak | 20,731 / 336,000 (`6.1699405%`), mean `4.8313780` |

An earlier pre-sync capture command timed out before the branch was synchronized and its output was
discarded. It did not contribute evidence or changes. A first WPF host test invocation also reached
the foreground timeout while restoring/building; its retry completed successfully after the build
artifacts were available.

## Verification

- Focused `CrossReferenceDialogParityTests`: 3/3 passed.
- Shared model Cross Reference filter: 52/52 passed, including bookmark and note-reference planning.
- WPF host Cross Reference filter: 10/10 passed (the editor subset was also 6/6).
- Core IO Cross Reference filter: 10/10 passed.
- Avalonia dialog harness Release build: passed, 0 warnings, 0 errors.
- Fresh WPF route capture: 3/3 captured.
- Fresh Avalonia route capture: 3/3 captured.
- Route-only comparer: all three pairs captured/captured with valid content; expected visual-mismatch
  exit classification, semantic difference `null`.

## Remaining residual

The remaining non-semantic pixels are native-host rendering differences: WPF and Avalonia paint
different list scrollbar/template edges, text rasterization, and compact control borders even after
the app-owned geometry and state corrections. This is the remaining native-only visual residual; no
further threshold or probe relaxation is accepted for this slice.
