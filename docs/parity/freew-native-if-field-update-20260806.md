# FreeW Native IF Field Update Parity

## Scope

FreeW retained native Word `IF` complex fields and their cached result, but both desktop
hosts skipped them during F9 / Update Field because `ComplexFieldEngine` did not own
the field family.

## Change

The shared field engine now recomputes bounded native `IF` expressions with:

- Word's `=`, `<>`, `>`, `<`, `>=`, and `<=` operators;
- invariant numeric comparison before case-insensitive text comparison;
- `*` and `?` wildcards in the second operand for equality and inequality;
- quoted multi-word true/false results and an omitted false result;
- trailing `\* MERGEFORMAT` and `\* CHARFORMAT` retention markers;
- unquoted bookmark operands resolved from the current document text.

Malformed instructions and nested-field expressions keep their imported cached result.
This avoids pretending that FreeW can evaluate a nested field tree that is not represented
by the current single-run field model.

Microsoft's [IF field reference](https://support.microsoft.com/en-us/word/field-codes-if-field)
defines these six operators, wildcard behavior, operand forms, and optional false text.

## Evidence

- Model tests cover every operator family, numeric and text comparison, case-insensitive
  wildcards, bookmark resolution, omitted false text, and cached-result controls.
- DOCX round-trip coverage proves the native instruction survives save/reopen and responds
  to updated bookmark text.
- Because both WPF and Avalonia already route F9 through `ComplexFieldEngine`, the shared
  capability activates the same field-update path in both hosts.

## Process Rule

Only claim field-update ownership for expression forms represented by the model. Preserve
the cached Word result for nested or malformed expressions until nested field structure is
available to the evaluator.
