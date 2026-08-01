# Avalonia parity Wave 96 integration

Date: 2026-08-01

## Integrated slices

- **FreeX physical Group/Outline:** the Linux interaction contract now seeds a real worksheet,
  selects rows through X11 input, invokes Data > Group through production key tips, verifies the
  rendered outline gutter, physically collapses and expands the group, and reads the seeded values
  back. The probe is available as `outline-group` and is required by the default FreeX lane.
- **FreeW Bookmark Manager:** WPF and Avalonia now share aligned dialog geometry, metrics, focus,
  automation metadata, and real populated route states. Fresh initial, populated, and validation
  captures pass the route comparison with zero semantic differences.
- **FreeP SmartArt `verticalBlockList`:** imported diagrams now use the shared editable live-layout
  path instead of the cached drawing fallback. The renderer-neutral plan emits ordered rectangular
  blocks with bounded level indentation and is consumed by both WPF and Avalonia.
- **Concurrent mainline work:** the branch includes the incoming FreeP authoring and FreeW document,
  PDF, and line-numbering changes before final build and evidence validation. Integration also
  completed the incoming `List2` insertion-factory mapping, updated the core-property dedup guard
  for FreeW's current shared API, and made drawing-anchor hang probes immune to thread-pool starvation.

## Focused verification

- FreeX Linux interaction source contracts: **9/9 passed**.
- FreeX focused physical Group/Outline route: **1/1 passed**.
- FreeP SmartArt coverage: presentation **190**, WPF host **222**, and Avalonia **24** focused tests
  passed after integration.
- FreeW Bookmark Manager parity: **3/3 passed**.
- Fresh Bookmark Manager captures: **3/3 WPF**, **3/3 Avalonia**, and **3/3 comparisons passed**.
  Changed-pixel ratios were 2.8863% for initial and 2.7393% for populated and validation-error;
  all three had zero semantic differences.

## Broad verification

- Repository preflight: **passed** after refreshing the expected cross-app dashboard, FreeW command
  inventory, and FreeP whole-window renderer fingerprint.
- Full post-merge Release solution build: **0 warnings**, **0 errors**.
- Serialized post-merge default lane: **35,098 passed**, **133 skipped**, **0 failed**, **35,231
  total** across 19 assemblies after focused correction and complete affected-assembly reruns. The
  initial pass exposed two missing `List2` insertion mappings, one stale shared-core-property source
  guard, and one drawing-anchor timeout whose `Task.Run` work could be starved behind the timer.
  The fixed FreeP presentation assembly passed **3,245/3,245**; the fixed Core IO assembly passed
  **5,115/5,115** with **56** intentional skips.
- Serialized Linux physical lanes: **94/94 passed**: FreeX **25/25**, FreeW **45/45**, and FreeP
  **24/24**. Every manifest contract passed and every harness-owned container stopped.

## Remaining depth

- The tracked canonical FreeW all-dialog bundle still reports 167 visual mismatches until that full
  generated bundle is refreshed. The fresh Bookmark Manager route removes its three route-specific
  mismatches locally but does not rewrite the canonical bundle.
- FreeP `verticalBlockList` is a bounded shared approximation. Exact PowerPoint padding, effects,
  theme geometry, native data-part regeneration, and a PowerPoint-authoritative raster baseline
  remain separate work.
- FreeX Group/Outline physical evidence covers one-level row grouping. Nested groups, column groups,
  filtered-range behavior, save/reopen persistence, and paired WPF screenshots remain.

No machine-wide process termination or build-server shutdown was performed. Docker execution was
serialized, and only Wave 96 containers, worktrees, branches, and temporary publish data are in the
cleanup scope.
