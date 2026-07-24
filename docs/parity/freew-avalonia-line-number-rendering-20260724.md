# Avalonia Line-Number Rendering

## Scope

Avalonia exposed the page-level line-number commands and paragraph-level
suppressLineNumbers setting but did not draw margin numbers in Print Layout.

## Resolution

LineNumberVisualPlanner now owns the Word sequence rules for physical body
lines: startAt, countBy, continuous versus per-page restart, and suppression
without removing a line from the sequence. Avalonia maps its existing paginated
glyph rows into that planner and paints visible entries in each column's left
gutter. Table cells are intentionally outside this initial body-line scope.

The existing WPF adorner now also honors startAt and applies countBy relative
to it, keeping the host implementations aligned with the serialized
w:lnNumType contract.

## Verification

- LineNumberVisualPlannerTests: 2/2
- DocumentViewLineNumberRenderTests: 1/1
