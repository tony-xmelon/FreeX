# Avalonia Column Rule Word Registration

## Reference

- Fixture: `wordart-picture-watermark-layout.docx`
- Target: fresh Word COM PDF export, rasterized to 816x1056 PNG
- Candidate: Release `FreeW.PageLayoutShot --fixtures-dir`, so it renders the
  same serialized DOCX as Word.

## Correction

Avalonia drew a gray anti-aliased two-pixel separator in the column gap. Word
uses an opaque black one-pixel rule. `DocumentView` now paints the rule at the
preceding device-pixel center with an opaque black one-DIP pen.

The raw middle-page samples confirm the registration: Word and Avalonia are
black at x=407 and white at x=408. The rejected first phase placed Avalonia's
otherwise crisp rule at x=408 instead.

## Result

| Whole-page metric | Before | After |
| --- | ---: | ---: |
| Mean channel delta | 24.1824 | 23.9463 |
| Changed pixels | 18.839% | 19.246% |

The pixel-count increase is expected: the target's full-opacity black rule now
replaces the prior gray anti-aliased pair. The mean color error improves, and
the rule occupies the exact Word pixel.

## Controls And Verification

- The four-page `field-page-number-variants` Avalonia control was SHA-256
  byte-identical on pages 1-4.
- `FreeW.PageLayoutShot` Release build: 0 warnings, 0 errors.
- `VisualEvidencePageLayoutShotSourceTests`: 6 passed after build and 6 passed
  with `--no-build`.
