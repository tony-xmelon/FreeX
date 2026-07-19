# FreeP Flash Transition Playback

## Scope

PresentationML `p14:flash` was previously reduced to the generic fade action
even though the model and writer preserved `TransitionKind.Flash`. The shared
transition planner now retains Flash as a renderer-neutral action. WPF and
Avalonia both execute it with the same layer contract: the incoming slide is
prepared underneath, the outgoing snapshot fades away, and a white surface
peaks once before the incoming slide is left visible.

This is a functional playback improvement and keeps the platform hosts aligned;
it does not alter static slide rendering or package serialization.

## Verification

- `FreeP.App.Presentation.Tests` focused slideshow planner tests: **107/107**.
- WPF `SlideShowHostPolicySourceTests` plus `TransitionCompletenessTests`: **122/122**.
- Avalonia `SlideShowHostPolicySourceTests`: **3/3**.
- WPF and Avalonia Release host builds: **0 warnings, 0 errors**.

## Boundary

The white-flash path is deterministic and distinct from fade, but exact
PowerPoint timing, peak duration, and easing still require frame-by-frame
PowerPoint playback capture. The static RenderCompare corpus does not measure
transition frames.
