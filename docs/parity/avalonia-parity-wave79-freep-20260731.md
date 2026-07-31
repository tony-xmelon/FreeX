# FreeP Wave 79 Avalonia transition-toggle state parity

## Candidate review

The authoritative FreeP command inventory reports 575/575 commands shared by
WPF and Avalonia, with zero actionable host-only commands. The dialog inventory
reports 20 behavior-aligned routes out of 21, with the remaining
`file.print-options` entry explicitly documented as a host-shape difference.
The Wave 78 note had already closed the last identified SmartArt pane
reachability gap. Those reports made a functional ribbon-state mismatch the
strongest remaining internal slice rather than another missing route or a
visual-only comparison issue.

## Concrete gap

WPF registered `freep.transition.advance-on-click` as a stateful command, but
its `TransitionToggleCommand` kept a private `_checked` flag. Avalonia
registered the same planner intent as a stateless `ContextRibbonCommand`.
Both hosts could mutate the undoable slide-transition model, but the Avalonia
ribbon had no checked-state contract. The WPF flag also started unchecked and
could become stale after initial load, slide navigation, or undo.

The authoritative model semantics are that `SlideTransition.AdvanceOnClick`
defaults to `true`, including when a slide has no transition object. The
checked state therefore follows the effective current slide model, not a local
click counter.

## Fix

- Added the FreeP-owned shared `PresentationTransitionCommandPlanner.IsAdvanceOnClickChecked`
  contract. It returns the model value or the PresentationML default `true`.
- Avalonia now registers the command as an `IRibbonStatefulCommand`, delegates
  execution to the existing shared planner, and synchronizes live toggle
  controls after editor mutations and current-slide changes.
- WPF now uses the same model-derived state and updates its existing
  `RibbonStateStore` on editor changes, current-slide changes, construction,
  execution, and undo.
- Added host regression coverage for initial state, toggle/model mutation,
  slide switching, and undo restoration.

## Verification

Fetched `origin/main` before finalization; it remained at
`f3b371b3072c06c50da0dafc6fed15ba7847ad9d`, with no relevant upstream change
to reconcile. Focused Release tests passed:

```text
dotnet test freep\FreeP.App.Avalonia.Tests\FreeP.App.Avalonia.Tests.csproj --configuration Release --filter "FullyQualifiedName~Ribbon_transition" --logger "console;verbosity=minimal"
Passed 2, Failed 0, Skipped 0, Total 2

dotnet test freep\FreeP.App.Host.Tests\FreeP.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~Cmd_AdvanceOnClick_StateFollowsModelDefaultSlideSwitchAndUndo|FullyQualifiedName~RibbonTransitionsAnimationsTests" --logger "console;verbosity=minimal"
Passed 118, Failed 0, Skipped 0, Total 118
```

No Docker or background test/build process was used.

## Residuals

This slice closes the Advance On Click state/undo/navigation mismatch and
intentionally improves the WPF local-state weakness to the shared model
contract. It does not claim 100% functional parity for every FreeP workflow,
or exact WPF/PowerPoint visual fidelity. The authoritative reports still list
PowerPoint COM, real recording hardware, and broader visual-baseline work as
external or residual coverage.
