# Custom number escaped fill width

## Goal

Prevent width-aware accounting/fill expansion from treating escaped `*` layout characters as active Excel fill directives.

## Scope

- Add a failing formatter test for a literal escaped asterisk rendered with a target column width.
- Update the accounting-layout directive detector to skip escaped characters, matching the later fill parser.
- Update architecture and command parity documentation.
- Verify the focused formatter test, the NumberFormatter suite, and the solution build before commit.

## Out of scope

- Full Excel accounting pixel-width layout.
- Renderer-level alignment changes.
