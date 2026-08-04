# Wave 149: Shared Backstage Rail Contract

The paired FreeW visual data pointed at Backstage as a high-change surface, but the cause was not established by the ratio alone. Inspection found a concrete shared-renderer divergence: WPF's rail navigation buttons used `22,9` padding and a `16,11` back-button padding, while Avalonia used `16,10` and `16,13`; icon sizes and navigation font sizing were also duplicated in renderer code. The different hit rectangles changed both the visible rail rhythm and the keyboard-target geometry.

`BackstageVisualContract.Frame` now owns the rail's navigation padding, back-button padding, font sizes, icon sizes, icon/label gap, and top-navigation margin. The WPF resource dictionary keeps only native template behavior, while WPF code and Avalonia code consume the same neutral values. Focused Avalonia headless coverage verifies the realized controls and pane-selection/Escape behavior; this is structural/interaction evidence, not a pixel-parity claim.

The remaining boundary is native control-template and font rasterization behavior: WPF and Avalonia still realize their own buttons, scrolling, focus visuals, and text rendering. Authoritative visual comparison remains separate evidence work.
