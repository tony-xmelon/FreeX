# Funnel and Waterfall Insert Commands

FreeP already had shared chart models, editable data, OOXML read/write, and WPF/Avalonia rendering for Funnel and Waterfall charts. This slice closes the authoring reachability gap: both chart types now appear in the shared Insert Chart command catalog, the common ribbon, localization resources, and both host command paths.

The commands use the existing `EditingSession.InsertChart` path, so insertion remains undoable and receives the same chart defaults as programmatic creation. No renderer or chart serialization behavior changed.

Verification covers shared planner application, Avalonia command execution, WPF ribbon completeness, and localization resource completeness.
