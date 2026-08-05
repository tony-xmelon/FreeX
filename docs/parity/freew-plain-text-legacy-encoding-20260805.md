# FreeW plain-text legacy encoding parity

## Gap

FreeW honored Unicode byte-order marks but decoded every bomless plain-text file with permissive
UTF-8. Legacy Windows text containing bytes such as `0xE9`, `0x80`, or `0x93` therefore opened with
replacement characters instead of the accented letters, euro sign, and smart punctuation Word users
expect from Western Windows text.

## Change

`PlainTextFileAdapter` now applies a bounded authority order:

1. UTF-8, UTF-16, and UTF-32 BOMs select their declared Unicode encoding.
2. Bomless input is decoded as strict UTF-8 when the complete byte sequence is valid.
3. Only invalid bomless UTF-8 falls back to Windows-1252.

This preserves modern UTF-8 without guessing from character frequency while recovering the common
Word-era Western Windows text path. The adapter still leaves its caller-owned stream open and keeps
the existing UTF-8 save default.

## Verification

- Focused `PlainTextFileAdapterTests`: 11/11.
- Adapter registration, file-dialog, and plain-text controls: 52/52.
- Consuming `FreeW.Core.IO` Release build: 0 warnings, 0 errors.

## Remaining boundary

This deterministic fallback does not replace Word's interactive File Conversion dialog. Encodings
such as Shift-JIS or Windows-1251 still need an explicit user-selected encoding route because no
byte-only heuristic can reliably distinguish every valid legacy code page.
