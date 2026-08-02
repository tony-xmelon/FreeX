# Avalonia parity Wave111 integration (2026-08-02)

## Scope

- FreeX: align the Avalonia `dialog.Options.View` surface with the WPF authority at 744x521 logical pixels and 96 DPI.
- FreeW: align the six paired `legal-notices` dialog states with WPF while preserving tab, keyboard, and content behavior.
- FreeP: replace one admitted SmartArt preset's generic fallback with a shared live layout and preserve native package/cache boundaries.

## Starting evidence

- FreeX `dialog.Options.View`: triage score `0.098637`, sample mean delta `0.016440`, non-background delta `0.076324`.
- FreeW `legal-notices.initial` and `tab-project-license`: changed ratio `0.091022`.
- FreeW `legal-notices.tab-legal-notices`: changed ratio `0.198567`.
- FreeW `legal-notices.tab-privacy-notice`: changed ratio `0.175675`.
- FreeW `legal-notices.tab-third-party-license-texts`: changed ratio `0.199003`.
- FreeW `legal-notices.tab-third-party-notices`: changed ratio `0.195737`.
- FreeP command inventory: `643/643` shared-profile commands, with advanced SmartArt regeneration and style semantics beyond the current live-layout catalog still explicit depth work.

## Acceptance

- Production behavior and host semantics remain covered by focused tests.
- Fresh equal-size paired captures replace or refresh the relevant evidence.
- Visual metrics improve rather than merely reclassifying or suppressing a mismatch.
- FreeP's selected preset has distinct tested geometry and does not broaden live-import admission beyond the implemented cache boundary.

## Delivered

- FreeX now uses a shared `OptionsDialogParityFixture` for WPF and Avalonia capture routes while normal launches remain backed by their persisted option stores. The Avalonia dialog uses explicit body/footer rows, WPF-aligned View spacing, and deterministic category-row rasterization.
- FreeW Legal Notices now aligns the Avalonia selected-tab frame, focused read-only document border, and document-host inset with the shared WPF authority while preserving its text origin, scrollbar lane, keyboard lifecycle, and automation semantics.
- FreeP `BasicHierarchy` no longer falls through to generic hierarchy geometry. The shared engine emits dedicated root, branch, leaf, and parent-child connector roles; WPF and Avalonia remain thin consumers of the shared plan.

## Fresh evidence

- FreeX `dialog.Options.View`: triage score `0.014174`, sample mean delta `0.008832`, non-background delta `0.003999`; the targeted normalized pixel difference is `1.153%`.
- FreeW `legal-notices.initial` and `tab-project-license`: changed ratio `0.089785`.
- FreeW `legal-notices.tab-legal-notices`: changed ratio `0.182777`.
- FreeW `legal-notices.tab-privacy-notice`: changed ratio `0.165145`.
- FreeW `legal-notices.tab-third-party-license-texts`: changed ratio `0.185226`.
- FreeW `legal-notices.tab-third-party-notices`: changed ratio `0.179952`.
- FreeP focused evidence proves dedicated Basic Hierarchy geometry, cache regeneration, live PPTX composition, and WPF/Avalonia command reachability without admitting unsupported hierarchy siblings.
- The regenerated FreeP command inventory is `644/644` shared-profile commands with zero actionable WPF or Avalonia gaps.

## Focused verification

- FreeX: 37 shared-service Options tests, 11 Avalonia Options tests, and 47 WPF Options tests passed.
- FreeW: 11 Avalonia Legal Notices tests and 9 WPF Help/Legal Notices tests passed; fresh focused capture produced 6/6 WPF and 6/6 Avalonia rows with no semantic mismatch.
- FreeP: 5 presentation Basic Hierarchy tests and 2 WPF host tests passed; existing Avalonia command-profile coverage remains shared with WPF.

## Remaining

- FreeX `Options.View` retains platform text and checkbox rasterization differences; the next highest FreeX paired outlier is `dialog.Options.EaseOfAccess` at `0.097761`.
- FreeW Legal Notices remains a genuine visual mismatch because native tab, scrollbar, and glyph rasterization differ. Other FreeW dialog rows still require visual alignment.
- FreeP still needs richer hierarchy roles, broader native SmartArt layout/style semantics, and PowerPoint-authoritative visual baselines.
