# FreeP Morph Transition Playback

## Scope

FreeP now routes `TransitionKind.Morph` through a dedicated shared playback
action consumed by both WPF and Avalonia. The shared Morph planner matches
top-level slide objects by stable shape id first, then by a unique normalized
shape name. Matched incoming objects are rendered through the existing
per-shape overlay path and interpolate from the outgoing object's bounds to
their target bounds while the slide snapshot fades out.

The authored `MorphOption` (`byObject`, `byWord`, or `byChar`) is preserved and
reported by the shared plan. The current renderer implementation uses the
object correspondence for all three options; word- and character-level text
token interpolation remains a later fidelity slice. Ambiguous names and slides
without a usable object match use the existing fade path rather than guessing
identity.

## Verification

- `SlideShowPlaybackPlannerTests`: **46/46**.
- WPF `SlideShowHostPolicySourceTests`: **1/1**.
- Avalonia `SlideShowHostPolicySourceTests`: **1/1**.
- `TransitionCompletenessTests`: **120/120**.
- WPF Release host build: **0 warnings, 0 errors**.
- Avalonia Release host build: **0 warnings, 0 errors**.

No new PowerPoint frame capture was available for this slice. The remaining
visual boundary is exact PowerPoint Morph matching, text token interpolation,
group-child correspondence, and PowerPoint-authenticated frame baselines.
