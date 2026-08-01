# Avalonia parity Wave 93 integration

Date: 2026-08-01

## Integrated slices

- **FreeX drawing TextBox editing:** Avalonia now mounts a real multiline editor over the selected
  drawing TextBox. Double-click and insertion enter editing; Enter and Tab commit, modified Enter
  adds a line, Escape cancels, lost focus commits, and protection keeps the editor open. The editor
  stays positioned through viewport changes, coordinates with formula-bar editing, and records one
  undoable command.
- **FreeX physical TextBox evidence:** a dedicated Linux X11 lane drives the production editor with
  `xdotool`, verifies multiline commit and Escape cancellation against live model observations, and
  retains five 1280x820 screenshots under a strict JSON Schema contract.
- **Shared ribbon popups:** nested popup edge placement now uses the shared planner. Avalonia enables
  native horizontal flip and vertical slide constraints; WPF applies shared custom placement through
  `PART_Popup` when the active template exposes it.
- **FreeW portable PDF bevels:** portable and Skia output now build directional eight-band bevel
  geometry with independent horizontal and vertical depth under transforms and clips.
- **FreeW Backstage:** the Avalonia selected-content host is flush with the native Backstage layout.
  Five paired surfaces were refreshed; Open improved from 18.421% to 18.259% changed pixels.
- **FreeW Legal Notices:** tab/body joining, header inset, body width, long-document wrapping, and
  scrolling now track WPF more closely. Four 620x600 pairs improved from 19.0015% to 18.6867% mean
  changed pixels and from 21.605 to 20.623 mean perceptual difference.
- **FreeP inline math transforms:** the obsolete dormant math drawing operation was removed. Shared
  presentation, WPF, and Avalonia tests now verify real OMML content inside shape move, resize,
  rotate, and clear transform previews.
- **FreeP evidence:** the whole-window evidence fingerprint was refreshed after the shared ribbon
  source change; the generated 33-pair inventory remains current.

## Verification

- Repository preflight: **passed**, including **28/28** FreeP dialog/pane and **33/33** FreeP
  whole-window evidence checks.
- Full `Release` solution build: **0 warnings**, **0 errors**.
- Default test lane: **35,060 passed**, **133 skipped**, **0 failed**, **35,193 total** across
  **19 assemblies**.
- Shared ribbon UI lane: **40/40 passed**.
- Avalonia drawing TextBox runtime lane: **8/8 passed**.
- Drawing TextBox evidence tooling: **5/5 passed**.
- Drawing TextBox physical Linux lane: **6/6 passed**, with five **1280x820** screenshots and strict
  schema validation. Multiline Tab commit and Escape restoration matched the live model exactly.
- Serialized Linux family lanes: **85/85 passed**: FreeX **24/24**, FreeW **37/37**, and FreeP
  **24/24**. Every harness-owned container stopped.
- Dedicated FreeP multi-selection physical X11 lane: **9/9 passed**.

The broad `FreeX.UiTests.slnx` diagnostic lane is not green on the current baseline: it reported
**212 failures** (**208** FreeX WPF host and **4** FreeX WPF UI) across unrelated stale source guards,
STA-sensitive tests, localization snapshots, page-layout expectations, and other pre-existing
surfaces. Wave 93's touched ribbon and Avalonia editing gates pass independently as listed above.
This baseline debt remains visible and must be handled in a dedicated WPF UI-test convergence wave.

No machine-wide process termination or build-server shutdown was performed. The unrelated Claude
review/build session was left untouched.

## Remaining depth

- FreeW Backstage and Legal Notices still have measurable native template and text rasterization
  differences despite this wave's improvements.
- Portable PDF bevel output is a bounded approximation of native office rendering.
- WPF templates without `PART_Popup` retain toolkit-owned nested submenu edge placement.
- The broad WPF UI solution needs source-guard refresh, STA isolation, and expectation convergence
  before it can serve as a reliable all-surface release gate.
- Functional and visual parity remains an active multi-wave goal; Wave 93 closes these slices but
  does not establish codebase-wide 100% parity.
