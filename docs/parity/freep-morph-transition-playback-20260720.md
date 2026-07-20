# FreeP Morph Transition Playback

## Scope

FreeP now routes `TransitionKind.Morph` through a dedicated shared playback
action consumed by both WPF and Avalonia. The shared Morph planner matches
top-level slide objects by stable shape id first, then by a unique normalized
shape name. Matched incoming objects are rendered through the existing
per-shape overlay path and interpolate from the outgoing object's bounds to
their target bounds while the slide snapshot fades out.

The authored `MorphOption` (`byObject`, `byWord`, or `byChar`) is preserved and
reported by the shared plan. `byWord` and `byChar` now add a conservative
unique-text-overlap correspondence pass after stable id/name matching, so
PowerPoint-style regenerated shape ids can still find a text object without
guessing through ties. The hosts consume these matches through the existing
overlay path; word- and character-level token interpolation inside a matched
shape remains a later fidelity slice. Ambiguous names, tied text candidates,
and slides without a usable object match use the existing fade path.

## Verification

- Focused `SlideShowPlaybackPlannerTests`: **70/70**.
- Focused WPF host policy and transition contracts: **129/129**.
- Focused Avalonia host policy and transition contracts: **3/3**.
- Full Presentation tests: **2186/2187**; the one failure is the existing
  Print deferred-action expectation in
  `PresentationFileDialogPlannerTests.ExportPlanner_DefinesSharedBackstageAndCommandDescriptors`.
- WPF and Avalonia Release host builds completed successfully as part of the
  focused test commands.

No new PowerPoint frame capture was available for this slice. The remaining
visual boundary is exact PowerPoint Morph matching, text token interpolation,
group-child correspondence, and PowerPoint-authenticated frame baselines.
