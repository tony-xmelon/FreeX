# Avalonia Parity Wave112: Ease Of Access

## Scope

- FreeX `dialog.Options.EaseOfAccess` against the WPF authority.
- Preserve normal `AppOptionsStore`-backed Options behavior; use `OptionsDialogParityFixture` only in parity capture routes.

## Evidence

- Baseline triage score: `0.097761`.
- Fresh paired WPF and Avalonia captures: `744x521` logical pixels at 96 DPI; both are nonblank and dimension-matched.
- Fresh triage score: `0.012617` (`87.1%` lower than baseline).
- Fresh normalized pixel comparison: `1.40%` changed pixels.
- Fresh WPF capture: `--parity-capture --parity-capture-target dialog.Options.EaseOfAccess`.
- Fresh Avalonia capture: self-contained Linux app in Ubuntu 24.04 Docker/Xvfb via `--parity-capture`.

## Delivered

- Added shared planner metrics for the WPF header rule, post-rule clearance, checkbox row height, and checkbox margin.
- Matched Avalonia Ease page spacing and header rhythm to the WPF XAML authority.
- Updated the existing compact checkbox template so disabled Ease controls retain WPF-like label contrast and use disabled fill, border, and check-mark colors.
- Added focused WPF/Avalonia source tests and enabled focused WPF capture selection for this tab.

## Remaining

- The remaining `1.40%` difference is platform text and control rasterization; no obvious Ease-of-Access layout or state gap remains in this surface.
