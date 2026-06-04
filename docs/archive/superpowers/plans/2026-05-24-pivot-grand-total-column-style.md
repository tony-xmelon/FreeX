# PivotStyle grand total column styling

## Goal

Apply PivotStyle grand-total visual styling to matrix PivotTable row-grand-total columns, not just grand-total rows.

## Scope

- Add a failing model test proving body cells under the matrix `Grand Total` column do not receive grand-total fill.
- Track grand-total columns from the PivotTable header band during style application.
- Apply grand-total style to body cells in those columns while leaving header-band styling precedence intact.
- Update architecture and command parity documentation.
- Verify focused PivotTable style tests and the full solution build before commit.

## Out of scope

- Full Excel PivotStyle theme XML semantics.
- Native slicer/timeline drawing fidelity.
- Compact-layout merge behavior.
