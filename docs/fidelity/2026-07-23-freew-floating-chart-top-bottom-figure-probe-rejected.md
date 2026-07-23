# Floating Chart Top-And-Bottom Figure Probe Rejected

## Scope

The imported `drawing-objects-complex.docx` column chart is paragraph-anchored,
210 by 126 pt, and uses `TopAndBottom` wrapping with a 120 pt vertical offset.
The normal WPF path represents its wrap band as an inline full-width `Floater`.
That reserves the chart height immediately at the anchor and leaves the first
following body paragraph too low.

## Probe

Two exact-signature probes used the matching persistent 816 by 1056 Word PNG:

1. Removing the reservation improved whole-page error from `6.3885%` to
   `5.9092%`, but allowed body text to paint through the chart. The top-body ROI
   regressed from `14.5649%` to `16.5573%` and the chart ROI from `8.6512%` to
   `9.6001%`.
2. Replacing the inline Floater with a paragraph-top Figure at the authored
   offset improved the whole page to `6.0743%`, but moved the chart-adjacent
   body and downstream group anchors. Its top-body ROI rose to `16.9746%` and
   the grouped-object ROI to `7.1389%` from `6.4598%`.

Both candidates compiled and rendered successfully. Neither was retained.

## Result

WPF needs a fragment-aware top-and-bottom exclusion that starts at the actual
page-space chart band while preserving the anchor paragraph's preceding flow.
An inline Floater reserves too early; a WPF Figure applies the exclusion at the
wrong fragment boundary and shifts later paragraph-anchored overlays. This is a
pagination/anchor-ownership gap, not a chart frame-registration parameter.

## Rule

Do not accept a full-page gain from removing or relocating a wrap reservation
unless the chart band, adjacent text, and downstream paragraph-anchor objects
also improve. Keep the serialized `TopAndBottom` semantics intact until the
fragment-aware compositor can own the exclusion.
