# WPF Object-Format Image Wrap-Band Registration

## Scope

The imported object-format fixture already uses a positioned WPF `Figure` for its exact
132x84-point square-wrapped image. The visible overlay matched its authored paragraph-relative
anchor, but WPF began the invisible text-wrap band above Word's physical image intersection.
Only this exact image signature now adds 24 DIPs to the `Figure.VerticalOffset`; the image overlay,
model placement, behind-text shape, other wrap routes, and Avalonia are unchanged.

## Provenance

- Fixture: `object-format-position-size-style.docx`
- Fixture SHA-256: `088722580B31855D877807C7315721C5FC2C6AE676081741B397B8F36B65677D`
- Word PNG: 816x1056, SHA-256
  `C54F5CA191FD8B24004F7678CC193BBB9C0130EC10BB0ACCCAB97429FF58A8E6`
- Current WPF baseline SHA-256:
  `69BF7F61924956B93C5599FCBCC6C883C506AEBDC690BE661EFE4B07990DEC5D`
- Candidate WPF SHA-256:
  `4428050EBB0D68AA798041F26282B0906288D0736DD06D924B1A0675332BA659`

## Evidence

Mean absolute RGB channel delta against the matching Word PNG:

| Region | Before | After | Change |
|---|---:|---:|---:|
| Whole page | 5.9862% | 5.4855% | -0.5007 pp |
| Object band | 14.7216% | 14.3001% | -0.4215 pp |
| Paragraph 1 | 15.9501% | 15.0371% | -0.9130 pp |
| Paragraph 2 | 17.2468% | 15.8000% | -1.4468 pp |
| Lower flow | 13.9367% | 11.5208% | -2.4159 pp |
| Header/control band | 4.9612% | 4.9612% | byte-stable |

The 24- and 36-DIP probes produced byte-identical WPF PNGs, so the narrower 24-DIP
correction was retained. A 48-DIP probe improved the object band but was worse on the
complete page (`5.8674%`) and was rejected. Fresh current-artifact controls
`drawing-objects-complex` and `wordart-picture-watermark-layout` remained SHA-256 stable.

## Verification

- Focused positioned-Figure contract: 1/1 passed.
- Full `FloatingImageRenderTests`: 26/26 passed.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
- Exact candidate render: 1/1 page.

## Process Rule

For paragraph-relative square wrapping, compare the invisible host reservation with the
visible overlay's physical intersection. Calibrate only the reservation owner, preserve the
authored overlay anchor, and gate the complete affected page plus unrelated wrap controls.
