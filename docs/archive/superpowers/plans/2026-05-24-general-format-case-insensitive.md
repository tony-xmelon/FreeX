# General Format Case Insensitivity

## Goal

Match Excel custom number format behavior by treating `General` format codes case-insensitively at the formatter boundary and inside numeric sections.

## Steps

1. Add regression tests for lowercase/uppercase `General` format codes.
2. Verify they fail through the current case-sensitive checks.
3. Update `NumberFormatter` to compare `General` with ordinal-ignore-case semantics.
4. Update architecture/command parity docs for this small format-code fidelity rule.
5. Run focused formatter tests and a full build, then commit and sync.
