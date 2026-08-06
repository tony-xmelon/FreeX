# FreeW native Table of Authorities ownership

Date: 2026-08-06

## Scope

FreeW already retained hidden native `TA` citation marks. Generated Table of Authorities category and
entry paragraphs now retain native spanning `TOA` ownership as well. Refresh recognizes imported native
owners and recovers category, passim, source-formatting, and tab-leader options before replacement.

## Word calibration

Live Word COM probes established these field mappings:

```text
Cases, default formatting:       TOA \h \c "1" \f
Statutes, passim, keep format:   TOA \h \c "2" \p
```

`\f` means do not retain source entry formatting, so its absence maps to
`KeepOriginalFormatting=true`. `\p` maps to passim. Tab leaders are result paragraph formatting and are
not encoded in the field instruction.

The important structural result is that Word's **All** category selection inserts one native `TOA` field
per used category. A speculative single `TOA \h \c "0" \f` field was rejected by Word on update with
`Error! Category number not found.` Product code therefore owns each category segment independently.

This matches the Word object model documentation for `TablesOfAuthorities.Add`: category zero is an
insertion instruction that creates the category tables; it is not a retained category-zero field code.

## Exact product-package gate

The exact FreeW-authored package had SHA-256:

```text
F466C02E6720A494904DFF752A8D0CE3243DB73E0569C3B0EF31CD820E44FB82
```

Word opened it as two `TablesOfAuthorities` objects plus two hidden `TA` marks:

```text
 TOA \h \c "1" \f
 TOA \h \c "2" \f
 TA \l "Brown v. Board" \c 1
 TA \l "17 U.S.C. 107" \c 2
```

Updating both category tables retained their rows:

```text
Cases | Brown v. Board<TAB>1
Statutes | 17 U.S.C. 107<TAB>1
```

The COM instance closed cleanly and left no `WINWORD` process.

## Verification

- Shared model TOA tests: 46/46.
- Presentation region-planner tests: 11/11.
- Package round-trip tests: 8/8.
- WPF native insert/update host tests: 2/2.
- Avalonia native insert/refresh host test: 1/1.

## Process rule

An insertion API's special aggregate option is not necessarily a serialized field value. Inspect the
resulting field collection and update the exact product package before choosing ownership boundaries.
For generated fields, source marks, owner fields, and imported refresh options must all agree.
