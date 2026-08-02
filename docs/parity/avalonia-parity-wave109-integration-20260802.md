# Avalonia Parity Wave109 Integration

Date: 2026-08-02

## Delivered

- FreeX Format Cells Border now resizes its actual X11 client instead of padding an undersized capture. Its layout follows the WPF control geometry for presets, line styles, preview, per-edge details, and actions. Fresh Linux evidence reduced triage from `0.098981` to `0.032791`.
- FreeW Style dialog now shares the WPF layout metrics for combo fields, checkbox rows, and action buttons. The three paired states fell from roughly 7.7%-7.9% changed pixels to 3.8%-3.9%.
- FreeP adds the `increasingCircleProcess` SmartArt family through shared authoring, insertion, layout, localization, and ribbon contracts consumed by both hosts. Imported PowerPoint decks retain their authoritative cached drawing until the live layout also models PowerPoint's background-role geometry.

## Generated Evidence

- FreeX: 94/94 paired surfaces, zero missing or blank captures, zero scale-aware dimension mismatches, and exact `620x597` Format Cells Border evidence. The highest remaining triage score is `0.098870` for `dialog.AccessibilityChecker`.
- FreeW: 183 paired rendered rows, with 20 passes and 163 genuine visual mismatches. Word-authoritative PNG baselines remain unavailable in the current inputs.
- FreeP: 625/625 shared-profile commands with zero actionable host gaps after the final upstream sync. Dialog/pane evidence remains 28/28 pass and whole-window evidence remains 33/33 paired with zero explicit product mismatches.

## Verification

- Focused FreeX Format Cells coverage: 29/29 passed.
- Linux production capture: complete `620x597` Format Cells Border client with Top, Right, Bottom, Left, OK, and Cancel visible and no padded rows.
- Focused FreeW Style coverage: 11/11 passed across Avalonia and shared presentation tests.
- Focused FreeP SmartArt/ribbon coverage: 944/944 passed across presentation, WPF host, Avalonia host, and ribbon-profile suites.
- The first default-lane run caught one imported SmartArt cache-boundary regression. After repair, FreeP presentation passed 3,389/3,389, WPF host passed 1,920/1,920, and Avalonia host passed 557/557; the unchanged FreeX Avalonia project had already passed 1,952/1,952 in the first run.
- Full Release solution build passed with zero warnings and zero errors before and after the regression repair.
- Repository preflight passed after refreshing the generated FreeP whole-window manifest.
- After merging 48 upstream commits, the affected focused suites passed 1,063/1,063, repository preflight passed, and the full 89-project Release build again completed with zero warnings and zero errors.

## Remaining

- FreeX next visual slice: `dialog.AccessibilityChecker`.
- FreeW retains 163 genuine local WPF/Avalonia visual mismatches and still needs Word-authoritative PNG baselines on a Word-capable host.
- FreeP still needs broader PowerPoint-authoritative SmartArt XML, theme/effect geometry, and real-deck/media/math evidence.
