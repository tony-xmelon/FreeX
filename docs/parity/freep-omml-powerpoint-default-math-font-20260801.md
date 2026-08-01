# FreeP PowerPoint default equation font

Date: 2026-08-01

FreeP's OMML parser already accepted caller-supplied math defaults and applied
authored `m:mathPr` values property by property. The production slide compositor
was still calling the generic parser without those defaults, so equations with no
explicit `m:mathFont` inherited the surrounding text font.

The live PowerPoint path now uses a named parser entry point whose only default is
the PowerPoint equation font, `Cambria Math`. An authored `m:mathPr/m:mathFont`
continues to override that default. Generic parser callers retain the existing
caller-controlled behavior.

## Verification

- `OmmlParserTests.PowerPointDefaults_UseCambriaMath_AndAuthoredFontStillWins`
  covers the default and explicit override.
- The production `SlideCompositor` consumes `ParsePowerPoint` for every OMML run.

This is a functional/document-semantics correction. It makes no claim about exact
PowerPoint glyph metrics or raster parity.
