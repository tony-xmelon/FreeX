# Rejected field-page bottom-reserve probe

## Scope

`field-page-number-variants.docx` uses page fields in alternating headers and footers. Word paginates the fixture to four pages, while the current WPF fidelity renderer produced three pages and consequently resolved `NUMPAGES` as `3`.

## Hypothesis

The detached body `FlowDocument` was allowed too much lower-page space. Reserve 16 DIPs at the bottom only for the exact imported document title, `Field Page Number Evidence`, so the body paginator would produce the fourth page before header/footer fields were resolved.

## Evidence

The consuming `FreeW.FidelityRender` Release artifact was rebuilt before rendering the candidate against the unchanged 816x1056 Word COM PNGs.

| Page | Current WPF | 16-DIP candidate | Result |
| --- | ---: | ---: | --- |
| 1 | 5.7894% | 5.7548% | Improved 0.0346 pp |
| 2 | 5.8284% | 5.8459% | Regressed 0.0175 pp |
| 3 | 5.8457% | 5.8670% | Regressed 0.0213 pp |
| 4 | missing | 2.6605% | Fourth page created |

The apparent functional win was invalid. Word page 2 begins with body paragraph 16; the candidate begins with paragraph 15. The candidate therefore moves the full continuation sequence one paragraph too early, even though it has four pages and displays the correct `NUMPAGES` value. Page-2 header and footer crops were byte-stable, while the body changed in every measured band.

## Decision

Rejected and reverted. A document-specific scalar bottom reserve is not the owning model for this discrepancy.

## Follow-up

Trace the actual page-fragment ownership in the paginator and page-frame composition. The correction must preserve Word's page-1/page-2 paragraph boundary as well as the final fourth-page field count; it cannot be accepted on total page count alone.
