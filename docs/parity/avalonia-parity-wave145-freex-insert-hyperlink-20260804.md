# Avalonia Parity Wave 145: FreeX Insert Hyperlink

## Scope

Reduced the valid paired `dialog.InsertHyperlink` residual in the Avalonia
hyperlink type list. The retained WPF authority shows an inactive light-gray
selected row while the Address editor owns initial focus, with four link types
fitting the fixed 96px list without scrolling.

## Change and evidence

- Routed only the hyperlink type list through the shared Windows-style list
  template, with zero vertical item padding so four 24px rows fit the planner's
  96px list height.
- Kept the local inactive selection override across selected, focused, and
  pointer-over states; production prefill, focus, validation, and result paths
  are unchanged.
- Refreshed only the Avalonia `dialog.InsertHyperlink` PNG from current source
  under Linux Docker/Xvfb: exact `560x300`, nonblank, `app_exit=0`,
  `capture_validated=true`. The retained WPF PNG was not regenerated or altered.
- Against the valid refreshed current-source baseline, the paired triage score
  improved from `0.076517` to `0.074729` (`0.001788`, about 2.34% relative).
  No threshold was changed and no WPF evidence was fabricated.

## Verification

- `InsertHyperlinkDialog_UsesInactiveWpfSelectionForFocusedAddressEditor`: 1
  passed.
- `InsertHyperlinkParityCapture_UsesFixtureWithoutChangingProductionPrefill`: 1
  passed.
- Targeted Avalonia capture: passed with the exact planner dimensions.
