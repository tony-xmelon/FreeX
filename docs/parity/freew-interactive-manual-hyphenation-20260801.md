# FreeW Interactive Manual Hyphenation

## Scope

FreeW's Layout > Hyphenation > Manual command previously counted candidate words, enabled automatic
hyphenation, and displayed an informational message. It did not perform Word's per-word manual review and
did not add manual soft hyphens.

The WPF and Avalonia hosts now share a non-mutating review session. Each candidate is presented in document
order with its available break positions and Yes, No, and Cancel actions. Accepted positions are applied as
one undoable document command using U+00AD. The automatic-hyphenation setting is not changed.

The planner covers top-level body paragraphs and table-cell paragraphs, honors paragraph hyphen suppression
and the document CAPS policy, skips words that already contain a soft hyphen, and treats words split across
formatting runs as one candidate. Existing DOCX IO writes U+00AD as `w:softHyphen` and restores it on reopen.

## Verification

- `ManualHyphenationPlannerTests`: 7/7
- full `FreeW.App.Presentation.Tests`: 1,176/1,176
- `ApplyManualHyphenationCommandTests`: 1/1
- WPF manual-hyphenation route guard: 1/1
- Avalonia manual-hyphenation route guard: 1/1
- WPF Release host build: 0 warnings, 0 errors
- Avalonia Release host build: 0 warnings, 0 errors

## Header/footer follow-up (2026-08-02)

Manual review now continues from the main document and table cells into every section's default, even-page,
and first-page header/footer stories. Shared inherited story paragraphs are reviewed once by reference, so a
header reused by two section slots cannot receive duplicate soft-hyphen edits. Accepted story edits still use
the existing single undoable `ApplyManualHyphenationCommand`.

The same review pass then covers ordinary footnotes and endnotes in numeric ID order. Reserved separator and
continuation-separator note IDs are excluded, and shared paragraph instances remain deduplicated.

Text-box paragraphs on inline/floating shapes and shapes inside nested drawing groups are reviewed recursively.
Reference sets prevent malformed cyclic/shared group graphs from looping or reviewing the same paragraph twice.

Comments remain a separate review-story slice.
