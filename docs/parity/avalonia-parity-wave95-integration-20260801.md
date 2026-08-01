# Avalonia parity Wave 95 integration

Date: 2026-08-01

## Integrated slices

- **FreeX threaded comments:** the Avalonia comment list now uses WPF-like Cell/Text columns,
  stable typed rows, and in-place collection refresh so an open list remains current after comment
  mutations while retaining navigation and automation behavior.
- **FreeW Options:** the Avalonia dialog now follows WPF width, action sizing, initial focus,
  AutoCorrect two-column layout, trailing replacement row, and scrollable constrained content.
- **FreeW Borders and Shading:** compact control metrics, automation metadata, invalid-width
  lifecycle, Escape behavior, initial focus, and tab-specific focus now follow WPF across all three
  tabs. WPF changes are limited to matching automation metadata.
- **FreeW physical evidence:** the reusable Linux family contract expands from 37 to 45 rows with
  real-input Backstage Print, Export, and Options workflows. The final probe derives client
  geometry from the live window, clicks the rendered rail/action controls, and fail-closes on
  window, focus, screenshot, or owner-restoration drift.
- **FreeP nested RTF tables:** shared model, parser, cloning/equality, rich clipboard codec, and
  WPF/Avalonia inline renderers now preserve cell margins and `trql`/`trqc`/`trqr` row placement.
  Omitted alignment remains left by default.
- **Concurrent mainline work:** the branch includes the incoming FreeW PDF italic/font-family and
  cleared Word tab-stop fixes before final validation.

## Focused verification

- FreeX threaded-comment runtime: **12/12 passed**.
- FreeW Options visual parity: **5/5 passed**.
- FreeW Borders and Shading: Avalonia **5/5**, shared planner **10/10**, and WPF guard **1/1**.
- FreeW family tool contract: **10/10 passed**.
- FreeP RTF alignment/margin lanes: presentation **73/73**, Avalonia planner **6/6**, and WPF
  consumer **1/1**.
- Fresh Borders and Shading captures passed the content gate for **6/6 WPF** and **6/6 Avalonia**
  states with zero semantic differences. Changed pixels improved on every state: 11.52% to 11.28%
  for initial/populated/Borders, 15.16% to 14.15% Page Border, 8.20% to 7.08% Shading, and 11.64%
  to 11.38% validation. All six remain honest native-rendering visual mismatches.

## Broad verification

- Repository preflight: **passed** after refreshing the expected FreeP whole-window renderer
  fingerprint.
- Full Release solution build: **98 projects**, **0 warnings**, **0 errors**.
- Serialized default lane: **35,081 passed**, **133 skipped**, **0 failed**, **35,214 total** across
  19 test assemblies. The first parallel invocation left the FreeP Avalonia renderer testhost idle;
  that assembly passed **210/210** independently, the owned four-process tree was stopped, and the
  complete one-worker rerun passed without source changes.
- Serialized Linux physical lanes: **93/93 passed**: FreeX **24/24**, FreeW **45/45**, and FreeP
  **24/24**. Every manifest contract passed and every harness-owned container stopped.

## Remaining depth

- FreeW still has 167 genuine visual mismatches in the tracked all-dialog report. The refreshed
  Borders and Shading route improves six of them but does not cross the visual-pass thresholds.
- Native Avalonia/WPF control templates and text rasterization still account for visible dialog
  differences; broader authoritative Microsoft Word baselines remain outside this managed pass.
- FreeP row alignment covers bounded nested RTF layout. Complex mixed-width/provider-specific RTF,
  native Word visual baselines, external PowerPoint rendering, and hardware/media paths remain.
- FreeX functional inventories are green, but the portable threaded-comment list is still a close
  reconstruction rather than a shared WPF `GridView` control.

No machine-wide process termination or build-server shutdown was performed. The only terminated
processes were the verified Wave95-owned default-test root, MSBuild node, vstest console, and
testhost after the parallel suite remained idle for roughly fourteen minutes. Unrelated review and
build sessions were not touched.
