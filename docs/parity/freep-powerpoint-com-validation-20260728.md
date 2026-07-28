# FreeP PowerPoint COM Validation - 2026-07-28

The local machine currently resolves `PowerPoint.Application` through COM. The
render-compare harness now has a corpus mode that opens every selected deck,
exports each slide through PowerPoint, and optionally compares the emitted PNG
SHA-256 hashes with the stored PowerPoint references.

The three decks that previously produced PowerPoint repair/read errors were
validated with the new mode at 1280x720:

| Deck | Exported | Reference matches | Result |
| --- | ---: | ---: | --- |
| `10-motionpath.pptx` | 1/1 | 1/1 | pass |
| `14-smartart-live.pptx` | 4/4 | 4/4 | pass |
| `21-comments-notes.pptx` | 2/2 | 2/2 | pass |

The run completed with exit code 0 and no repair dialog. The command was:

```text
FreeP.RenderCompare --powerpoint-corpus-validate <corpus> <output> --refs <pptx-ref> --width 1280 --height 720
```

This validates slide open/export and reference provenance. It does not yet
claim PowerPoint parity for PDF/print/handout/notes/video output, or full WPF
and Avalonia raster parity; those remain separate evidence surfaces.
