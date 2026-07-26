# FreeP SmartArt Basic Timeline

FreeP now exposes a function-first `Basic Timeline` SmartArt layout in the shared authoring planner.

- The WPF and Avalonia command registries dispatch `freep.smartart.layout.basic-timeline`.
- Applying the layout updates the live `SmartArtData` and the native DrawingML layout part using PowerPoint's `basicTimeline` layout identifier, so the edit survives save and reopen.
- The shared live layout emits a horizontal timeline rail, alternating above/below text boxes, node markers, and vertical stems. This is deterministic shared geometry for editing and rendering; it is not a claim of pixel-identical PowerPoint artwork.
- Focused planner, package round-trip, host command-registration, and layout-engine tests cover the route.
