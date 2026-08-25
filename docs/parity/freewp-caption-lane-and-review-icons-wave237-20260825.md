# FreeW/FreeP caption lane and compact Review icons — Wave 237

## Scope

This wave restores two visible Avalonia parity details without changing command behavior or adding dependencies:

- The shared sister-app title surface now has explicit QAT, caption, and native-caption-reservation lanes. The document title is centered and ellipsized only within the remaining safe lane.
- FreeW's compact Review groups retain the corresponding WPF representative icons for Proofing, Speech, Accessibility, Comments, Tracking, Changes, Compare, Protect, and Inspect.

Ink/Draw behavior and map-chart fidelity remain out of scope under [UX visual-parity scope](ux-visual-parity-scope-2026-08-25.md).

## Evidence

- FreeW canonical shell evidence was recaptured and checked: 40 paired static and 32 paired contextual captures.
- FreeP responsive chrome evidence was recaptured and checked: 64 guarded WPF/Avalonia captures across 1280, 1100, 900, and 750 DIPs.
- Visual review of the 750-DIP Avalonia captures confirms that the title is centered after the QAT and that FreeW Review's collapsed groups use distinct representative icons.

## Focused verification

- `FreeWRibbonDefinitionProfileTests.Avalonia_review_collapsed_groups_keep_their_wpf_representative_icons`: passed.
- `FreeP.App.Avalonia.Tests.MainWindowHeadlessTests.MainWindow_title_uses_the_safe_caption_lane_between_qat_and_native_buttons`: passed.
- `FreeW.App.Avalonia.Tests.MainWindowShellFrameTests.MainWindow_title_uses_the_safe_caption_lane_between_qat_and_native_buttons`: passed.
