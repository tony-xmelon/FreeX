# UX Parity S3 Export/Native Edge Checkpoint - 2026-06-11

Branch/worktree:

- Branch: `codex/ux-parity-s3-export-native-edge-20260611`
- Worktree: `E:\Users\anton\Documents\Claude\FreeX\.worktrees\ux-parity-s3-export-native-edge-20260611`
- Base: local `main` at `347b45a7ed5d11d12c6f51c50d89cbe4622adc14`

## Scope

This checkpoint is harness-only. It adds foreground-capture scenario entry points for the remaining S3 export/native edge cases, but it does not claim any new retained foreground evidence.

Implemented but not run in this checkpoint:

- `freex-export-overwrite-prompt`
- `freex-export-xps-accept`
- `freex-native-print-dialog`

## Blocker

The session was stopped before scenario execution. No new `tools/foreground-captures/*` artifacts or manifests were retained, and no S3 catalog rows should be treated as closed by this checkpoint.

Open S3 items remain:

- FreeX export overwrite prompt proof.
- Explicit XPS native save-path acceptance/output proof.
- Native Windows PrintDialog foreground proof.
- FreeX Save As invalid-path proof.
- Background replacement/clear continuation.
- Excel Save As common `#32770` Browse/Save continuation, still avoided here because prior evidence routes through Office `NUIDialog`.

## Verification

- `dotnet build tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release` passed with 0 warnings and 0 errors.
- `dotnet build src\FreeX.App.Host\FreeX.App.Host.csproj --configuration Release` returned a nonzero result without visible diagnostics in the live console.
- `dotnet build src\FreeX.App.Host\FreeX.App.Host.csproj --configuration Release --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 -v:minimal` passed with 0 warnings and 0 errors when output was captured to a temporary ignored log.

## Integration Rerun

After integration, the new S3 foreground scenarios were run from the main integration worktree.

Closed with retained foreground evidence:

- `freex-background-picker-replace`: complete. Retained `tools/foreground-captures/freex-background-picker-replace/freex-background-picker-replace_20260611_004352.png`, continuation screenshot, and manifest. The validation records selecting a replacement worksheet background path and returning focus to FreeX.
- `freex-background-clear`: complete. Retained `tools/foreground-captures/freex-background-clear/freex-background-clear_20260611_004432.png` and manifest. The validation records selecting a PNG worksheet background and invoking Delete Background.

Still blocked with retained manifests:

- `freex-save-as-invalid-path`: no native invalid-path prompt was detected after typing a missing-directory `.xlsx` path.
- `freex-export-overwrite-prompt`: no native export overwrite confirmation prompt was detected after typing an existing PDF path.
- `freex-export-xps-accept`: explicit `.xps` path was accepted, but the PDF/XPS options dialog was not detected.
- `freex-native-print-dialog`: Print Preview's Print button was clicked, but no native Windows Print dialog was detected.

## Second Integration Rerun

The later S3 evidence worker reran the remaining native export prompts with the foreground harness pointed at the already-built main integration Release host executable.

Closed with retained foreground evidence:

- `freex-save-as-invalid-path`: complete. Retained `tools/foreground-captures/freex-save-as-invalid-path/freex-save-as-invalid-path_20260611_023505.png` and manifest. The harness detects the native invalid-path prompt after typing a missing-directory `.xlsx` path.
- `freex-export-overwrite-prompt`: complete. Retained `tools/foreground-captures/freex-export-overwrite-prompt/freex-export-overwrite-prompt_20260611_023756.png` and manifest. The harness detects the native overwrite confirmation prompt after targeting an existing PDF export path.

Still blocked with retained manifests:

- `freex-export-xps-accept`: explicit `.xps` path was accepted, but the PDF/XPS options dialog was not detected.
- `freex-native-print-dialog`: Print Preview's Print button was clicked, but no native Windows Print dialog was detected.
- `excel-save-as-dialog`: the Office `NUIDialog` path still does not expose the native common Save As dialog continuation expected for a `#32770` Browse/Save proof.

The open S3 list is therefore reduced to explicit XPS options detection, native Windows PrintDialog detection, and the Excel Save As common `#32770` Browse/Save continuation that remains blocked by the Office `NUIDialog` state.

## S3 Blocker Harness Hardening

Branch/worktree:

- Branch: `codex/s3-native-export-blockers-20260611`
- Worktree: `E:\Users\anton\Documents\Claude\FreeX\.worktrees\s3-native-export-blockers-20260611`
- Base: local `main` at `e72bc96ecac325c99a4b29b6cb270e139a833b6d`

This pass is non-GUI only. It does not launch foreground FreeX or Excel, does not add or replace retained foreground evidence, and does not close any S3 row until the scenarios are rerun with the desktop slot released.

Harness changes made for the three remaining blockers:

- `freex-export-xps-accept`: the post-SaveFileDialog detector now accepts the actual WPF `Export Options` window title in addition to older `PDF/XPS`/publish title variants. The prior blocker text said "PDF/XPS options dialog," but the app's export options window is titled `Export Options`.
- `freex-native-print-dialog`: the Print Preview Print command now uses a foreground-verified physical click instead of `InvokePattern.Invoke`, then waits through the normal popup timeout for a native `#32770` Print dialog. This avoids blocking or returning too early around the modal WinForms print dialog handoff.
- `excel-save-as-dialog`: when Excel exposes an Office `NUIDialog`, the harness now makes a bounded attempt to invoke visible `Browse`, `More options`, `Save As`, `This PC`, or `Computer` continuation targets and then waits for a native `#32770` `Save As` dialog. If Office still does not expose that common dialog, the scenario remains blocked with `nuidialog-common-save-as-continuation-not-found`.

Verification:

- `dotnet build tools\FreeX.ForegroundCapture\FreeX.ForegroundCapture.csproj --configuration Release` passed with 0 warnings and 0 errors.
