# Avalonia parity Wave 182: FreeX Name Box physical dropdown

Date: 2026-08-22
Branch: `codex/parity-wave182-20260822`

## Scope

This slice investigates the Linux Docker/X11 Name Box dropdown failure from Wave 181. The
cross-app dashboard and Wave 182 integration document are intentionally unchanged.

## Diagnosis and product change

The four 208x136 X11 entries were not four logical Name Box popups. Avalonia's windowed Popup
path exposes the popup root and its GL render child as separate X11 windows, which made window
count an unreliable identity signal. The production popup also focused its ListBox immediately,
before the popup host had attached and completed layout.

FreeX now routes this shell-owned transient surface through Avalonia's in-window overlay layer on
Linux and focuses the ListBox from the popup `Opened` event at input priority. Production evidence
records the popup host and screen bounds at open time. The physical probes consume that production
identity and crop the declared 208x136 surface without resizing. Native X11 inventory identity is
still required when the production host is native; overlay evidence is accepted only when the
production event explicitly reports `overlay-layer`.

Normal Name Box data, keyboard navigation, pointer selection, and object-selection code paths are
unchanged. No threshold was relaxed and no harness-only popup was introduced.

## Evidence

Wave 181 baseline:

- `name-box-dropdown`: 0/8; four 208x136 native X11 windows; popup content blank; no
  `object-selected` events.
- `name-box-dropdown-parity`: 0/1; the native-window identity contract could not distinguish the
  popup root/render child set.

Wave 182 patched parity run on port 6095 recorded one production event:

```text
popupHost=overlay-layer popupX=64 popupY=214 popupWidth=208 popupHeight=136
```

The X11 inventory no longer gained a popup window, as expected for the overlay host. The root crop
was exactly 208x136 and unscaled, but its content remained blank, so the authoritative parity
surface stayed `captured=false` and the selector remained 0/1.

The final object selector run on port 6099 recorded the same overlay identity repeatedly while the
probe attempted each row. It produced 0/4 object postconditions, `defined-name-passed=false`,
`table-passed=false`, and no `object-selected` event. The overall physical selector therefore
remained 0/8.

## Verification

- `dotnet build src/FreeX.App.Avalonia/FreeX.App.Avalonia.csproj -c Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` — passed, 0 warnings, 0 errors.
- `dotnet test tests/FreeX.App.Avalonia.Tests/FreeX.App.Avalonia.Tests.csproj -c Release --no-restore --filter FullyQualifiedName~AvaloniaMainWindowNameBoxStage2Tests --logger "console;verbosity=minimal" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1` — passed, 16/16.
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Run-FreeXLinuxInteractionValidation.ps1 -Port 6095 -TimeoutMinutes 10 -PhysicalOnly -PhysicalProbeSelector name-box-dropdown-parity` — ran to completion, failed the authoritative crop contract, 0/1.
- `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Run-FreeXLinuxInteractionValidation.ps1 -Port 6099 -TimeoutMinutes 10 -PhysicalOnly -PhysicalProbeSelector name-box-dropdown -SkipImageBuild` — ran to completion, failed the exact object postcondition, 0/8.

The focused host source-contract command could not execute in isolation because the repository's
WPF batch project propagates `IsTestProject` into shared project references; the forced batch build
then fails on 48 pre-existing missing shared-test helper/attribute symbols. The direct canonical
host project invocation is a no-op under its batch-wrapper properties. No test-architecture files
were changed.

## Remaining blocker

The remaining failure is in Avalonia Linux popup child rendering/input routing: the production
overlay frame and its recorded geometry are visible, but ListBox content is not rasterized into the
X11 root crop and pointer/keyboard attempts do not reach a selectable row. The correct next step
is to isolate that Avalonia overlay/GL child rendering path (or replace the popup content with a
normal shell-owned visual surface) and rerun both selectors. This slice lands only the independently
correct host-identity, focus-order, and production-evidence changes; it does not claim 8/8 while the
physical content and selection evidence remain absent.
