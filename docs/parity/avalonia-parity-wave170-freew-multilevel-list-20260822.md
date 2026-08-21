# FreeW Multilevel List Visual Parity Wave 170

Scope: the `multilevel-list.initial`, `multilevel-list.populated`, and
`multilevel-list.validation-error` dialog states.

## Change

Avalonia now inherits `AvaloniaCompactDialogChrome.WindowsStyle` for the
dialog's shared 24-DIP controls and 26-DIP action buttons. The previous route
overrides (18-DIP text boxes, 22-DIP combo boxes, and 20-DIP buttons) caused
the reported vertical deficit. The route keeps only its WPF-specific combo
palette, uses a measured 9-DIP terminal action margin, and no longer adds the
stale one-pixel client-width compensation. The WPF route and shared planner
behavior are unchanged.

## Controlled A/B

The WPF authority was captured once at 96 DPI with a capture-only DPI
normalization while the host desktop was at 150%. The before binary was built
from clean `81d8f989d1`; the after binary was built from this worktree. Both
Avalonia binaries ran in the same `freex-linux-interactive:ubuntu24.04`
container, with the same inventory and WPF manifest.

| State | Before changed | Before mean delta | Before pHash | After changed | After mean delta | After pHash |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| initial | 35.7529% | 16.2336 | 27 | 16.8222% | 12.0897 | 7 |
| populated | 35.7529% | 16.2336 | 27 | 16.8222% | 12.0897 | 7 |
| validation-error | 35.9229% | 16.3794 | 27 | 17.0196% | 12.2551 | 7 |

All three Docker captures were nonblank and captured successfully. Semantic
comparison reported no route difference. The final local headless capture
also realizes the supplied target Avalonia content bounds:
`x=14,y=18,width=338,height=357`.

## Verification

- `MultilevelListDialogVisualParityTests`: 3 passed.
- Docker Avalonia captures: 3/3 before and 3/3 after.
- Focused comparison: 3/3 paired rows captured; genuine visual residuals are
  retained rather than hidden by threshold or crop changes.

## Remaining residuals

The remaining ~16.8-17.0% Docker pixel delta is concentrated in Linux font
rasterization and Avalonia/Fluent control-template chrome. Docker content
bounds remain approximately one pixel higher and nine pixels shorter than the
normalized WPF authority (`WPF 336x354@14,17`, Avalonia `338x345@14,16`).
These are visual residuals only; list choices, default/cancel semantics,
validation focus behavior, and planner mutations remain covered by the
existing shared contracts and focused tests.
