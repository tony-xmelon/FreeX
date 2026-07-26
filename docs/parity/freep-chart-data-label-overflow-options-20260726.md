# FreeP chart data-label overflow option

FreeP's shared chart display-options workflow now exposes the modeled
`c:showDLblsOverMax` setting as a tri-state option: automatic (`null`),
enabled, or disabled. The WPF and Avalonia dialogs use the same planner,
and the existing chart-options command applies the value with undo support.

The value was already preserved by the PPTX reader and writer; this slice
makes it user-editable without changing the default/omitted semantics.

Validation on the isolated functional branch:

- Presentation planner and command round-trip: 2/2.
- Avalonia dialog commit: 1/1.
- WPF host dialog contracts: 2/2.
- Release builds of the three affected test projects: clean.
