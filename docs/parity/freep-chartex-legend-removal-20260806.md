# FreeP ChartEx Legend Removal

## Scope

Native ChartEx legend edits already update a preserved `cx:legend` payload when a
position is present. The empty-legend path returned early, so clearing a legend in
the shared chart options workflow left the old native legend in the saved part.

## Fix

The ChartEx writer now removes the preserved `cx:legend` element when the model
legend is empty. Other preserved chart children remain untouched.

## Verification

- `ChartDataCommandTests`: 88/88 compiling and `--no-build`
- WPF Release consumer: 0 warnings, 0 errors
- Avalonia Release consumer: 0 warnings, 0 errors
- New package contract asserts native legend removal while an unrelated preserved
  extension survives.

This is a functional/package parity slice; no raster comparison was used.
