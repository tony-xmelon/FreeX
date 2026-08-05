# FreeP ChartEx Title Removal

## Scope

Native ChartEx title editing already updates the preserved `cx:title` payload when
text is present. The empty-title path returned early, so clearing a title in the
shared chart options workflow left the old native title in the saved ChartEx part.

## Fix

The ChartEx writer now removes the preserved `cx:title` element when the model title
is empty. Other preserved chart children remain untouched.

## Verification

- `ChartDataCommandTests`: 87/87 compiling and `--no-build`
- WPF Release consumer: 0 warnings, 0 errors
- Avalonia Release consumer: 0 warnings, 0 errors
- New package contract asserts the native title is removed while an unrelated
  preserved extension survives.

This is a functional/package parity slice; no raster comparison was used.
