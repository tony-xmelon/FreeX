# PDF Language Normalization

## Goal

Polish PDF publish metadata by normalizing the export dialog's PDF language option into stable culture tag casing before writing `/Lang`.

## Steps

1. Add a regression test for underscore/case normalization in PDF language input.
2. Verify it fails with the current trim-only implementation.
3. Normalize known .NET culture tags via `CultureInfo`, replacing underscores with hyphens, and default invalid tags to `en-US`.
4. Update architecture and command parity docs for the language normalization rule.
5. Run focused export planner tests and a full build, then commit and sync.
