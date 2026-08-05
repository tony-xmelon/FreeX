# FreeP Avalonia Inline Cell Format Routing - 2026-08-05

## Function slice

When an Avalonia inline table-cell editor was active, cell-owned table commands
could bypass the pending child rich-text edit and mutate the parent table first.
The inline bridge now commits the child text transaction before routing these
shared undoable cell commands:

- text direction;
- cell fill, vertical anchor, border, and inset;
- active row height.

With no inline editor active, the existing direct `EditingSession` routes remain
unchanged. The shared model still owns both transactions, so undo first removes
the cell property change and then the committed child-text edit.

## Verification

- Avalonia host route: focused inline-cell commit/style test passed `1/1`.
- Avalonia host table command lane passed `11/11`.
- Avalonia inline-table renderer tests passed `7/7`.
- Avalonia Release build passed with `0` warnings and `0` errors.

This is a functional editing slice; it makes no visual calibration claim.
