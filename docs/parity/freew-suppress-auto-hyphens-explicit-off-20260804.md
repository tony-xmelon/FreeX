# FreeW explicit auto-hyphenation override parity (2026-08-04)

## Scope

Word distinguishes an absent `w:suppressAutoHyphens` paragraph property from an explicit
`w:suppressAutoHyphens w:val="0"`. The latter is direct formatting that enables automatic
hyphenation even when the paragraph style suppresses it. FreeW previously represented both states
as `false`, so save/reopen discarded the override and changed layout semantics.

## Change

`ParagraphFormatting.SuppressAutoHyphensIsSet` now preserves the serialized presence bit. The DOCX
reader and writer retain absent, explicit-on, and explicit-off forms; WPF carries the bit through its
`FlowDocument` paragraph tag; and both hosts resolve direct formatting before style inheritance.
Applying the Paragraph dialog records the checkbox state as an authored direct override.

## Verification

- `DocxRoundTripTests.SuppressAutoHyphens_RoundTripsExplicitOnAndOffPerParagraph`: exact package XML
  plus reopen state, 1/1.
- WPF `HyphenationRenderTests.ExplicitOff_OverridesSuppressingParagraphStyle` and
  `HomeDialogDepthTests.ApplyParagraphDialogFormatting_SetsLineAndPageBreakToggles`: 2/2.
- Avalonia `DocumentViewHeadlessTests.Direct_auto_hyphenation_opt_in_overrides_suppressing_style` and
  `FontAndParagraphDialogTests.ParagraphDialog_apply_marks_widow_control_as_explicit_even_when_cleared`:
  2/2.
- Release builds for Core IO tests, WPF host/tests, and Avalonia host/tests: 0 warnings, 0 errors.

This is deterministic package and host behavior evidence; no Word PNG comparison is required.
