# LCID Date Name Fidelity

## Goal

Improve custom number format locale fidelity so Excel LCID tokens such as `[$-0407]` use localized day and month names for date/time output, not only localized separators.

## Steps

1. Add a regression test for a German LCID date format that requires localized day/month names.
2. Verify it fails with invariant English names.
3. Update locale format creation to start from the .NET culture when an LCID maps cleanly, while preserving the existing catalog separator/group-size overrides.
4. Update Commands parity and architecture docs for this custom number format decision.
5. Run focused formatter tests and a full build, then commit and sync.
