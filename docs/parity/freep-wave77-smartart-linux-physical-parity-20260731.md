# FreeP Wave 77 SmartArt Linux Physical Parity

## Audit checkpoint

The advanced SmartArt audit found no managed WPF-over-Avalonia behavioral or visual gap to close. WPF and Avalonia both expose the existing SmartArt layout, quick style, color, text-pane outline, data-part, drawing-cache, undo, and package-refresh paths. Avalonia host tests cover the corresponding command registrations and undo bus, while shared planner tests cover the native package mutation.

The un-covered boundary was physical Linux interaction with the existing WPF-authoritative SmartArt text-pane workflow. This slice adds evidence for that boundary; it does not add a new authoring capability to either host.

## Closed evidence gap

The dedicated runner uses the existing `14-smartart-live.pptx` corpus fixture, whose first slide contains a native process SmartArt data part with the exact outline `Plan`, `Design`, `Build`, `Test`, `Deploy`. A FreeP-only physical-validation seed selects that imported SmartArt and opens the existing text pane. The probe then performs real X11 input against the visible `Add sibling` action and proves:

1. The pane's first row is physically visible and reads back exactly as `Plan` through `xclip`.
2. `Add sibling` creates the native `New node` row in the visible outline while retaining the cached SmartArt drawing path.
3. Physical `Ctrl+S` writes the updated native package, whose `data1.xml` order is exactly `Plan`, `Design`, `New node`, `Build`, `Test`, `Deploy`.
4. A second fresh FreeP process reopens a copied saved package, and the pane's third row reads back exactly as `New node` through `xclip`.

The combined manifest is `artifacts/freep-smartart-authoring/freep/smartart-authoring/results.json` when the lane is run. The source corpus hash is checked before and after the two sessions.

## Evidence boundary

This is physical Avalonia/X11 evidence for an existing WPF workflow, not a PowerPoint COM visual baseline. It covers the hierarchy model/package path through the visible outline add-sibling operation, native save, and a fresh-process reopen. Managed command tests cover undo/redo; the Linux probe does not claim those transitions because the current physical Edit dropdown did not produce a stable observable transition in this lane. It also does not establish exact WPF-versus-Avalonia pixels, text-pane Apply-button reachability, assistant/picture authoring, every SmartArt layout/style/color gallery choice, or PowerPoint-authoritative rendering. The fixed-width pane's lower Apply controls remain outside this probe because the current layout clips them; claiming text replacement here would be false.

Run with:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Run-FreePSmartArtAuthoringValidation.ps1
```
