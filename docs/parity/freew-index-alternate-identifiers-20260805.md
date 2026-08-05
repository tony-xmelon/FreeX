# FreeW alternate index identifier parity

## Scope

Word uses matching `\f "Identifier"` switches on XE and INDEX fields to build multiple selective indexes
from one document. The unswitched/default entry type is `I`.

FreeW now:

- preserves `IndexMark.Identifier` as exact XE `\f` package semantics;
- treats unswitched XE marks and explicit `\f "I"` marks as the default index;
- filters alternate identifiers case-insensitively without leaking default, legacy, or other-type entries;
- gives every alternate generated region deterministic identifier-specific heading and entry style IDs;
- preserves those styles through DOCX save/reopen; and
- exposes identifier-aware `InsertIndex(string?)` and `RefreshIndex(string?)` in both WPF and Avalonia.

Default and alternate indexes can coexist. Refreshing one identifier removes and rebuilds only that
identifier's generated region; the default and other alternate regions remain semantically unchanged.

The existing parameterless `InsertIndex()` and `RefreshIndex()` routes continue to target default type `I`.
Ribbon authoring for choosing a non-default identifier remains a separate Insert Index dialog slice; imported
documents and host/API callers already receive the package, filtering, coexistence, and update behavior.

## Verification

- `DocumentIndexTests`: 23/23.
- `ComplexFieldRoundTripTests`: 20/20.
- WPF index editor contracts: 6/6, including no-build rerun.
- Avalonia complete `ReferencesTabTests`: 74/74.

The package tests assert exact `XE "Alpha" \f "People"` serialization, reopened identifier filtering, and
round-trip retention of the generated `People` region's distinct style IDs. Host tests insert default and
`People` indexes together, then refresh `People` while retaining the default region.

## Remaining index scope

The user-facing Insert Index options dialog and layout controls remain the next functional index slice.
