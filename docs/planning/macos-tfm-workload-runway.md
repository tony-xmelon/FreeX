# macOS TFM And Workload Runway

**Last updated:** 2026-06-08

<!-- Status correction 2026-08-08: Stage 3 below (the native AppKit share-sheet adapter) has
since landed -- src/FreeX.App.Avalonia/MacOs/MacOsWorkbookShareSheetService.cs exists and is
wired through WorkbookShareSheetServiceFactory/FREEX_MACOS_SHARE_SHEET as this doc describes
(commit 1310c9cb9a, "Add macOS share sheet host boundary"). The "Not implemented" release-note
guidance in Stage 0/Stage 4 below is stale for the adapter's existence; Stage 4's human-validation
requirement (interactive AppKit sheet completion on real hardware) still appears open. -->

<!-- VERIFY: whether a completed human macOS validation pass exists for the native share sheet
before calling native share-sheet parity fully promoted for public preview. -->

This note scopes the smallest staged path from the current hosted macOS app bundle to a native AppKit share-sheet adapter. The immediate goal is to keep the existing `net10.0` Avalonia app path stable while using an opt-in lane for macOS-specific AppKit bindings.

## Current Baseline

- `src/FreeX.App.Avalonia` targets plain `net10.0` by default and declares `RuntimeIdentifiers` for `osx-arm64` and `osx-x64`.
- When `EnableMacOsTargetFramework=true`, the app also targets `net10.0-macos` and compiles host-only native source from `src/FreeX.App.Avalonia/MacOs/`.
- The hosted `macOS App Preview` workflow publishes self-contained `.app` bundles for those RIDs, then validates bundle metadata, signing/notarization evidence, LaunchServices/Open-With/default-open smoke, checksums, diagnostics, and public-preview evidence wrappers.
- Plain `net10.0` plus `osx-*` RIDs is enough for the current Avalonia-hosted bundle and fallback share route. It is not the compile-time surface for AppKit bindings.
- AppKit bindings require an explicit macOS target framework, such as `net10.0-macos`, plus the matching macOS workload/reference pack on the machine or runner that compiles that target.
- `FreeX.App.Services` remains the portable decision and orchestration layer. It should keep targeting plain `net10.0` and should not acquire AppKit, WinRT, COM, WPF, or platform-launch references.

## Non-Goals For The First Lane

- Do not replace the current `net10.0` hosted app build as the default macOS artifact path.
- Do not require the macOS workload for normal Windows/Linux development, repository preflight, default solution build, or non-UI test runs.
- Do not move native share-sheet code into `FreeX.App.Services`.
- Do not claim native share-sheet parity from hosted runner evidence alone. The interactive sheet still needs real macOS validation.

## Smallest Staged Path

### Stage 0: Preserve The Current Hosted Path

Keep the existing `src/FreeX.App.Avalonia` `net10.0` build and `osx-arm64` / `osx-x64` publish lane unchanged until a separate opt-in lane proves that the macOS-specific target can coexist with it. The current release docs and human checklist should continue to record native share sheet as `Not implemented` for public-preview candidates.

### Stage 1: Add An Opt-In macOS TFM Build Lane

When source/workflow work is allowed, add a separate macOS-only build path that compiles the Avalonia host with `net10.0-macos` and installs/restores the macOS workload/reference pack on the runner. Keep it opt-in at first, for example behind a workflow input, matrix include, or explicit MSBuild property, so the default `dotnet build FreeX.slnx` and current hosted packaging path stay stable.

The lane should prove only these early facts:

- the selected runner image has the required .NET SDK, macOS workload, and reference pack;
- the macOS TFM build restores and compiles without changing portable project TFMs;
- `FreeX.App.Services` and `Core.*` still build as plain `net10.0`;
- the existing `net10.0` hosted bundle still publishes for both `osx-arm64` and `osx-x64`;
- workload failures are reported as lane readiness failures, not product regressions in the current hosted app path.

When `validate_macos_tfm=true` is enabled, a maintainer can manually dispatch the `macos-tfm-build` job from the hosted macOS workflow as a compile-validation companion. Treat that run as evidence-only:

- it runs on the hosted macOS 26 arm64 and Intel images so the compile evidence matches the current .NET macOS workload/Xcode runway;
- it installs the pinned macOS workload set on hosted macOS before compiling `net10.0-macos`;
- it records toolchain, workload, native source-boundary, compile-item, and compile evidence in `freex-<run-id>-<run-attempt>-macos-tfm-build-<arch>-evidence`;
- it does not produce, sign, notarize, staple, publish, or promote a `FreeX.app` artifact;
- it does not replace the current `net10.0` plus `osx-arm64` / `osx-x64` RID bundle lane;
- it cannot prove native AppKit share-sheet runtime behavior, menu focus, VoiceOver interaction, or share-target completion.

A green opt-in compile lane means the hosted macOS SDK/workload surface is ready for later host-boundary work. A red workload install/restore step means the lane is not ready and should be fixed in the opt-in lane before any product conclusion is drawn. A red `net10.0-macos` compile step means the macOS target or host-only source needs attention, while the current hosted `net10.0` artifact lane remains the release source of truth unless its own jobs fail.

### Stage 2: Keep The Host Boundary Compile-Gated

The first native host boundary is `src/FreeX.App.Avalonia/MacOs/`. Files in that folder are removed from every non-`net10.0-macos` target and compiled only by the opt-in macOS TFM lane. Acceptable future shapes remain:

- conditional host files compiled only when `$(TargetFramework)` is `net10.0-macos`; or
- a thin macOS host/adapter project that targets `net10.0-macos` and depends on the portable services without reversing that dependency.

Either shape must keep the share decision in `WorkbookShareActionPlanner` and keep platform execution in the Avalonia/macOS host. Source guards should continue to fail if AppKit appears outside the macOS host boundary, or if WinRT, COM, WPF, or Windows-only APIs appear in `FreeX.App.Services` or the Avalonia host.

### Stage 3: Add The Native Share-Sheet Adapter

The initial adapter lives in `src/FreeX.App.Avalonia/MacOs/MacOsWorkbookShareSheetService.cs`. It presents the native AppKit share sheet for a saved local workbook path and is selected through `WorkbookShareSheetServiceFactory` only when `FREEX_MACOS_SHARE_SHEET` is defined by the `net10.0-macos` target. The adapter should execute only `ShareSheet` plans from `WorkbookShareActionPlanner`; dirty-save, Save As, missing-path, invalid-path, cloud/web-link, fallback, and deferred decisions stay in the portable planner and existing Avalonia share route.

The fallback contract remains required:

- saved local workbook plus available AppKit adapter: show native share sheet;
- saved local workbook plus unavailable/unsupported adapter: reveal/open the containing folder where supported;
- unsaved, missing, invalid, cloud, or web-link path: route through Save As before any native action;
- canceled share sheet: leave workbook contents, saved path, dirty state, and saved bytes unchanged.

### Stage 4: Promote Only After Human Validation

Hosted macOS runners can prove compile, bundle, menu route, saved-path preconditions, fallback evidence, signing/notarization, and LaunchServices smoke. They cannot prove that a person can complete the interactive AppKit share sheet.

Promotion to native share-sheet parity requires a real macOS validation pass for each runtime in scope:

- saved workbook opens the native share sheet;
- Cancel is non-destructive;
- at least one local share target receives the expected workbook file;
- fallback reveal/open-containing-folder still works when the native adapter is unavailable or unsupported;
- keyboard focus enters and returns from the sheet predictably;
- VoiceOver identifies the share action, sheet, target controls, and cancellation/completion state.

## Release And Verification Gates

Keep the gates ordered so failures do not destabilize the current app path:

1. Repository preflight and default build remain green without the macOS workload.
2. Current hosted `net10.0` app artifacts keep passing both `osx-arm64` and `osx-x64` evidence preflight.
3. The opt-in `net10.0-macos` lane compiles on hosted macOS with explicit toolchain evidence.
4. Source hygiene confirms AppKit stays out of `FreeX.App.Services`.
5. Native adapter route/fallback smoke passes in hosted evidence without claiming interactive completion.
6. Runtime-specific human macOS checklist rows for native share sheet pass before public-preview notes claim native share-sheet support.

If any `net10.0-macos` workload or reference-pack step fails, keep the release note scoped to the current fallback path and leave native share-sheet readiness as `Not implemented`.
