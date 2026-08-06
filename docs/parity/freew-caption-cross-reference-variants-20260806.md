# FreeW Caption Cross-reference Variants (2026-08-06)

## Scope

FreeW now matches Word's five cross-reference choices for Figure, Table, and Equation captions:

- Entire caption
- Only label and number
- Only caption text
- Page number
- Above/below

All variants use Word-native `REF`/`PAGEREF` fields. The visible distinction comes from three exact bookmark ranges over the caption: the whole caption, label plus sequence number, and descriptive text only.

## Word Calibration

A live Word COM calibration created `Figure 1: Sample caption text` and inserted all five variants. Word authored:

- `REF <whole> \h` -> `Figure 1: Sample caption text`
- `REF <label> \h` -> `Figure 1`
- `REF <text> \h` -> `Sample caption text`
- `PAGEREF <whole> \h` -> `1`
- `REF <whole> \p \h` -> `above`

The corresponding hidden bookmark texts were exactly the whole caption, `Figure 1`, and `Sample caption text`.

## Implementation

- Caption targets require a modeled native `SEQ` field.
- The insertion planner selects a character range for each caption variant and reuses only an exact matching bookmark.
- The undoable command splits a run at the required character boundaries when necessary, preserves existing bookmark positions, and restores runs, bookmark names, and boundaries on undo.
- Field refresh resolves the bookmarked run span instead of treating every bookmark as a whole-paragraph target.
- WPF and Avalonia pass the shared range plan to the same model command.
- `CaptionLabelAndNumber` and `CaptionText` are insertion-time choices. After DOCX reopen, both are modeled as plain `Text` REF fields because Word serializes no distinguishing switch; the bookmark range remains authoritative.

## Exact Word Gate

FreeW package at short path `C:\fwc\caption-crossrefs.docx`:

- SHA-256: `CBCA4D7D19CC8B57C203541F0BA3569223FF771EBC1EDEF6E51A6C5FB207369D`
- six Word fields including the caption's `SEQ` field

Word updated every field without changing its result and saved `C:\fwc\word.docx`:

- SHA-256: `66C4B1117C659B41E72B5C11E09CC3B23421DC5E34040C523D207B6E95808721`
- whole bookmark text: `Figure 1: Sample caption text`
- label bookmark text: `Figure 1`
- text bookmark text: `Sample caption text`

## Verification

- Core cross-reference model and command tests: 68/68
- Exact DOCX cross-reference round-trip tests: 10/10
- Shared dialog planner tests: 5/5
- WPF editor tests: 7/7
- Avalonia editor tests: 4/4
- Repository preflight: passed
- Full Release solution build: 0 warnings / 0 errors
- Default non-UI lane: timed out in unrelated `FreeX.App.Host.Logic.Tests` and `FreeX.App.Avalonia.Tests`; the owned process tree was reaped by PID and was not used as slice acceptance evidence

## Process Note

Caption variants are range semantics, not field-switch semantics. Calibrate the host's exact bookmark spans first, then preserve those spans through run splitting, package round-trip, field refresh, undo/redo, and both host mutation paths. A broad paragraph bookmark is not a valid substitute for a partial caption range.
