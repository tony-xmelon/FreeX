# FreeW index identifier authoring parity

## Scope

Word allows an XE field to select an alternate index with the `\f "Identifier"` switch. FreeW already
preserved and resolved that package semantic; this slice exposes it in the Mark Index Entry dialog in both
WPF and Avalonia.

Both dialogs now:

- show an optional **Index identifier** field after the subentry field;
- initialize the field from the renderer-neutral dialog state;
- trim the entered identifier through the shared planner; and
- retain the existing default-index behavior when the field is empty.

The produced `IndexMark.Identifier` flows through the existing exact XE `\f` writer and selective index
builder. Current-page, bookmark-range, cross-reference, bold, and italic options remain independently
modeled by the same shared planner.

## Verification

- Shared `MarkIndexEntryDialogPlannerTests`: 11/11.
- WPF `MarkIndexEntryDialogTests`: 9/9.
- Avalonia focused Mark Index Entry dialog tests: 6/6.
- Adjacent model and package gates cover exact XE serialization, reopen, selective filtering, and distinct
  generated index regions.

The focused host tests assert both whitespace-trimmed `People` authoring and unchanged empty/default
identifier behavior.

## Remaining index scope

Insert Index still invokes the default index directly from the ribbon. A separate options-dialog slice should
expose the identifier at insertion/refresh time and can then add Word's layout choices without coupling them
to XE authoring.
