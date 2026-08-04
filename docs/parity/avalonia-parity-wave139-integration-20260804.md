# Avalonia/WPF parity wave 139 integration

Date: 2026-08-04

## Scope

Wave 139 advanced one bounded parity residual in each application:

- FreeX: moved Change Chart Type picker geometry into the shared presentation contract and consumed it from both WPF and Avalonia.
- FreeW: aligned the Avalonia Legal Notices content registration with the retained WPF authority.
- FreeP: added shared Zoom transition enable/disable authoring, validation, native persistence, undo, and reopen behavior to both desktop hosts.

## Results

- FreeX keeps all 94 dialog surfaces paired, nonblank, and size-valid. The fresh Avalonia Change Chart Type capture is exact `640x390` and shows the current populated subtype gallery. Its retained WPF authority has an obsolete empty-gallery state, so the raw triage score change from `0.069584` to `0.084227` is recorded but is not treated as a product regression or an optimization target.
- FreeW Legal Notices Avalonia content bounds changed from `y=20,height=527` to `y=19,height=528`, matching WPF's vertical registration across the four target tabs. All 288 Avalonia route scenarios passed their content gate. The fresh WPF run remained zero-pixel and was not promoted.
- FreeP now authors the existing native Zoom `transitionDur` property through an explicit shared toggle, positive whole-millisecond validation, a `1000 ms` default, and the existing undoable shared command route. Command coverage remains `648/648` with 110 workflow evidence rows because this is depth on the existing Zoom Format command.
- The stale FreeP command-inventory generator now owns the recently merged inherited TTML begin/end/dur boundary evidence instead of erasing it during regeneration.

## Verification

- Repository preflight passed, including every generated-document freshness check.
- `dotnet build FreeX.slnx --configuration Release` passed with zero warnings and zero errors.
- Focused owning tests passed `314/314`: FreeX `193`, FreeW `55`, and FreeP `66`.
- FreeX's complete Avalonia suite passed `2025/2025` in the default lane.
- Dialog evidence remains 94/94 paired with zero nonblank, logical-size, or expected-size failures; FreeP whole-window evidence remains 33/33 paired with zero explicit product mismatches.

## Evidence boundaries

The default non-UI lane completed 36,464 tests and reported the same 30 Windows WPF raster failures documented in Wave 138: 26 FreeX printed-grid tests and four FreeP WPF canvas/rich-text tests. Serial probes returned `blackInRow1 = 0` for FreeX and `0x00` sampled channels for FreeP. These are the existing host raster outage, not failures in the Wave 139 source paths; no blank capture or zero-pixel result was promoted as authority.

Current-source WPF recapture remains the principal visual-evidence infrastructure residual. Broader FreeP PowerPoint-native Zoom styling/effects and COM-backed baselines also remain outside this bounded slice.
