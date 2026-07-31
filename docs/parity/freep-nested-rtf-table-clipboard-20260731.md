# FreeP nested RTF-table clipboard parity

## Scope

Word-style RTF nesting uses `itap` depth with `nestcell` and `nestrow` boundaries. The parser
now captures that bounded structure as a recursive `U+FFFC` inline-table run rather than
flattening nested cells into the existing tab projection.

## Behavior

- Flat RTF tables keep the existing tab/paragraph projection and formatting behavior.
- Payloads containing actual nesting preserve the outer table, nested rows/cells, cell text,
  common cell styles, and surrounding text.
- The existing shared clipboard codec round-trips the recursive table body.
- WPF and Avalonia consume the same `InlineTableInfo` model and existing host paths.

## Verification

- Presentation Release build: 0 warnings, 0 errors.
- Full Presentation suite: `3173/3173`.
- New recursive RTF parser/codec test: passed.

## Boundary

Advanced RTF table layout, malformed providers that omit nesting-depth controls, and richer
Word table semantics remain deferred. The existing flat-table behavior is intentionally kept
unchanged for non-nested RTF payloads.
