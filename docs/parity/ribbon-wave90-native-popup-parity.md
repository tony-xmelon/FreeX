# Ribbon Wave 90: native nested-popup parity

## Slice

Wave 90 extends the Wave 89 collapsed-popup contract across nested submenu presentation and
interaction. The shared ribbon layer now owns:

- submenu chrome metrics, including item rhythm, border thickness, and submenu anchor gap;
- enabled-item focus discovery and sibling traversal for every menu depth;
- explicit Escape and Left outcomes for closing a submenu versus the root popup;
- parent/anchor focus restoration policy;
- monitor work-area selection and device-pixel to DIP normalization primitives;
- the existing below-anchor gap, horizontal clamp, and above-anchor edge flip.

WPF remains the interaction authority. Its collapsed `ContextMenu` recursively applies the shared
submenu chrome, closes the current child submenu on Escape or Left, restores the parent through
native keyboard focus, and selects the nearest native monitor before normalizing that monitor's work
area for the shared placement planner. Avalonia recursively applies the same menu-item metrics,
preserves native submenu opening and directional navigation, maps Escape/Left to the same shared
dismissal outcomes, and marks the restored parent selected while asking the native focus manager to
focus it. Its popup positioner remains responsible for the final per-monitor placement.

## Proof

Shared planner and rendered Avalonia proof:

```text
dotnet test tests\Free.Shared.Ribbon.Tests\Free.Shared.Ribbon.Tests.csproj --configuration Release --filter "FullyQualifiedName~RibbonCollapsedGroupPresentationPlannerTests|FullyQualifiedName~AvaloniaRibbonSplitButtonTests" --logger "console;verbosity=minimal"
22 passed, 0 failed
```

This includes monitor selection/normalization, submenu chrome, dismissal planning, enabled-item
traversal, nested submenu chrome, Left dismissal, and parent selection restoration on the rendered
Avalonia `MenuFlyout`.

WPF rendered proof:

```text
dotnet test tests\Free.Shared.Ribbon.Wpf.Tests\Free.Shared.Ribbon.Wpf.Tests.csproj --configuration Release --filter "FullyQualifiedName~RibbonWpfSplitButtonTests" --logger "console;verbosity=minimal"
14 passed, 0 failed
```

This inspects the rendered WPF `ContextMenu`, nested `MenuItem` chrome, Left child-submenu
dismissal, root Escape dismissal, focus/traversal behavior, and monitor-aware custom placement hook.

Focused ribbon lane:

```text
dotnet test FreeX.RibbonTests.slnx --configuration Release --filter Category=RibbonUiLane
39 passed, 0 failed
```

## Remaining toolkit-owned details

- WPF and Avalonia still own native submenu arrows, popup animation, focus-scope timing, and final
  popup placement after the shared work-area decision.
- Avalonia's popup positioner owns the final monitor coordinate conversion and raster placement;
  `SlideX | FlipY` remains the toolkit-native edge policy.
- Native menu templates, text/icon rasterization, shadow antialiasing, and corner pixels remain
  toolkit- and platform-owned. The shared contract constrains geometry, colors, spacing, and
  interaction outcomes without replacing either toolkit's native popup template.

The slice changes only shared ribbon projects, ribbon-specific tests, and this parity note. No
FreeX, FreeW, FreeP, Docker, or integration-report files were changed.
