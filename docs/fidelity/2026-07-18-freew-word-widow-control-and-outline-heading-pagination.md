# FreeW Word Widow Control And Outline Heading Pagination

## Scope

Word treats omitted `w:widowControl` as enabled, while an explicit `w:widowControl`
with `w:val="0"` remains off. FreeW now retains that presence distinction through
the model and DOCX writer. The WPF renderer uses `KeepTogether` as its closest
available approximation for Word's widow/orphan rule.

The renderer also avoids a redundant WPF `List` wrapper for a single imported
multi-level `Heading1`: its synthetic outline marker is retained directly on the
paragraph. The native wrapper had added a trailing `ListItem` band before ordinary
body flow, which made Word's first-page content spill into the following page.

## Matching Word COM Evidence

Fresh current Release WPF composites were compared to the persistent 816x1056
Microsoft Word COM baselines for `field-page-number-variants.docx`:

| Page | Before | After |
| --- | ---: | ---: |
| 1 | `10.3167%` | `5.7894%` |
| 2 | `9.6755%` | `5.8284%` |
| 3 | `6.0623%` | `5.8457%` |
| 4 | `3.5943%` | `2.3463%` |

The earlier direct-heading-only probe improved pages 1, 2, and 4 but split the
next two-line paragraph at the page-2 boundary, regressing page 3. The effective
widow-control rendering preserves that continuation-page boundary.

## Controls

Current Release controls against the same Word corpus:

| Fixture/page | Before | After |
| --- | ---: | ---: |
| `f2-hf-basic` p1 | `3.4810%` | `3.4810%` |
| `f2-hf-basic` p2 | `3.5162%` | `3.3167%` |
| `f2-hf-basic` p3 | `6.2788%` | `2.7771%` |
| `f2-hf-images` p1 | `1.1102%` | `1.0816%` |
| `f2-hf-images` p2 | `1.1223%` | `1.1223%` |
| `f2-footnotes` p1/p2 | `3.6940%` / `2.5382%` | byte-stable |

## Verification

- Explicit-on, explicit-off, and omitted widow-control package tests: `3/3`.
- WPF single-heading outline and omitted-versus-explicit-off contracts: `2/2`.
- `FreeW.FidelityRender` Release build: `0` warnings, `0` errors.

## Guard

Do not collapse omitted and explicit-off `w:widowControl` into one boolean. A
candidate that fixes a first-page list heading is insufficient unless every
continuation page improves or holds; the page-three regression from the
heading-only probe is the required counterexample.
