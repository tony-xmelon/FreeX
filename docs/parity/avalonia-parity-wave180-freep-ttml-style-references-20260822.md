# FreeP Wave180: TTML Style References

Date: 2026-08-22

## Scope

FreeP caption planning now resolves authored TTML style definitions and `style` references before producing `PresentationMediaTranscriptCueSpan` values. Definitions are collected from TTML `<style>` elements using `xml:id`/`id`, references may contain multiple whitespace-separated style ids, and referenced definitions may inherit from other definitions. Repeated ids in a chain are ignored to protect playback planning from malformed cyclic TTML. Inline attributes are applied after referenced styles, so authored inline values take precedence.

The resolved span model covers the existing highest-value caption properties:

- foreground and background color
- font family and absolute font size
- bold and italic/oblique weight/style
- underline text decoration
- opacity, including percentage and decimal forms

Existing voice, language, and supported cue layout inheritance continue to use the same resolution path. WPF and Avalonia playback consume the same resolved span model; both renderer tests verify the same color alpha, font, weight, style, underline, and size behavior.

## Package Round-Trip

PowerPoint-native TTML sidecars retain their original package path, relationship metadata, and authored bytes through load, modeled edit, save, and reopen. The planner is rerun after reopen and resolves the style chain again, proving that package preservation and playback semantics are independent of the renderer.

Authored FreeP cue replacement continues to write the resolved supported properties inline. It does not claim to preserve a style-sheet identity when the authoring model only contains resolved spans.

## Verification

- `PresentationMediaTranscriptPlannerTests`: 31/31 passed, including chained references, inline precedence, and a cyclic reference fixture.
- `ActiveTtmlCue_RendersResolvedStyleProperties`: WPF 1/1 passed.
- `Controller_RendersResolvedTtmlStyleProperties`: Avalonia 1/1 passed.
- `Media_PowerPointNativeTtmlCaptionPackage_RoundTripsAndPlansTranscriptMetadata`: 1/1 passed.

## Residuals

TTML decorations and semantics that are not represented by the existing FreeP span contract remain intentionally unsupported: line-through/overline combinations, text outlines and shadows, ruby annotations, bidi-specific behavior, and richer TTML style selectors. They are not synthesized from partial information. These remain candidates for a later model extension with paired WPF/Avalonia evidence.
