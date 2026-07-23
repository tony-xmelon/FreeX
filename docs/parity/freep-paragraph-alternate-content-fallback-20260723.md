# FreeP paragraph AlternateContent fallback parity

## Scope

The PPTX reader previously ignored non-math `mc:AlternateContent` inside a
text paragraph. PowerPoint files that used an extension branch for ordinary
text could therefore lose visible paragraph content on import.

The reader now selects a supported `mc:Choice` branch and otherwise consumes
the visible `mc:Fallback` branch. The existing OMML math path remains a
structured math run, while ordinary runs, breaks, fields, and nested
AlternateContent are dispatched through the normal paragraph reader.

## Verification

- `PptxRoundTripTests.RoundTrip_ParagraphAlternateContent_UsesChoiceOrFallbackWithoutDroppingText`
  passed in the compiling test run and in the `--no-build` rerun.
- The test covers both a supported choice and an unsupported choice with
  visible fallback text.

This is a package/function parity fix. It does not claim a raster-fidelity
change for the existing visual corpus.
