# Rejected revision palette probe

## Scope

The Word baselines for `review-compare-visual-proof` and `review-combine-visual-proof` differ from the shared first-seen-author revision palette used by WPF and Avalonia.

## Hypothesis

Calibrate the first two shared palette entries from the measured combine capture: `#0070C0` to `#0078D4`, and `#8064A2` to `#5C2E91`.

## Evidence

The planner contract passed 2/2 and the consuming Release `FreeW.FidelityRender` artifact was rebuilt. The same Word PNG cache was used for the target and controls.

| Fixture | Whole mean channel delta | Changed pixels | Target ROI mean channel delta |
| --- | ---: | ---: | ---: |
| combine | 2.1111 -> 2.1623 | 2.5458% -> 2.4615% | 15.2545 -> 16.2753 |
| compare | 2.4296 -> 2.4243 | 2.4965% -> 2.4965% | 23.8326 -> 23.6061 |
| proofing control | 6.2992 -> 6.3017 | 9.0381% -> 9.0390% | 18.8553 -> 18.8635 |
| protected proofing control | 6.2992 -> 6.3017 | 9.0381% -> 9.0390% | 18.8553 -> 18.8635 |

Although the combine changed-pixel ratio fell, the target mean error increased and both controls regressed. The single-author compare capture uses a distinct Word pink (`#CC3595`) despite the model exposing no serializable revision-color metadata.

## Decision

Rejected and reverted. Word's automatic "by author" display-color assignment is not a package-semantic first-seen-author palette. Do not hard-code evidence-document titles or author names to imitate the current Word process state.

## Follow-up

Keep revision colors deterministic and model-neutral until an authored/serialized display-color source is available. Prioritize the separate change-bar geometry and review text-raster owners for visual improvement.
