# Avalonia Parity Wave 194: FreeX Mixed-Type AutoFilter

Date: 2026-08-24
Branch: codex/parity-wave194-freex-20260823
Reachable provenance source commit: ddacd9c15132fa3d3c6efc997adad8472e539432
Integration descendant: d94a20c0002f3e5dc4fbd88c3ad2634b5d0defdb
Physical capture source commit: bbcccc8237e862cebddd8fde7c4a270ee17198f8

## Result

The production Linux/X11 lane proves the mixed-type AutoFilter value workflow
through the real Avalonia popup and production Open picker. Physical lane:
**1 passed, 0 failed, 1 total**.

The deterministic column contains numeric `42`, text `"42"`, `Alpha`, a true
blank, date serial `45292` rendered as `2024-01-01`, and `7`. The rendered menu
shows one `42` checklist item. The fixed physical path clears the tri-state
Select All control, selects `42`, and commits OK.

Exact accepted postconditions:

* Popup route: Alt+Down with rendered-target readiness; header-arrow mouse fallback retained.
* Target bounds/click: `(97,589,260,18)` / `(103,598)`.
* Image deltas: open `4570`, clear `33`, select `32`, dismiss `4569`, restore `0`.
* Applied readback: `42,'42,`; semantic labels: `Number,NumericText`.
* Recalculation: `SUBTOTAL(103,A2:A7)` changed `5 -> 2`.
* Clean save: true.
* Package: `ref=A1:B7|colId=0|filters=42|blank=|hidden=4,5,6,7|A2-type=n|A2=42|A3-type=inlineStr|A3=42|A6-style=1|A6=45292|C1-formula=SUBTOTAL(103,A2:A7)|C1=2`.
* Production picker: dialog opened and closed under the app PID.
* Reopen: total `2`, readback `42,'42,`, semantic labels `Number,NumericText`.

The leading apostrophe exists only in clipboard/readback serialization for the
numeric-text cell; the retained applied/reopened screenshots render both rows
as `42`, and the model/package retain A2 numeric versus A3 inline string.

## Verification

Focused tests passed:

* Presentation Wave194 checklist ordering/dedup/display: 1/1.
* Core.IO Wave194 SourcePatch/package/reload/no-row-delta: 2/2.
* Avalonia Wave194 source/geometry/integrity guards and production recalculation: 9/9.
* Physical Docker/X11 `autofilter-mixed-type-persistence`: 1/1.

No full solution build ran. The clean accepted image is
`sha256:1abac66282eb8c8f9bef568684d364a3f1333c6df517bac2dc327aef6168d166`.
The owned port-62949 container stopped and was removed by the harness.

The later geometry-only harness refactor at reachable provenance commit `ddacd9c151`
centralizes the accepted crop `(97,589,260,18)` and click `(103,598)` without
changing their resolved values or any accepted result bytes. Executable-line
source guards and mutation tests bind every crop and the actual click to that
single geometry contract. The post-integration guards are separately bound by
matching canonical-LF worktree and `git show HEAD` hashes because they
intentionally strengthen the integrated source guard without changing the
physical harness. The target-action extractor requires unique full live start
and end delimiters before slicing, and mutation coverage proves a correct
here-document decoy cannot hide a wrong live click. The verifier also proves
`ddacd9c151` is an ancestor of `d94a20c000`; no physical rerun was required.

Earlier non-authoritative iterations failed honestly: one used wrong control
coordinates; one raced popup rendering; one isolated Select All's tri-state
cycle; one reached all UI/recalc checks but expected numeric text without the
clipboard apostrophe. No failed-attempt directories or files are part of the
accepted evidence manifest.

## Remaining Gaps

This closes the deterministic single-column mixed-type value-filter slice.
Remaining FreeX AutoFilter gaps include multi-column mixed criteria,
color-filter change/clear sequencing, broader fill/font galleries, and
Excel-paired physical evidence. Product code, the Wave193 acceptance guard,
dashboard/generator files, and cross-app acceptance files were not changed.
