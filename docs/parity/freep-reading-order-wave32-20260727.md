# FreeP Reading Order Pane Wave32 - 2026-07-27

## Scope

This slice aligns the Avalonia Reading Order pane to the unchanged WPF authority. The change is intentionally Avalonia-only because the WPF implementation and pixels are already the reference.

## Accepted Variant

- Avalonia reserves a 16 px right inset for the WPF-equivalent vertical scrollbar gutter.
- Avalonia Reading Order move buttons use a 27 px minimum height, matching the measured WPF button band.
- Existing card spacing remains `Spacing = 2`; removing it compressed the cards and regressed the target.
- Existing 320 px pane width and 12/10/10 card literals remain unchanged.
- Compensation values are local constants in `FreeP.App.Avalonia/MainWindow.cs`; no pseudo-shared visual abstraction was added.

## Evidence

The checked-in target was 18.60% changed pixels with mean channel delta 15.40. A fresh paired capture at equal 1280x760 shell size and 96 DPI produced:

| Surface | Changed pixels | Mean channel delta | Result |
| --- | ---: | ---: | --- |
| `review.reading-order-pane.seeded` | 17.18% | 13.33 | improved |

The fresh target dimensions matched at 320x578. WPF and Avalonia capture semantics, focus, button order, enabled state, and nonblank checks all passed for the surface. The full paired run captured 28/28 scenarios; unrelated shell-context differences remain outside this focused slice.

The rejected intermediate variant, which kept the gutter but removed card spacing, measured 20.00% changed pixels / mean 17.06 and is not part of the accepted change.

Fresh local evidence: `artifacts/parity-wave32-reading-order-gutter-spacing-button/`.

## Verification

- Avalonia test project Release build: 0 warnings, 0 errors.
- `ReadingOrderPaneVisualParitySourceTests`: 3/3 passed.
- `git diff --check`: passed.
- `freep/FreeP.App.Host/MainWindow.cs` matches `origin/main` byte-for-byte.
