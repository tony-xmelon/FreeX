# XPS PDF View Option Summary

## Goal

Make XPS export summaries honest when users select PDF-only initial-view or open-mode options.

## Steps

1. Add a regression test for XPS summaries with non-default PDF initial-view/open-mode options.
2. Verify it fails because the options are currently omitted.
3. Extend `ExportPlanner` summary helpers to report those choices as PDF-only for XPS.
4. Update architecture/command parity docs if wording needs to stay aligned.
5. Run focused export planner tests and a full build, then commit and sync.
