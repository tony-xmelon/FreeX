# FreeP Crawl Animation Playback Slice - 2026-07-05

This slice advances FreeP slideshow animation playback parity by adding a PowerPoint-style Crawl approximation for imported preset animations.

## Scope

- `SlideShowPlaybackPlanner` maps `AnimationPreset.Crawl` to a renderer-neutral `SlideShowShapeAnimationEffectKind.Crawl` plan.
- The shared plan carries deterministic direction-derived offset factors, duration, delay, and reveal timing for entrance and exit playback.
- WPF and Avalonia slideshow hosts consume the shared plan through thin `CrawlEffect` adapters over the same slide-sized translate-and-clip primitive used for Peek.
- Focused planner and host source tests cover the shared plan and both renderer adapters.

## Limits

- Crawl playback remains a deterministic translation/reveal approximation until PowerPoint COM visual baselines are available on a COM-capable machine.
- Broader advanced preset playback coverage beyond the current Box, Blinds, Checkerboard, Circle, Crawl, Diamond, Peek, Plus, Strips, Wedge, and Wheel slices remains incremental.
