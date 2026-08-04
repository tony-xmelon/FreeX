# FreeW Avalonia floating-table placement

## Scope

Avalonia now consumes the complete renderer-neutral floating-table position plan for single-page tables. Page, margin, and text anchors support authored point offsets plus left, center, right, inside, outside, inline, top, and bottom alignment specifications.

## Rendering contract

- The shared planner converts all source point values to stable DIPs and retains nullable source semantics and overlap state.
- The Avalonia table renderer applies one resolved X/Y transform to cell surfaces, borders, hit targets, and glyph geometry together.
- Positive downward placement extends the flow reservation so following content cannot collide with the moved table.
- Inline tables remain on the existing geometry path.
- Multi-page tables retain the existing pagination path until floating pagination semantics are modeled explicitly.

## Verification

The focused host contract compares an inline table with an otherwise identical text-anchored table. Authored offsets of 36pt X and 24pt Y produce exact 48-DIP and 32-DIP shifts while preserving table width and height. Shared planner contracts cover page/margin alignment and signed text-relative offsets.
