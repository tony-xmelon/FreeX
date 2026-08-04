# WPF raster infrastructure audit - Wave 141

Date: 2026-08-04

## Result

No product source change is accepted in this slice. The WPF raster outage is below the
repository capture helpers and remains unsafe to bypass: a fresh process returns a fully
transparent bitmap for every tested WPF route.

## New root-cause evidence

- Host: Windows `10.0.26200.0`, WPF render tier `0`, `.NET 10.0.9`.
- A standalone `DrawingVisual` rendered with the repository's supported
  `RenderTargetBitmap(..., PixelFormats.Pbgra32)` returned `alpha=0`, `nonBlack=0`, and
  `red=0` for a `64x64` solid-red probe.
- The same probe remained `alpha=0`, `nonBlack=0`, and `red=0` with process software mode,
  a WPF `Application`, a shown WPF `Window`, an attached `HwndSource`, and a composition
  target forced to software mode.
- The repository's existing native owned-HWND route returned `PrintWindowOk=True`, but its
  `144x144` bitmap still had `printWindowAlpha=0` and `printWindowNonBlack=0` for both a
  visible `Window` and an `HwndSource`.
- Running the same standalone probe under installed `.NET 10.0.8` with roll-forward disabled
  produced the same zero-pixel result. The failure is therefore not specific to the 10.0.9
  servicing patch.
- `Bgr32` is unsupported by `RenderTargetBitmap` on this runtime; `Pbgra32` remains the
  repository-supported format. Changing formats is not a viable workaround.

## Verification

- `freew/FreeW.App.Host.Tests` focused `FidelityRenderCompositeTests`: 4 structural tests
  passed and 6 pixel-content tests failed because the returned WPF bitmap was blank.
- `freew/tools/FreeW.FidelityRender` `--auto-software-fallback` independently detected the
  same missing opaque pixels and selected its existing software evidence renderer.
- No transparent PNG was promoted as WPF authority, and no capture gate was weakened.

The next valid remediation requires a healthy WPF compositor/display session or an upstream
runtime/OS fix. The existing software evidence renderer can provide nonblank evidence, but it
cannot be represented as WPF raster proof.
