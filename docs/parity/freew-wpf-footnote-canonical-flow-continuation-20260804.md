# FreeW WPF footnote canonical-flow continuation

## Scope

The WPF fidelity compositor previously measured the complete rendered footnote and
added that height to every page's bottom padding. A 700-word footnote therefore made
the body paginator emit 47 pages; rendering the first eight showed mostly empty body
pages. Removing the reserve produced two pages and dropped continuation ownership.

For plain, single-section, single-column paragraph flows with an overflowing footnote,
the compositor now keeps one canonical WPF body flow and inserts layout-only owners at
the authored reference blocks:

- a `ContentBottom` Figure reserves the first fragment on the reference page;
- full-content transparent blocks own intermediate continuation-only pages;
- a final `ContentBottom` Figure reserves the last fragment while body flow resumes;
- later references are repaginated by that same flow, so their short footnotes remain
  attached to the shifted physical page.

The shared continuation plan supplies each page's exact text fragment. The old global
reserve remains authoritative for ordinary one-page footnotes and unsupported complex
flows; no table, section, column, or nested-block behavior is generalized here.

## Matched evidence

Fixture: `f2-footnote-overflow.docx`, SHA-256
`A85D96F5...2749F`. Reference: five 816x1056 PNGs from the preserved isolated Word 16
export in `C:\Temp\FreeW-FootnoteOverflowProbe-20260730\word-baseline\word`.

The accepted current-main candidate emits exactly five pages and matches Word's body
sequence: page 3 has filler paragraphs 1-12, page 4 has filler 13-22 plus More filler
1-17 and footnote 2, and page 5 has More filler 18-20. The long note spans pages 1-3
without dropping or repeating words.

Whole-page mean channel delta versus Word, compared with the prior rejected four-page
physical-compositor probe:

| Page | Prior probe | Canonical flow |
| --- | ---: | ---: |
| 1 | 11.8968% | 8.6936% |
| 2 | 14.2785% | 9.8555% |
| 3 | 8.5042% | 7.0768% |
| 4 | 5.5490% | 3.0862% |
| 5 | absent | 0.3045% |

An attempted top alignment for non-final fragments regressed every full page and was
reverted. The ordinary two-page `f2-footnotes` control retained two pages; page 2 was
byte-identical to the retained current output and page 1 moved only 104 antialiased
pixels (`0.00054%` mean delta), with a same-artifact repeat remaining SHA-stable.

## Remaining work

Print Preview and native Print still use `PrintLayout`'s global reserve and need the
same physical-page owner lifted into their paginator. Complex multi-section, column,
table, and nested reference flows remain on the preserved fallback. The residual note
font cadence and vertical registration are visual calibration work after ownership.
