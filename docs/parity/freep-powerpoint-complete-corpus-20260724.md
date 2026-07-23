# FreeP PowerPoint COM corpus completion

## Scope

The two remaining tracked FreeP render corpus decks without PowerPoint PNG
references were exported on the COM-capable baseline machine at 1280x720:

- `23-run-baseline.pptx`: 1/1 slide exported.
- `24-run-baseline-wrap.pptx`: 1/1 slide exported.

Their references are now committed under
`tools/FreeP.RenderCompare/corpus/pptx-ref/`.

## Current verification

The corpus verifier now reports:

```text
total=26; refs-ready=26; refs-incomplete=0; refs-missing=0; slide-count-unknown=0
PowerPoint COM registered: True
```

Fresh current-artifact comparisons against the new references:

| Deck | WPF mean channel delta | Avalonia mean channel delta |
| --- | ---: | ---: |
| `23-run-baseline` | 0.0328% | 0.0872% |
| `24-run-baseline-wrap` | 0.6948% | 0.9640% |

Both captures used exact 1280x720 dimensions and completed PowerPoint export
without a repair or missing-slide result. This closes the reference-readiness
gap; it does not claim that every renderer delta is zero.
