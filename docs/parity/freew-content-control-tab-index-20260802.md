# FreeW content-control `w:tabIndex` parity (2026-08-02)

## Scope

FreeW now preserves the optional generic `w:sdtPr/w:tabIndex/@w:val` in shared
`ContentControlWordMetadata.TabIndex`. `null` means the source element or attribute was absent; a
non-null string retains the exact authored token without numeric parsing or lexical normalization.
The same metadata path covers inline `ContentControl` and body-level `BlockContentControl` owners.

## Lifecycle evidence

- The reader recovers distinct block (`0007`) and inline (`-0002`) source tokens.
- The first save emits each token on its original owner, reopen restores both model values, and the
  second save is XML-stable.
- A separate fixture proves absent values remain absent through the same two-save lifecycle.
- Open XML SDK 3.1.1 omits legacy `w:tabIndex` from both Microsoft 365 `w:sdtPr` particles. The schema
  assertion therefore requires exactly those two owner-local diagnostics and no others; the absent
  fixture validates with zero schema errors.

## Verification

- `ContentControlTabIndexModelTests`: 2/2 passed.
- `ContentControlTabIndexRoundTripTests`: 2/2 passed.
- Full `FreeW.Core.Model.Tests`: 1,579/1,579 passed.
- Full `FreeW.Core.IO.Tests`: 1,220/1,220 passed.
