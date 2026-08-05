# FreeW native caption and Table of Figures ownership

Date: 2026-08-06

## Scope

FreeW-authored captions now serialize their ordinal as native Word `SEQ` complex fields. Generated
Tables of Figures, Tables, Equations, and custom caption labels serialize one native spanning
`TOC \c "Label"` field around their cached result paragraphs. Ordinary Tables of Contents explicitly
exclude `TOC` fields carrying the caption-table `\c` or `\a` switches.

## Word calibration

A controlled Word COM document created with `Selection.InsertCaption` and
`TablesOfFigures.Add(..., "Figure")` established the exact instructions:

```text
 TOC \c "Figure" 
 SEQ Figure \* ARABIC 
```

The exact FreeW-authored package used for the update gate had SHA-256:

```text
702A4F415E52F9C47128203D35160AEB756EEF111A14BAB3827C714C1A19D515
```

Word opened that package with one `TablesOfFigures` object and two `SEQ Figure` fields. Updating the
native table retained both cached rows:

```text
before: Figure 1: First diagram<TAB>1 | Figure 2: Second diagram<TAB>1
after:  Figure 1: First diagram<TAB>1 | Figure 2: Second diagram<TAB>1
```

The COM instance closed cleanly and left no `WINWORD` process.

## Verification

- Model caption/TOF/TOC/complex-field tests: 73/73.
- Focused package round-trip tests: 3/3.
- WPF caption-table insertion and logical-page refresh: 2/2.
- Avalonia caption-table insertion and logical-page refresh: 2/2.

## Process rule

Generated result text is not functional parity by itself. Author the native source fields first,
then the native result-owner field, and validate the exact product package by updating it in Word.
When two features share a field keyword, recognition must be disambiguated by serialized switches
before refresh or replacement logic runs.
