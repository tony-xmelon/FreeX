# FreeW Insert Index identifier dialog parity

## Scope

FreeW's model, DOCX package layer, and both editors already support selective indexes through the XE/INDEX
identifier. This slice makes that capability available from References > Insert Index instead of always
building the default index.

The shared dialog planner owns identifier normalization:

- blank input maps to the default index (`null`, equivalent to Word's default `I` type); and
- non-blank input is trimmed and passed to `InsertIndex(string?)`.

WPF now opens an owner-modal Insert Index dialog directly from its ribbon command. Avalonia uses its existing
owner-modal host callback pattern, retaining the default insertion fallback for callback-free registry tests
and embedders. Cancel leaves the document unchanged.

## Verification

- Shared `InsertIndexDialogPlannerTests`: 5/5.
- WPF `InsertIndexDialogTests`: 2/2.
- WPF References/Index registry contract: 1/1.
- Avalonia complete `ReferencesTabTests`: 78/78.
- WPF and Avalonia Release host builds: 0 warnings, 0 errors.
- Adjacent index model/package gates continue to cover default and alternate filtering, exact XE `\f`
  serialization, save/reopen, and selective refresh.

The Avalonia registry test authors default, `People`, and `Places` entries, chooses `People`, and proves that
only the `People` generated region is inserted. A separate fallback test proves callback-free insertion still
builds only the default index.

## Remaining index scope

Update Index still targets the default region from the ribbon. Durable Word `INDEX` field ownership and the
rest of Word's index layout choices (columns, right-aligned page numbers, tab leader, formats, language) remain
separate functional/package slices.
