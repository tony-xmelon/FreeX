# Avalonia Parity Wave110 Integration

Date: 2026-08-02

## Delivered

- FreeX Accessibility Checker now shares WPF/Avalonia dialog metrics, uses the same two-issue parity fixture and hierarchy, and aligns the tree, detail pane, selection, focus, and action row. A fresh Ubuntu 24.04 Docker/Xvfb production capture is committed at the canonical `360x520` size.
- FreeW About now shares its WPF-authority geometry and action metrics across both hosts. The same wave also completed real capture adapters for Manual Hyphenation on WPF and Caption, Character Formatting Picker, Header/Footer Text, and Manual Hyphenation on Avalonia.
- FreeW Manual Hyphenation now exposes the same Cancel/Escape result semantics on Avalonia as WPF.
- FreeP adds Grouped List SmartArt authoring, insertion, live layout, localization, ribbon routing, and WPF/Avalonia host commands. Imported Grouped List decks remain cache-backed until PowerPoint background and connector roles are modeled faithfully.

## Rendered Evidence

- FreeX remains 94/94 paired surfaces with no missing, blank, or logical-size mismatch rows. Accessibility Checker triage improved from `0.098870` to `0.084354`; its non-background delta improved from `0.035684` to `0.020812`.
- FreeW now inventories 163 route families and 478 scenarios. Fresh current-source evidence captured 190/190 WPF and 288/288 Avalonia scenarios, with zero unsupported, invalid-content, or semantic-mismatch rows. The comparison contains 28 passes, 155 genuine visual mismatches, 105 Avalonia extensions, and 7 state-not-applicable rows.
- FreeW About initial/populated changed-pixel ratios improved from `0.135369` to `0.113967`; its validation state remains a pass. All three paired Manual Hyphenation states are passes after the Cancel/Escape repair.
- FreeP command evidence is 631/631 shared-profile commands with zero actionable WPF or Avalonia gaps.

## Verification

- Focused FreeX Accessibility Checker tests passed across Avalonia, WPF, and shared presentation coverage.
- The FreeX Linux production capture completed at `360x520`, passed the nonblank/content guards, and was evaluated by the repository triage generator before promotion.
- Focused FreeW About, capture-adapter, and Manual Hyphenation behavior tests passed across both hosts. The exhaustive visual harness rendered all 478 scenarios with full and target pixel-content gates enabled.
- Focused FreeP Grouped List tests passed across presentation, WPF host, Avalonia host, and ribbon profiles; the explicit imported-cache boundary test passed.
- Generated FreeP command inventory, FreeX dialog evidence, FreeW dialog evidence, and the cross-app dashboard were regenerated from current source.

## Remaining

- FreeX next visual slice: `dialog.Options.View` at triage score `0.098637`.
- FreeW retains 155 genuine local WPF/Avalonia visual mismatches. Legal Notices long-text tabs are the largest current paired deltas, followed by Options AutoCorrect and Page Setup.
- FreeW's 105 Avalonia-extension rows have real Avalonia captures but no corresponding WPF-authority state; they remain explicit rather than being fabricated or hidden.
- FreeP still needs broader SmartArt families and PowerPoint-authoritative XML/theme/effect geometry, media, math, animation, PDF/PNG, and real-device evidence.
