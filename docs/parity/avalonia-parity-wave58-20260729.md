# Avalonia parity Wave 58

Date: 2026-07-29

## Functional and evidence slices

- **FreeX** now has a dedicated physical Linux/X11 probe for 3-D formula
  point entry. The probe creates Sheet2 and Sheet3 through the production
  sheet-tab UI, enters `=SUM(Sheet2:Sheet3!B2)` through formula-bar point
  mode, verifies the formula on Sheet1, and verifies the calculated value
  `30`. The focused probe passed 1/1; the unchanged full physical lane passed
  24/24 and the managed interaction report passed 705/705.
- **FreeW** now routes 38 compact-dialog font declarations in 27 Avalonia
  source files through the shared Windows-authority dialog style. A shared
  Avalonia button-row factory also owns OK/Cancel order, spacing,
  default/cancel semantics, and automation names. The checked-in visual
  comparison remains 171 genuine mismatches until fresh paired captures are
  generated; this wave does not relabel or claim pixel improvements without
  image evidence.
- **FreeP** now has an operating-system AT-SPI accessibility lane for five
  representative live panes. The retained Linux run proves exact pane names
  and roles for Slides (`list`), Notes (`entry`), Comments (`panel`),
  Selection Pane (`panel`), and Animation Pane (`panel`). A companion
  live-control manifest verifies the same five panes' automation IDs, names,
  help text, host roles, state, and values.

## Integration review

- The FreeX probe was kept as a focused selector so its two added sheets do
  not perturb the existing sheet-tab lane's fresh-workbook coordinates. It
  also returns to Sheet1 before reading G10, avoiding a false read from the
  Sheet3 visible at commit time.
- The FreeW source normalization is recorded as a real shared-style and
  deduplication change, while the generated mismatch count remains unchanged
  because the paired capture payloads are not available in the repository.
- The first FreeP AT-SPI run matched a same-named `Slides` label. That result
  was rejected. The final probe requires exact target names and
  target-specific roles, includes the live slide-pane list in its manifest,
  and copies the branch-local probe into the container so a cached image
  cannot execute an older matcher.
- Six concurrent FreeP clipboard/OLE commits from `origin/main` were merged
  before the accessibility slice, with no conflict or lost upstream work.
  The final integration tip was then reconciled with the later FreeP
  clipboard, table-layout, and text-column work before the all-up gates.
- A still-later upstream video-capability merge introduced a deterministic
  no-device status-text regression. The integration review corrected the
  missing narration/camera wording; its 7 focused tests and the complete
  1,797-test FreeP host assembly pass.

## Focused verification

- FreeW integrated dialog-chrome tests: 23 passed.
- FreeX integrated Avalonia interaction source tests: 8 passed.
- FreeX focused physical 3-D probe: 1 passed, 0 failed.
- FreeX full physical X11 lane: 24 passed, 0 failed.
- FreeX managed interaction report: 705 passed, 0 failed.
- FreeP integrated accessibility tests: 6 passed.
- FreeP retained accessibility run: 5 live controls and 5 AT-SPI pane
  observations passed at 1280x820 and 96 DPI.

## Remaining work

- FreeW needs fresh paired WPF/Avalonia captures to quantify the typography
  and button-row change, followed by further work on the remaining 171
  checked-in genuine visual mismatch scenarios.
- FreeP's AT-SPI lane proves names, roles, states, and value fields. It does
  not certify screen-reader announcement order, and AT-SPI does not expose
  Avalonia automation IDs or help text in this run.
- Cross-app visual parity still needs authoritative Office comparisons for
  surfaces where current evidence proves WPF/Avalonia pairing but not exact
  Office pixel fidelity.

## Final verification

- Generated-document checks passed, including 33/33 paired FreeP
  whole-window scenarios and 28/28 FreeP dialog/pane scenarios.
- Repository preflight passed: 204 JSON files, 258 XML-backed files, 71
  PowerShell scripts, 9 workflows, 122 project files, and all generated-doc
  and conflict-marker checks.
- `dotnet build FreeX.slnx --configuration Release` passed with 0 warnings
  and 0 errors.
- The serialized default test solution passed across 19 assemblies: 33,180
  passed, 0 failed, and 133 intentionally not executed. The first final-tip
  run had one transient system-clipboard null read in an unchanged FreeX
  test; that exact test, its complete 1,456-test assembly, and the subsequent
  full default solution rerun all passed. After the final upstream merge, the
  two affected complete assemblies also passed: FreeP Host 1,797/1,797 and
  shared app-services 2,453/2,453.
- Final physical Linux/X11 lanes passed: FreeX 24/24, FreeW 37/37, and FreeP
  24/24. The final-tip FreeP family evidence is under
  `artifacts/linux-family-interactive-wave58-final-tip/freep/`.
- The final-tip FreeP accessibility lane passed with 5/5 live controls and
  5/5 exact OS AT-SPI observations. The retained roles are Slides=`list`,
  Notes=`entry`, Comments=`panel`, Selection Pane=`panel`, and Animation
  Pane=`panel`.
