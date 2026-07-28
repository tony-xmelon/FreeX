# FreeW Avalonia Object Keyboard Parity Wave 43

Date: 2026-07-28

## Closed Functional Mismatch

When a floating image or other non-text drawing was selected, Avalonia allowed
`Enter` to fall through to the body editor and insert a paragraph break. WPF
keeps the floating object selected and does not mutate the document. Avalonia
now consumes `Enter` for non-text floating objects; selected text boxes retain
their existing `Enter` route into shape-text editing.

## Evidence

- Focused headless regression: selected-image `Enter` is handled and the body
  paragraph text is unchanged.
- The behavior is exercised through `DocumentView.OnKeyDown`, the same route
  used by the Avalonia editor surface.

## Residuals

Non-text floating objects do not open an object-specific dialog on `Enter`,
matching the current WPF authority route; object-specific commands remain on
their ribbon/context-menu paths.
