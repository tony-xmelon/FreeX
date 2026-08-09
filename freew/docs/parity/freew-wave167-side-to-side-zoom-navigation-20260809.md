# FreeW Wave167: Side-to-Side zoomed pair navigation

## Scope

The WPF Side to Side surface navigates through the editable paginated page panel. Its
next/previous pair target remains page-aligned when the view is zoomed. Avalonia already
uses the live editable editor and page-aware horizontal projection, but cached the pair
scroll stride only when entering Side to Side. Zooming afterwards left navigation using the
old logical distance, so the status pair and visible page could diverge.

## Implementation

Avalonia now recomputes the two-page stride from the current page width, shared inter-page
gap, and zoom scale whenever zoom changes while Side to Side is active. The current pair is
immediately re-applied to the scroll viewer, preserving navigation state while keeping the
visible page pair aligned.

## Evidence

- WPF oracle: `PageViewModesTests.WpfHost_SideToSideNavigationControlsStepPagePairs`
  navigates the editable paginated surface by page pairs.
- Avalonia regression: `ViewTabDepthTests.MainWindow_side_to_side_pair_navigation_tracks_zoomed_page_stride`
  enters the live editable surface, zooms to 150%, advances one pair, and verifies the
  offset equals two zoomed page strides including the shared page gap.

## Verification status

Static verification only was completed in Wave167: the changed files are scoped to
`freew/**`, `git diff --check` passed, and the worker worktree is exact-clean. Runtime
verification was deliberately deferred because the host was under sustained memory
pressure from an external full `FreeW.slnx` test session; no additional build or test
process was started by this worker.

Integration should run these focused commands serially after memory is available:

```text
dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj -c Release --filter FullyQualifiedName~FreeW.App.Avalonia.Tests.ViewTabDepthTests
dotnet test freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj -c Release --filter FullyQualifiedName~FreeW.App.Host.Tests.PageViewModesTests
```

## Residuals

Multiple Pages remains a read-only preview in both current hosts. Split remains a live
editor plus read-only snapshot. Native toolkit rendering and full Word visual comparison
remain separate parity work.
