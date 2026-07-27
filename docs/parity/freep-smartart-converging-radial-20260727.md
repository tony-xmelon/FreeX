# FreeP SmartArt Converging Radial Function Parity

FreeP now admits the native SmartArt `convergingRadial` Relationship layout as
a bounded live layout in both WPF and Avalonia. The shared planner supports
three or four nodes and emits inward-facing compass arrows using ordinary
editable slide-shape operations. The reader, insertion factory, authoring
planner, WPF ribbon, Avalonia command registry, localization, and parity tests
all use the same native layout identifier:

`urn:microsoft.com/office/officeart/2005/8/layout/convergingRadial`

The node-count bound is intentional. Packages outside that bound retain the
existing cached drawing fallback until their geometry is modeled. This slice
establishes functional live editing and cross-host regeneration; it does not
claim pixel-identical PowerPoint geometry, effects, or text placement.
