# FreeP PowerPoint COM Repair-Validity Audit

Date: 2026-07-17

## Scope

Fresh PowerPoint COM opens and PNG exports were rerun for the three corpus
decks that previously produced PowerPoint repair dialogs:

| Deck | Slides exported | WPF vs PowerPoint | Avalonia vs PowerPoint |
| --- | ---: | ---: | ---: |
| `10-motionpath.pptx` | 1/1 | 0.0431% | 0.0702% |
| `14-smartart-live.pptx` | 4/4 | 1.1127% average | 1.1099% average |
| `21-comments-notes.pptx` | 2/2 | 0.2496% average | 0.4145% average |

Each COM export completed successfully with no repair prompt or removed
content report. This closes the previously observed package-validity failure
for these three baseline decks on the installed PowerPoint comparison host.

## Verification

- `FreeP.RenderCompare --avalonia-compare` completed for all three decks.
- PowerPoint exported every expected slide: `1/1`, `4/4`, and `2/2`.
- The COM helper cleaned up each comparison PowerPoint process after export.
