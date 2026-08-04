# FreeP Native Caption Authoring - 2026-08-04

## Scope

This slice closes a functional package-fidelity gap in internal media caption
authoring. FreeP already read and planned native WebVTT, SRT, TTML, and DFXP
tracks, but replacing an internal track always rewrote it as WebVTT and changed
the package path. PowerPoint-compatible editing must preserve the authored
caption format unless the user explicitly chooses another supported extension.

## Behavior

- Replacing an internal track without a new source path preserves its existing
  `.vtt`, `.srt`, `.ttml`, or `.dfxp` path and detected format.
- Replacement preserves the existing relationship ID so editing does not create
  avoidable relationship churn.
- New tracks and replacements with an explicit supported source path serialize
  WebVTT, SRT, or TTML/DFXP using the selected extension; new tracks default to
  WebVTT.
- Existing external tracks remain link metadata and are not mutated.
- Authored cue text is XML-escaped in TTML output and remains parseable through
  the existing transcript planner.

## Verification

Focused `PresentationMediaTranscriptPlannerTests` passed 10/10, including native
SRT and TTML replacement, cue timing, XML escaping, and relationship preservation.
The package reader/writer already accepts the four caption extensions, so this
change stays in the shared authoring planner and does not add a host-specific
caption path.
