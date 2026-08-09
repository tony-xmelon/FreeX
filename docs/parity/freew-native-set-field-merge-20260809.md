# FreeW Native SET Field Merge Parity

## Scope

FreeW evaluated its own textual `Set Bookmark Value` merge rule, but imported native
Word `SET` complex fields remained stale during Finish & Merge. A following native
`REF` therefore could not consume the assigned value.

## Change

The rules-aware merge path now:

- parses literal quoted, numeric, percentage, and empty `SET` values;
- accepts trailing `\* MERGEFORMAT` and `\* CHARFORMAT` retention markers;
- stores the value in the merge bookmark state and emits no visible SET result;
- resolves a following native `REF` from that state;
- applies the REF field's date, numeric, and general result switches.

Nested field values remain preserved with their cached result because the current
single-run complex-field model does not retain a nested field tree that can be evaluated
reliably.

Microsoft's [SET field reference](https://support.microsoft.com/en-us/word/field-codes-set-field)
defines SET as an invisible bookmark assignment and shows REF as the display owner,
including numeric-picture formatting on referenced values.

## Evidence

- Model parser contracts cover quoted, numeric, percentage, empty, retention-marker,
  malformed, and nested-field forms.
- Rules-aware merge coverage proves invisible assignment plus numeric and uppercase REF
  output, while an unsupported nested SET remains intact.
- DOCX round-trip coverage proves native SET/REF instructions survive save/reopen and
  resolve through the same merge state.

## Process Rule

Separate variable ownership from display ownership: SET stores the literal and paints
nothing; REF owns visible result formatting. Preserve nested source until nested field
structure is available rather than flattening it into a guessed literal.
