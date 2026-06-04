# Custom Number Escaped Directive Fidelity Plan

## Tasks

- [x] Identify escaped `_` and `*` custom-format literals being consumed by layout-directive cleanup.
- [x] Add focused formatter tests for escaped layout characters in numeric, date/time, and elapsed-time formats.
- [x] Preserve backslash escapes before removing unescaped spacing/fill directives.
- [x] Document the architecture and command-parity decision.
- [x] Run focused verification before commit.

## Decisions

- `RemoveSpacingAndFillDirectives` preserves backslash-escaped characters before interpreting `_` and `*` as layout-only directives.
- Existing downstream renderers continue to decide how to emit backslash escapes for numeric, date/time, elapsed-time, and text sections.
- Exact Excel fill-width expansion remains out of scope; this change only preserves literal escaped directive characters.
