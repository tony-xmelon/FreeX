# FreeW WPF Table Border Pagination Clone

## Word contract

Print preview, printing, and live field pagination must retain the same table border surface as the editor.
Border rendering cannot prevent a bordered table from participating in physical page ownership.

## Previous gap

WPF table cells use a custom `FrameworkElement` to draw per-edge single, dashed, dotted, double, thick,
and wave borders. The element was a private nested type. `PrintLayout` deep-clones the editor
`FlowDocument` through `XamlWriter`, which rejects non-public element types. Any table routed through the
custom cell-border host could therefore fail pagination, print preview, printing, and page-aware field
updates with `Cannot serialize a non-public type`.

## Implementation

- Moved the chrome to a public top-level WPF element with a public parameterless constructor.
- Preserved the renderer-neutral edge plan in an invariant JSON token exposed to XAML serialization.
- The XAML-only token is hidden from normal API discovery and rejects malformed, incomplete, duplicate,
  non-finite, or otherwise invalid edge plans with a defined argument error.
- Rehydrates the exact edge/style/color/width plan on clone and keeps the existing drawing behavior for
  double, dashed, dotted, thick, and wave edges.
- Kept editor metadata stripping and restoration unchanged; only the visual element's clone contract moved.

## Verification

- The real repeated-header bordered-table fixture clones through `PrintLayout`; every source and cloned
  chrome has the same plan token in order, the table paginates to at least two pages, and both page visuals
  are available.
- The WPF Table of Authorities regression now places the table after an explicit page boundary and resolves
  direct/nested row citations on physical pages 2 and 3 as exact formatted labels `V, VI`.
- Existing PrintLayout and Mark Citation/TOA focused tests remain green.
