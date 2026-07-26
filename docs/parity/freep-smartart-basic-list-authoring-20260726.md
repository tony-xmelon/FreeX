# FreeP SmartArt Basic List Authoring

FreeP now exposes PowerPoint's native `list1` Basic List layout in both WPF and Avalonia.

The command uses the existing shared list-family live layout engine, so changing a selected
SmartArt graphic to Basic List updates the native diagram layout part, regenerates the live
boxes, remains undoable through the shared editing session, and survives PPTX round-trip.

The reader already admitted `list1` to the live layout path; this slice closes the missing
authoring and host-routing surface without changing cached fallback behavior for other layouts.
