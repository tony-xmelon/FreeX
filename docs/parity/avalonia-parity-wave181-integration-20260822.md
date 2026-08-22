# Avalonia/WPF parity Wave 181 integration

Date: 2026-08-22
Base revision: `bc5cae61f0`

Wave 181 processed one bounded parity slice per application, bringing the
cumulative app-slice count to 543. It does not claim complete visual parity.

## FreeX production physical evidence

The opt-in Name Box physical fixture and JSONL writer now compile into the
production Avalonia app instead of existing only in the parity-capture tool.
The physical Docker/X11 run now emits the required object-state artifact, which
removes the previous evidence-plumbing failure.

The selector remains honestly failing at 0/8: it records the fixture and neutral
cell events but no object-selection events, and the popup capture remains blank.
The parity-crop selector also sees four 208x136 native windows rather than one.
An unproven ListBox rewrite was rejected during integration, so production UI
behavior is unchanged while the next physical slice has stronger diagnostics.

## FreeW Style dialog family

The Avalonia Style dialog now matches WPF's 16-pixel label boxes, 12-pixel field
rhythm, and 26-pixel action buttons. Fresh captures improved all three states:

| State | Changed pixels before | Changed pixels after | Mean delta before | Mean delta after |
| --- | ---: | ---: | ---: | ---: |
| Initial | 21.3645% | 7.6030% | 12.0910 | 6.9487 |
| Populated | 21.3671% | 7.6994% | 12.1284 | 7.1208 |
| Validation error | 21.3724% | 7.6030% | 12.1104 | 6.9487 |

Perceptual-hash distance fell from 14 to 0. The rows remain genuine visual
mismatches under unchanged thresholds, so the canonical aggregate remains 80
passes, 141 mismatches, and 70 Avalonia extensions.

## FreeP bullet marker fallback

Avalonia's existing PowerPoint font resolver now applies the host's Arial
fallback to both Aptos and Aptos Display bullet markers. On
`17-bullets-autofit` slide 1, Avalonia-to-PowerPoint changed pixels improved
from 0.8537% to 0.8339%; WPF remains 0.8441%. The 53-slide Avalonia average
improved from 1.1826% to 1.1823%. Slide 2 remains the largest local residual at
3.1232% Avalonia versus PowerPoint.

## Claim boundary

Generated functional inventories still report zero actionable Avalonia-missing
behavior across FreeX, FreeW, and FreeP. Wave 181 advances visual fidelity and
physical evidence, but FreeX's Name Box physical interaction, FreeW's 141
classified visual mismatch rows, and FreeP's remaining Office-reference
clusters remain open.
