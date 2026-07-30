# WPF Footnote Reserve Probe

## Scope

The controlled `f2-footnote-overflow.docx` contains one 700-word footnote. It
was used to establish whether the WPF FidelityRender page-count mismatch could
be corrected by changing the existing document-wide footnote reserve.

## Matching Evidence

All renders used the same 816 x 1056 surface and the same input document:

| Renderer configuration | Physical pages |
|---|---:|
| Word COM reference | 5 |
| Current WPF composite (largest footnote region reserved on every body page) | 8 |
| WPF composite with the reserve disabled | 2 |

The Word export is in `C:\Temp\FreeW-FootnoteOverflowProbe-20260730\word-baseline`.
The no-reserve candidate was built from the consuming Release
`FreeW.FidelityRender` artifact and rendered to
`C:\Temp\FreeW-FootnoteOverflowProbe-20260730\wpf-no-global-reserve`.

## Conclusion

Neither global-reserve extreme is a valid approximation. The current path
over-reserves every later body page, while no reserve leaves all overflowing
note content without the intervening continuation pages. The next WPF slice
must compose a bounded first fragment on the reference page, insert subsequent
continuation pages, and reflow later body content against that physical-page
sequence. Do not accept a reserve scalar change without a fresh Word comparison
of the full page sequence.
