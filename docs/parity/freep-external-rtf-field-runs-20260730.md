# FreeP external RTF field-run preservation

Date: 2026-07-30

## Scope

External RTF paste previously preserved only guarded `HYPERLINK` behavior. Other
field results were flattened into ordinary text even though FreeP already has a
renderer-neutral `FieldRun` model and PPTX field serialization.

The bounded parser now retains the first non-hyperlink RTF field token and its
cached result text in `FieldRun`. Existing hyperlink URI validation is unchanged:
unsafe targets and remote file hosts remain ordinary, non-link result text.
Field run font family, size, weight, and color also survive the PPTX writer/reader
boundary.

## Evidence

- `ExternalRichTextClipboardTests`: 20 tests passed, including parser and
  clipboard JSON round-trip for a `PAGE` field.
- `MediaFieldsTests`: 28 tests passed, including PPTX write/reopen preservation
  of field font and color.
- Existing `HYPERLINK` tests remain covered by the same focused suites.

## Boundary

This preserves field identity and cached results; it does not invent Word field
calculation semantics for fields PowerPoint cannot evaluate. `HYPERLINK` remains
on the dedicated guarded hyperlink route, and unsupported/malformed field
instructions still degrade safely to their visible result text.
