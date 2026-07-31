# Ribbon Wave 89 Popup Chrome Parity

## Slice

Collapsed-group popup presentation now consumes one shared chrome contract in both ribbon hosts.
The contract is defined by `RibbonVisualMetrics.PopupChrome` and
`RibbonPopupInteractionContract.CollapsedGroup`:

- width: 220 px minimum, 360 px maximum;
- popup padding: 4 px on each side;
- menu-item rhythm: 28 px minimum height and 10 px horizontal / 5 px vertical padding;
- border: 1 px using the active ribbon surface/border roles;
- shadow: 2 px depth, 8 px blur, 0.22 opacity;
- anchor gap: 1 px;
- preferred placement: below the collapsed-group anchor, with edge repositioning enabled.

WPF applies the surface, border, padding, width, item metrics, and `DropShadowEffect` directly to the
rendered `ContextMenu`. It uses a custom placement callback and the current Windows work area to
left-clamp the popup and flip it above the anchor when the below-anchor rectangle does not fit.

Avalonia applies the same surface/border/padding/width/shadow values through the shared popup style
class on `MenuFlyoutPresenter` and uses the same item metrics on the rendered `MenuItem` controls.
Its native `MenuFlyout` remains `PlacementMode.Bottom` so the Wave 88 focus scope and presenter template
are preserved; `SlideX | FlipY` is enabled through Avalonia's native popup constraint policy for
screen-edge repositioning.

## Proof

Shared renderer-neutral proof:

- `RibbonCollapsedGroupPresentationPlannerTests.PopupChrome_UsesOneSharedRendererNeutralMetricSet`
  inspects every shared chrome metric.
- `RibbonCollapsedGroupPresentationPlannerTests.PopupPlacementPlanner_FlipsAboveAndClampsHorizontallyAtScreenEdges`
  proves the deterministic flip and horizontal clamp policy.

WPF rendered-control proof:

- `RibbonWpfSplitButtonTests.CollapsedGroupPopup_UsesPlacementAndEscapeDismissalContract` inspects the
  actual `ContextMenu`, its custom placement callback, width limits, padding, border, shadow, and the
  rendered disabled/item spacing values, then verifies Escape dismissal.

Avalonia rendered-control proof:

- `AvaloniaRibbonSplitButtonTests.CollapsedGroupPopup_FocusesEnabledItemsTraversesAndRestoresAnchorOnEscape`
  inspects the actual `MenuFlyout`, native edge constraint flags, popup chrome style registration, and
  rendered item metrics, then verifies first-enabled focus, Up/Down traversal, Escape dismissal, and
  focus restoration to the collapsed anchor.

Focused verification:

```text
dotnet test tests\Free.Shared.Ribbon.Tests\Free.Shared.Ribbon.Tests.csproj --configuration Release --filter "FullyQualifiedName~AvaloniaRibbonSplitButtonTests|FullyQualifiedName~RibbonCollapsedGroupPresentationPlannerTests" --logger "console;verbosity=minimal"
19 passed, 0 failed

dotnet test tests\Free.Shared.Ribbon.Wpf.Tests\Free.Shared.Ribbon.Wpf.Tests.csproj --configuration Release --filter "FullyQualifiedName~RibbonWpfSplitButtonTests" --logger "console;verbosity=minimal"
13 passed, 0 failed
```

## Residual Toolkit-Native Behavior

- Avalonia's popup positioner owns the final work-area coordinates and may choose its native flip/slide
  result; the shared contract supplies the preferred below-anchor placement, gap, and enabled edge policy.
- WPF's custom callback uses `SystemParameters.WorkArea` (the primary work area); per-monitor work-area
  selection and native popup DPI conversion remain WPF/OS-owned.
- Native animation, nested-submenu chrome, menu template glyphs, and the final corner/shadow rasterization
  remain toolkit-native. The shared metrics constrain the common geometry and colors without replacing
  either toolkit's popup focus scope or menu template.
- This slice intentionally does not change Wave 88 focus/traversal behavior, application-specific
  FreeX/FreeW/FreeP code, or the integration report.
