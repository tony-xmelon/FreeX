# FreeP chart layout-target authoring

FreeP chart manual-layout editing now exposes the PowerPoint layout-target semantics as a controlled choice in both WPF and Avalonia: Automatic (outer), Inner, and Outer. The shared planner continues to store the serialized token, so an unrecognized imported value is shown as an `Imported (...)` choice and survives an edit/save round trip instead of being silently discarded.

This slice is functional parity only. It does not claim a raster-fidelity change. The planner contract, WPF dialog workflow, and Avalonia dialog workflow are covered by focused tests; existing chart command undo and serialization tests remain the behavioral gates for commit/reload behavior.
