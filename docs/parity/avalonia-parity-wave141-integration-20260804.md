# Avalonia/WPF parity wave 141 integration

Date: 2026-08-04

## Scope

Wave 141 advanced one evidence-backed desktop-host parity residual in each application and deepened the WPF raster-outage audit:

- FreeX: aligned the Insert Hyperlink link-type selection state with WPF when the address editor owns focus.
- FreeW: moved Building Blocks Organizer display, sizing, preview, status, and action-state behavior into a shared presentation contract consumed by both hosts.
- FreeP: aligned Zoom validation to the WPF modal-warning workflow and shared all validation messages.
- Infrastructure: tested WPF rasterization across managed and native paths, two .NET servicing versions, software mode, visible windows, and attached HWND sources.

## Results

- FreeX's fresh Linux Insert Hyperlink capture remained exact `560x300`, nonblank, and exited normally. The retained comparison improved from `3.7252%` to `3.089469%`; remaining differences are Linux font/antialiasing and minor native control chrome.
- FreeW Avalonia Building Blocks Organizer now uses the WPF-authority `660` DIP width, shared list/preview sizing and labels, metadata-aware list items, description/body preview text, empty/removal status, and disabled action state when empty. Fresh Avalonia content bounds moved from `530x260` to `532x316` against retained WPF `518x339`. Fresh WPF output was blank and rejected.
- FreeP Avalonia Zoom validation no longer uses an inline host-only error label. Both hosts now present the same shared validation messages through their modal warning surface.
- Generated coverage remains complete for its declared inputs: FreeX 57/57 dialog routes and 94/94 paired screenshot ids, FreeW 940 command rows with zero actionable platform gaps, and FreeP 648/648 shared command rows.

## Verification

- Focused owning tests passed `88/88`: FreeX `9`, FreeW `6`, and FreeP `73`.
- Repository preflight passed, including every generated-document freshness check.
- `dotnet build FreeX.slnx --configuration Release` passed with zero warnings and zero errors.
- The default non-UI lane discovered 36,487 tests: 36,353 executed, 36,323 passed, 30 failed, and 134 were skipped. All 30 failures are the established WPF zero-pixel set: 26 FreeX printed-grid tests and four FreeP WPF canvas/rich-text tests.
- FreeX's complete Avalonia suite passed `2026/2026` in the default lane.

## Evidence boundaries

The WPF raster audit reproduced fully transparent output from a solid-red `DrawingVisual`, visible WPF windows, attached `HwndSource` instances, software rendering, and native `PrintWindow`. The same result occurred on .NET `10.0.8` and `10.0.9`; `PrintWindow` returned success but still delivered zero alpha/nonblack pixels. No source workaround or transparent image was accepted. Current-source WPF visual authority still requires a healthy WPF compositor/display session or an upstream runtime/OS remediation.
