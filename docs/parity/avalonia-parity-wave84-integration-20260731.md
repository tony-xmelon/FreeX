# Avalonia parity wave 84 integration - 2026-07-31

## Integrated slices

- FreeX formula point-mode selection preserves its directional active anchor for reverse keyboard, mouse, and 3-D range extension instead of normalizing to the range top-left.
- FreeW Avalonia PDF export emits already-laid-out table fills and borders below cell text, clipped to the owning page without introducing a second paginator.
- FreeP Avalonia Zoom double-click navigation terminates gesture processing after selecting the target slide, matching WPF instead of falling through into ordinary selection/move handling.
- Shared Avalonia Medium and Small split buttons expose separate primary and dropdown targets, fixed dropdown metrics, and keytip-reachable menus matching the WPF contract.
- FreeP whole-window visual evidence retained its inventory and outcomes while refreshing the shared Avalonia ribbon renderer source hash.

## Verification

- New focused integration tests passed: FreeX Avalonia 2/2, FreeX services 1/1, FreeX WPF 1/1, FreeW PDF 3/3, FreeP Avalonia 1/1, FreeP WPF 1/1, shared Avalonia ribbon 4/4, and shared WPF ribbon 5/5.
- The complete ribbon UI lane passed 30/30.
- Linux physical interaction evidence passed 85/85: FreeX 24/24, FreeW 37/37, and FreeP 24/24. All three manifest contracts passed.
- Repository preflight passed across 124 projects, 89 main-solution entries, and 20 default-test entries.
- `dotnet build FreeX.slnx --configuration Release` passed with 0 warnings and 0 errors.
- The raw default lane reported 34,552 passed, 30 failed, and 133 skipped. One unrelated clipboard-isolated paste-cache test failed with a transient null reference under the all-up run and passed 1/1 immediately in isolation. The remaining 29 failures exactly match the existing current-host WPF off-screen bitmap cluster: 26 FreeX print/render assertions and 3 FreeP host-rendering assertions. All Avalonia projects passed.

## Residual status

Wave 84 closes four additional functional-depth slices. The overall Avalonia-to-WPF parity goal remains active. FreeW PDF export still needs inline images, floating objects, drawings/charts, decorations, watermarks, page borders, and line numbers. FreeW also retains 170 genuine visual comparison mismatches, while FreeX and FreeP require continued workflow-depth and authoritative Office-baseline review beyond their complete generated command-route coverage.
