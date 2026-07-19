# FreeP `Comb` transition playback parity

Date: 2026-07-19

## Change

Imported `p:comb` transitions now use the shared `Blinds` playback family in
the renderer-neutral transition planner. The existing WPF and Avalonia hosts
already consume that family through their shared horizontal/vertical bar
geometry, so `horz` and `vert` preserve their authored axis on both hosts.

The change is deliberately limited to `Comb`. `Gallery`, `Conveyor`, `Pan`,
and `Window` remain on their existing fallback path until their distinct
motion semantics have dedicated playback models.

## Source semantics

OOXML defines `comb` as a set of horizontal or vertical bars that wipe from
one end of the slide until the new slide is fully shown:

<https://ooxml.info/docs/19/19.5/19.5.30/>

This matches the existing shared bar-wipe geometry; it does not have the
incoming-only cover semantics previously used by the generic `PushLike`
fallback.

## Verification

- Presentation planner compile-first focused tests: 106/106.
- Presentation planner focused tests with `--no-build`: 106/106.
- WPF host source contract compile-first / `--no-build`: 2/2 / 2/2.
- Avalonia host source contract compile-first / `--no-build`: 3/3 / 3/3.
- No PowerPoint COM export was run for this function-only planner slice.
