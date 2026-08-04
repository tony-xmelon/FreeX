# FreeW complete floating-table positioning UI

## Functional parity

The WPF and Avalonia Table Properties dialogs now expose the complete modeled Word floating-table position:

- horizontal and vertical anchors: text, margin, or page;
- horizontal modes: authored position, left, center, right, inside, or outside;
- vertical modes: authored position, inline, top, center, bottom, inside, or outside;
- signed horizontal and vertical offsets in points when Position is selected;
- top, left, bottom, and right distances from surrounding text;
- tri-state overlap preserving absent, explicit overlap, and explicit never-overlap states.

The positioning panel is enabled only for Around wrapping. Alignment modes disable their corresponding offset box, preventing an ambiguous UI edit while the package reader remains capable of retaining non-canonical source payloads containing both attributes.

## Validation and preservation

Offsets accept finite signed values. Text distances remain non-negative. Legacy command callers that do not supply positioning fields preserve the existing authored position; the two dialogs supply a complete replacement payload. Choosing None clears position and overlap through the existing model contract.

Focused planner and host tests round-trip an imported page/margin position with Outside alignment, a -18pt vertical offset, four distinct text distances, and explicit no-overlap through both dialog implementations.
