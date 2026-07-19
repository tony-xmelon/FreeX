# FreeP Fly Transition Playback

## Scope

FreeP's transition model exposes `TransitionKind.Fly`, but PresentationML has no
standard `p:fly` transition element. The package writer therefore serializes
Fly as `p:push`. The shared slideshow planner now follows that serialized
representation and selects renderer-neutral Push playback instead of the prior
fade fallback.

Both WPF and Avalonia already consume the shared Push action, so this keeps the
two hosts aligned without introducing a platform-specific animation path.

## Verification

- `FreeP.App.Presentation.Tests` focused slideshow planner tests: 107/107.
- `TransitionCompletenessTests`: 120/120.
- Presentation test project Release build: 0 warnings, 0 errors.
- This is a function/serialization parity change; no new PowerPoint COM capture
  was required. Existing visual baselines are unchanged because the control
  deck does not use Fly.

## Remaining Boundary

Transitions that have no shared compositor implementation still use their
existing fallback or authoring-only behavior. Those require separate evidence
and should not be inferred from the Push mapping above.
