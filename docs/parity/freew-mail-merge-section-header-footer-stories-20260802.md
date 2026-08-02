# FreeW mail merge section header/footer stories

## Gap

Mail merge cloned and substituted the body plus only the final section's default header and footer.
It dropped paragraph section-break metadata, non-final section geometry, and all first/even header/footer
stories. Check for Errors scanned the same incomplete story set.

## Result

Plain and rules-aware record merges now:

- preserve paragraph-owned section breaks, break kinds, and independently cloned page settings;
- substitute all default, first-page, and even-page header/footer stories in every section;
- retain the final section's first/even activation and complete page-setting state; and
- keep the source template and its section/header/footer objects unchanged.

The shared Check for Errors planner scans the same six story slots for every section, so a missing field
or malformed rule in a first/even or non-final-section story is reported before completion.

## Verification

- focused plain/rules-aware section-story model contracts: 2/2;
- full mail-merge model lane: 100/100;
- shared mail-merge dialog planner contracts: 16/16;
- full `FreeW.App.Presentation.Tests`: 1,180/1,180;
- WPF Check for Errors command contracts: 3/3; and
- Avalonia mailings engine lane: 29/29.

## Residual

Record-boundary section ownership for Letters output is covered by the follow-up
`freew-mail-merge-letter-record-sections-20260802.md` slice. Interactive Complete-and-pause reporting remains
separate host behavior.
