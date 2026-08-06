# FreeW SEQ Result-picture Switches (2026-08-06)

## Scope

FreeW now evaluates Word's case-sensitive `SEQ` result-picture switches:

- `\* Arabic` / `\* ARABIC`
- `\* ROMAN`
- `\* roman`
- `\* ALPHABETIC`
- `\* alphabetic`

Arabic pictures retain decimal output but still count as authored result pictures for `\h`. Unknown pictures retain decimal output. The same slice closes adjacent Word-calibrated sequence gaps:

- `\n` advances and displays the next number.
- `\h` hides the result unless a recognized numeric result picture is present.
- numeric pictures are found across multiple `\*` switches, including `MERGEFORMAT`.
- `\s N` restarts the first matching sequence after a heading at level `N` or higher.
- body-table fields participate in main-story sequence order and Update Fields in both hosts.
- a valid empty `\h` result replaces stale cached text in both hosts.

Formatting is applied only after reset/repeat/advance resolution.

## Live Word Calibration

An unsaved Word COM document established the exact contract:

- `SEQ Figure \r 14 \* ROMAN` -> `XIV`
- `SEQ Figure \r 14 \* roman` -> `xiv`
- `SEQ Figure \r 27 \* ALPHABETIC` -> `AA`
- `SEQ Figure \r 27 \* alphabetic` -> `aa`
- `SEQ Figure \r 27 \* ARABIC` -> `27`

A second unsaved Word COM calibration established the switch interactions:

- `SEQ N`, `SEQ N \n`, `SEQ N` -> `1`, `2`, `3`
- `SEQ H \r 4 \h` -> empty
- `SEQ H \r 4 \h \* ROMAN` -> `IV`
- `SEQ H \r 4 \h \* Arabic` -> `4`
- `SEQ M \r 14 \* MERGEFORMAT \* ROMAN` -> `XIV`
- `SEQ M \r 14 \* ROMAN \* MERGEFORMAT` -> `XIV`
- repeated `SEQ S \s 1` fields produce `1`, `2` after one Heading 1 and restart at `1` after the next Heading 1
- a Heading 2 resets `\s 2`, and a Heading 1 also resets `\s 2`

## Exact Package Gate

FreeW authored `C:\fws\seq-pictures.docx` with SHA-256 `12DCC01E1F838E2328286D29E8A760B5C5C96001653EDE93B93A42A1A028667D`.

Word exposed all five fields, returned `true` from every individual `Field.Update()`, and preserved the FreeW cached results exactly (`XIV`, `xiv`, `AA`, `aa`, `27`). Word saved `C:\fws\word.docx` with SHA-256 `EF788FBC0828D17D593A0B8EA9B3F0930D3A2B8CC786F2B72E89F8F831650BF6`.

FreeW reopened the Word-saved package and preserved every field instruction and result exactly.

## Verification

- `ComplexFieldEngineTests`: 43/43
- exact complex-field DOCX round-trip cases: 10/10
- WPF `ComplexFieldEditorTests`: 11/11
- Avalonia `FieldDisplayParityTests`: 4/4
- `dotnet build FreeX.slnx --configuration Release --no-restore`: 0 warnings, 0 errors

Repository preflight passed JSON, XML, tooling, project, SDK, packaging, and generated-document checks through the FreeP visual-evidence stage, then stopped because current main's unrelated FreeP whole-window manifest was stale. This slice does not modify that artifact.

## Process Note

Calibrate field-result pictures independently from counter ownership. Result formatting belongs after reset/repeat/advance resolution. Main-story traversal must include table cells, and an intentionally empty result is a successful recomputation rather than a reason to retain stale text.
