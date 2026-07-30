# FreeW Avalonia parity wave 65: nested grouped-child text direction

Wave 65 closes the remaining grouped-child text-direction path loss in FreeW.

## Implementation

- `SetShapeTextDirectionCommand` now accepts the same optional root-relative `ChildPath` used by
  the Wave 64 shape-text commands and resolves the leaf through `ShapeTextTargetResolver` for both
  apply and undo.
- WPF and Avalonia `SetSelectedShapeTextDirection` routes now recognize a selected nested shape,
  keep the owning drawing group as the active selection, and pass the complete child path to the
  shared command. Direct shape behavior remains unchanged.
- Managed tests cover Horizontal, Rotate 90, and Rotate 270, undo/redo, sibling isolation, and
  preservation of leaf/group rotation and flip transforms. The WPF route also writes and reopens a
  DOCX and verifies the nested direction and transforms.
- `run-freew-wave64-nested-text-probe.sh` keeps its Wave 64 default unchanged and adds the opt-in
  `FREEW_WAVE64_SELECTOR=nested-text-direction` route. That selector invokes the production Drawing
  Format > Text Direction dropdown through X11; its fixed-harness coordinates can be overridden by
  `FREEW_TEXT_DIRECTION_X/Y` and `FREEW_TEXT_DIRECTION_ITEM_X/Y`.

## Verification target

- Core/model nested command tests.
- WPF host nested selection, undo/redo, and DOCX round-trip tests.
- Avalonia headless nested selection, command route, undo/redo, and transform-preservation tests.
- Optional Linux/X11 evidence with the Wave 65 selector and a uniquely named output directory.

## Next residual

Shape paragraph alignment remains a separate paragraph-level operation in both hosts and is not
included in this bounded resolver change. It should receive its own path-aware contract and paired
physical evidence if grouped-child paragraph alignment remains an observed parity gap.
