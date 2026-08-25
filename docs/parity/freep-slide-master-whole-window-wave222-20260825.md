# FreeP Slide Master whole-window evidence — Wave 222 (2026-08-25)

FreeP now covers the active **Slide Master** surface in the whole-window visual-evidence catalog, not just the View-ribbon command that exposes it.

- Added `workspace.slide-master`, activated through the real View-ribbon command in both WPF and Avalonia.
- The scenario proves that the master canvas is live and that the master/layout target pane is populated.
- Fixed the WPF evidence route to wait for the selected View tab to realize before invoking Slide Master.
- Fixed an Avalonia master-target selection re-entry that could clear the target collection while its selection model was enumerating it.
- Both hosts now hide the normal Notes pane in Slide Master mode; focused WPF and Avalonia regression tests cover that behavior.

The whole-window collection was stale: it represented 33 scenarios although the catalog had already declared 35. The refreshed catalog now contains **36** scenarios: the two omitted standard tabs (Slide Show and Review) plus the active Slide Master workspace. The refreshed capture run completed 36/36 paired scenarios with zero capture limitations; the generated artifact manifest is current.

The report still deliberately records cross-host visual discrepancies (not capture failures), principally app-owned title-bar raster treatment, Backstage ribbon/contextual-tab metadata, and one rich-editor selection geometry route. The new Slide Master pair has only the existing title-bar-raster classification and passes its semantic route assertion in both hosts. This is evidence of backed functionality and comparable host coverage, not a claim of PowerPoint pixel parity.

Ink/Draw behavior and map-chart fidelity remain explicitly out of scope under [UX visual-parity scope](ux-visual-parity-scope-2026-08-25.md).
