# FreeX Options Save Wave 26

Date: 2026-07-27

## Scope

Aligned the Avalonia `dialog.Options.Save` page with the current WPF `OptionsDialog`:

- WPF-matched section margins and zero panel row spacing.
- Shared Options planner widths for the 230 px label column and 200 px format field.
- Stretching recent-files location into the available `*` column instead of clipping a 280 px minimum field.
- Shared Avalonia compact dialog chrome remains the control styling source.
- Added a focused WPF parity-capture selector for `dialog.Options.Save`.

## Evidence

Both captures came from the current branch at the canonical 744x521 client frame:

- WPF: `FreeX.App.Host --parity-capture ... --parity-capture-target dialog.Options.Save`
- Avalonia: self-contained `linux-x64` publish, Ubuntu 24.04 Docker, direct Xvfb `:99`, `--parity-capture-surface dialog.Options.Save`

The paired PNGs and manifests are promoted under `docs/parity/dialog-visual-assets/` with fresh-source provenance.

| Metric | Before | After | Change |
| --- | ---: | ---: | ---: |
| `dialog.Options.Save` triage score | 0.105011 | 0.021855 | -79.2% |
| Logical dimensions | 744x521 | 744x521 | matched |
| Nonblank evidence | yes | yes | preserved |

## Residuals

The recent-files path text is platform-specific (`C:\Users\...` in WPF versus the Linux profile path in Avalonia), and toolkit text/control rasterization remains. WPF reports a 95.9866 DPI capture versus Avalonia's 96 DPI; the logical frame remains within the established tolerance.
