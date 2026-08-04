# FreeW unmodelled simple-field retention

Date: 2026-08-04

## Gap

The DOCX reader recognized a bounded set of `w:fldSimple` instructions. Any other simple field was
flattened to its cached text, and an empty-result field disappeared entirely. A subsequent FreeW save
therefore converted custom `DOCPROPERTY`, add-in, and other Word fields into ordinary text that Word
could no longer toggle or update.

## Slice

- The generic field model now records when an arbitrary instruction came from `w:fldSimple`.
- `w:fldLock` and `w:dirty` are retained as semantic flags; true values serialize canonically as `1`
  and false/default values are omitted.
- Cached text, including an empty result, and result-run formatting remain intact.
- A simple field nested in an inline content control keeps the control, comment, hyperlink, revision,
  and tooltip context owned by its wrapper.
- WPF and Avalonia reuse their existing generic field-code route, so Alt+F9 remains functional.
- F9 leaves locked imported simple fields unchanged in both hosts.

## Package Evidence

The adversarial fixture contains a bold, locked, dirty `DOCPROPERTY "Company"` field with cached
text `Contoso`, plus an empty-result custom field inside a tagged content control. After save and
reopen, both remain `w:fldSimple` with exact instructions and cached values; the non-default flags,
formatting, and SDT ownership survive, while explicit false flags canonicalize away. No `w:fldChar`
sequence is substituted.

## Verification

- Generic field package contracts: 14/14.
- Adjacent content-control and update-on-open package contracts: 37/37.
- Complex field engine contracts: 29/29.
- WPF generic field editor contracts: 9/9.
- Avalonia field display/toggle contracts: 3/3.
