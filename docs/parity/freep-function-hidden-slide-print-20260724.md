# FreeP Hidden-Slide Print Semantics

## Scope

This slice completes the functional contract for the existing Hide Slide workflow. A hidden
slide remains in the editable presentation and can be printed when the user selects **Print
hidden slides**. The default presentation-aware full-slide, notes-page, and handout print paths
now omit hidden slides and recalculate their page counts and ranges.

The count-only planner overloads remain unchanged for callers that do not have slide metadata.
Model-aware package construction is the path used by the WPF and Avalonia print workflows, so the
option now affects the actual package that is previewed/exported rather than only its label.

## Verification

- Presentation-aware print planning excludes hidden slides by default and retains them when
  `PrintHiddenSlides=true`.
- Notes-page and handout package plans use the filtered slide range and page count.
- Existing count-only range and print APIs remain compatible.
