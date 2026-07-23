# FreeP Repair-Dialog Corpus Package Fidelity

## Scope

The PowerPoint repair-dialog corpus was regenerated from the current FreeP writers and checked against Microsoft PowerPoint COM open behavior:

- `10-motionpath.pptx`
- `14-smartart-live.pptx`
- `21-comments-notes.pptx`

## Package fixes

- Motion-path timing roots emit PowerPoint's `dur="indefinite"`, `restart="never"`, `fill="hold"`, and `nodeType="tmRoot"` attributes.
- SmartArt presentation packages carry the `p15:sldGuideLst` extension in `presentation.xml`.
- Notes packages emit `p:notesMasterIdLst` with the relationship ID allocated for the notes master, notes-slide `p:clrMapOvr` mappings, and a schema-correct `p:notesStyle` with nine paragraph levels.
- Notes packages include the notes background/creation-id structure, a dedicated notes theme part, and a presentation-level theme relationship.

## Verification

With PowerPoint alerts suppressed, all three regenerated decks opened successfully through COM without a repair prompt. The focused FreeP structural checks for motion-path timing, SmartArt guide registration, and comments/notes package relationships pass.

The broader Open XML SDK corpus theory still reports a package-open failure for the SmartArt deck even when supplied with PowerPoint's own repaired SmartArt output; this is separate from the successful PowerPoint COM open result and remains a validator compatibility gap to investigate.

## Fresh Current-Main Rerun (2026-07-23)

The current `main` corpus was rebuilt and compared again through the installed
PowerPoint COM host at `1280x720`. All expected slides exported without a repair
prompt or removed-content report:

| Deck | PowerPoint slides | WPF vs PowerPoint | Avalonia vs PowerPoint |
| --- | ---: | ---: | ---: |
| `10-motionpath.pptx` | 1/1 | 0.0431% | 0.0675% |
| `14-smartart-live.pptx` | 4/4 | 1.0757% average | 1.0817% average |
| `21-comments-notes.pptx` | 2/2 | 0.0738% average | 0.0914% average |

The SmartArt average is the remaining visual residual in this repair-dialog
group; the package-validity blocker itself is closed on the comparison host.
