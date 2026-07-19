# Bibliography Field Cache Visibility

## Scope

`references-heavy-fields.docx` contains a serialized complex `BIBLIOGRAPHY`
field with the cached result `References`, followed by the generated
bibliography region. Word retains that cache in the document package but does
not display it once the generated region owns the visible bibliography output.

FreeW displayed both the cache and generated region because an unrecognised
complex field fell back to its cached result.

## Change

The WPF field renderer now suppresses only the visible stale result of a
non-code `BIBLIOGRAPHY` field when the model contains a generated bibliography
paragraph. The complex field marker continues to carry the original cache and
instruction, so commit and DOCX round-trip semantics are unchanged.

## Matched Word Evidence

The candidate used the persistent Word PNG cache; no competing COM export was
started. Fresh Release composite output at 816x1056 showed:

| Fixture | Measurement | Before | After |
| --- | --- | ---: | ---: |
| `references-heavy-fields`, page 2 | Whole page | 7.8460% | 7.8224% |
| `references-heavy-fields`, page 2 | Field-cache line `(90,885)-(440,930)` | 11.8865% | 10.5950% |
| `references-heavy-fields`, page 1 | Whole page control | 0.9800% | 0.9800% |
| `references-heavy-fields`, page 3 | Whole page control | 5.7081% | 5.7081% |

Pages 1 and 3 are candidate-vs-baseline SHA-256 stable.

## Verification

The STA field test proves the rendered cache is hidden while `CommitToModel()`
retains both `References` and ` BIBLIOGRAPHY \\l 1033 `. It passed once with a
compiling Release run and once with `--no-build`.
