# Avalonia Parity Wave 143: FreeW About

Date: 2026-08-04
Scope: FreeW About dialog, initial and populated Avalonia/WPF authority routes

## Audit

The shared About content, product text contract, automation IDs, modal action shape, and
keyboard lifecycle were already aligned:

- WPF uses `SharedAboutDialog` with `FreeWAppInfo.AboutText`.
- Avalonia uses `AvaloniaAboutDialog` with `FreeWProductInfo.CreateAboutText(..., "Avalonia")`.
- The two states do not mutate About content; `initial` and `populated` are intentionally the
  same dialog state.
- Both hosts focus `AboutFreeWText` on open and expose one `OK` action as both default and
  cancel. The harness reports no semantic difference.

The retained valid comparison identified the strongest structural gap: at the shared `560x600`
capture target, WPF painted content bounds `x=16,y=16,width=513,height=531`, while Avalonia
painted `x=16,y=16,width=515,height=531`. Both `about.initial` and `about.populated` had the
same `changedRatio` of `0.11534821428571429` and were valid `genuine-visual-mismatch` rows.
The extra width belongs to the Avalonia About root/action-row right edge, not to state-specific
text or focus.

## Change

The host-neutral `AboutDialogPresentation` carries the shared FreeW title, content, automation
IDs, help text, and Avalonia layout input to both host wrappers. `AboutDialogMetrics` now records
the FreeW-specific Avalonia right root margin as `RootMargin + 1` (17 DIP). `AvaloniaAboutDialog`
accepts an optional right-content-margin correction, and the FreeW Avalonia presentation supplies
that metric. The default constructor path remains unchanged for other Avalonia About consumers,
and WPF geometry/content were not changed.

The focused Avalonia authority test now also guards the read-only multiline host, top/left text
alignment, FreeW root margin, and existing default/cancel action contract.

## Fresh evidence

Fresh Avalonia captures were valid and content-gated:

| Scenario | Status | Content bounds | Content ratio | Focus | Default | Cancel |
| --- | --- | --- | ---: | --- | --- | --- |
| `about.initial` | captured | `16,16,513x531` | `0.0705267857` | `AboutFreeWText` | `OK` | `OK` |
| `about.populated` | captured | `16,16,513x531` | `0.0705267857` | `AboutFreeWText` | `OK` | `OK` |

The raw final Avalonia manifests were written under:

`C:\Users\anton\AppData\Local\Temp\FreeW-Wave143-about-final-avalonia-v2-a750e3e5923c4ef486336a3399526924`

Fresh WPF attempts for both routes were rejected by the existing content gate: RenderTargetBitmap
returned `0.00%` opaque pixels, `100.00%` near-black pixels, no color variation, and no painted
content bounds. Each harness command exited `2`. These frames are not visual authority and were
not compared, promoted, or substituted for the retained valid WPF evidence. No visual threshold
was loosened and this note does not claim blank evidence or pixel parity.

## Verification

- `dotnet build freew/tools/FreeW.DialogVisualHarness.Avalonia/FreeW.DialogVisualHarness.Avalonia.csproj -c Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` - passed, 0 warnings/errors.
- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj -c Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~WpfAuthoritySurfaceParityTests.About_uses_the_full_WPF_authority_content_and_modal_keyboard_shape" --logger "console;verbosity=minimal"` - passed, 1/1.
- `dotnet build freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj -c Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` - passed, 0 warnings/errors.
- `dotnet test freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj -c Release --no-build --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~FreeWHelpInfoTests" --logger "console;verbosity=minimal"` - passed, 9/9.
- `dotnet test freew/FreeW.App.Presentation.Tests/FreeW.App.Presentation.Tests.csproj -c Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~FreeWProductInfoTests" --logger "console;verbosity=minimal"` - passed, 3/3.
- The full `WpfAuthoritySurfaceParityTests` class was `12/13`; the unrelated existing Page Setup test still fails at its action-text walker because Avalonia template `AccessText` values are reported instead of `OK`/`Cancel`.
- Final Avalonia harness captures: `about.initial` 1/1 and `about.populated` 1/1, both content-gated.
- Final WPF harness captures: `about.initial` 0/1 and `about.populated` 0/1 valid because of the zero-pixel outage above.
