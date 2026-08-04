# Avalonia Parity Wave 141: FreeX Insert Hyperlink

## Scope

Closed the highest-impact valid residual in the paired `dialog.InsertHyperlink`
surface: the selected link-type row was rendered with Avalonia Fluent's active
blue selection even though the address editor has initial focus. WPF renders
that row in its inactive selection state. The correction is local to the
Avalonia hyperlink dialog, so other list controls keep their existing focus
behavior.

## Implementation

`src/FreeX.App.Avalonia/MainWindow.cs` adds local selected and
selected-pointer-over `ListBoxItem` styles for the hyperlink type list. The
measured WPF inactive fill is `#F6F6F6` with the existing dark dialog text
brush. The production prefill, validation, ScreenTip, Bookmark, and result
paths are unchanged.

## Evidence

- Fresh current-source Linux Docker/Xvfb capture: exact `560x300`, nonblank,
  `app_exit=0`, `capture_validated=true`.
- The fresh image shows the selected `Existing File or Web Page` row in the
  inactive light-gray state while the Address field remains focused and
  selected, matching the retained WPF fixture state.
- Isolated WPF-versus-fresh-Linux comparison using the repository
  `ImageDiff` path: retained baseline `3.7252%`; after `3.089469%`; improvement
  `0.635731` percentage points, approximately `17.1%` relative.
- No WPF capture was regenerated or promoted; the retained WPF PNG remains
  nonblank authority. The current WPF detached capture outage is unchanged.

## Verification and residuals

- `DialogVisualParitySourceTests.InsertHyperlinkDialog_UsesInactiveWpfSelectionForFocusedAddressEditor`: 1 passed.
- `dotnet build src/FreeX.App.Avalonia/FreeX.App.Avalonia.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`: 0 warnings, 0 errors.
- Remaining difference in this pair is primarily Linux font availability and
  text antialiasing, plus small host-control chrome differences in borders and
  button rendering. The retained WPF raster authority is still the evidence
  boundary for further tuning.
