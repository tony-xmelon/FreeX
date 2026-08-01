# FreeW Interactive Manual Hyphenation

## Scope

FreeW's Layout > Hyphenation > Manual command previously counted candidate words, enabled automatic
hyphenation, and displayed an informational message. It did not perform Word's per-word manual review and
did not add manual soft hyphens.

The WPF and Avalonia hosts now share a non-mutating review session. Each candidate is presented in document
order with its available break positions and Yes, No, and Cancel actions. Accepted positions are applied as
one undoable body-text command using U+00AD. The automatic-hyphenation setting is not changed.

The planner covers top-level body paragraphs and table-cell paragraphs, honors paragraph hyphen suppression
and the document CAPS policy, skips words that already contain a soft hyphen, and treats words split across
formatting runs as one candidate. Existing DOCX IO writes U+00AD as `w:softHyphen` and restores it on reopen.

## Verification

- `ManualHyphenationPlannerTests`: 4/4
- `ApplyManualHyphenationCommandTests`: 1/1
- WPF manual-hyphenation route guard: 1/1
- Avalonia manual-hyphenation route guard: 1/1
- WPF Release host build: 0 warnings, 0 errors
- Avalonia Release host build: 0 warnings, 0 errors

## Remaining Difference

Word can review additional text stories such as headers and footers. This slice deliberately limits manual
review to the main document story and table cells, matching FreeW's current editable body ownership.
