# Preserved Numbering In Table Cells

## Scope

Word numbering definitions can continue through ordinary body paragraphs and
table-cell paragraphs. FreeW previously retained those `numbering.xml` payloads
but only planned visible markers for top-level body blocks, leaving preserved
numbering inside a table cell unpainted.

`PreservedNumberingMarkerPlanner` now traverses the document in Word content
order, including table cells. WPF consumes the paragraph-keyed marker plan as a
non-editable leading run. Avalonia reserves its width and paints it through the
existing marker layer, without adding display text to the editable cell offset
stream.

## Verification

- Shared planner test: `4/4` passed, including `Section I.`, `Section II.` in
  a table, and `Section III.` after it.
- WPF marker/round-trip test lane: `14/14` passed. The table-cell marker is
  visible in the rendered document and the committed model cell remains
  `Inside`.
- Avalonia preserved-numbering control: `1/1` passed.
- WPF and Avalonia Release host builds completed with `0` warnings and `0`
  errors.
