# FreeP Presenter Ink Custom-Show Persistence Evidence - 2026-07-05

Scope: WPF/Avalonia presenter ink retained on slideshow exit while playing a named custom show.

Evidence:
- `SlideShowInkPersistencePlanner` maps route slide indexes back to presentation slide indexes before generating retained ink package parts.
- Generated retained ink metadata records the source `Slide.Id`, optional custom-show name, playback-slide count, and repeated-source-slide occurrence index, so both hosts preserve where the ink was authored without needing a real device capture backend.
- WPF `SlideShowWindow` and Avalonia `SlideShowWindow` pass the full shared playback route into the same persistence planner during teardown.
- Repeated custom-show routes such as Appendix, Intro, Appendix produce distinct ink parts for each authored playback occurrence instead of collapsing retained strokes onto an ambiguous source slide.

Verification:
- `freep/FreeP.App.Presentation.Tests/SlideShowInkPersistencePlannerTests.cs`
- `freep/FreeP.App.Host.Tests/SlideShowTests.cs`
- `freep/FreeP.App.Avalonia.Tests/SlideShowWindowHeadlessTests.cs`

Deferred:
- Authored PowerPoint ink package baselines still require representative PPTX fixtures.
- PowerPoint-authoritative presenter UI/visual baselines still require an environment with PowerPoint automation.
- Real narration/audio capture, camera capture, and captured media persistence remain external-backend work, not a no-device shared-planner slice.
