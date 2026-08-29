# Wave 199 Cross-App Acceptance Refresh

Date: 2026-08-29
Tested production/integration source: `d25a66612cb89827ad99ad7694e29a72b5984f7a`
Final pre-dashboard integration source: `fb56a0f16e1b6be4703a96b87a118d1de1c3bf4b`
Status: accepted local gates

## Scope

Wave 199 records three app slices, one each for FreeX, FreeW, and FreeP. Cumulative accounting is **597 app slices (199 per app)**. This six-file acceptance refresh changes dashboard tooling, guards, generated outputs, and this integration note only. It preserves Wave198 and its complete nested Wave197 acceptance history and does not claim complete Avalonia/WPF parity.

The final independent review of the Wave199 evidence found **no P1/P2 findings**.

## App Evidence

- **FreeX:** No production change was retained. Automatic worksheet focus failed physical Linux/X11 and stayed on A1; explicit worksheet reselect worked. Save/persistence failed with `style-id=0|font-id=0|font-name=Calibri|font-family=false` and `save-clean=false`. The bundle contains 15 canonical auditable evidence files; focused tests passed 8/8.
- **FreeW:** Only WPF visual-capture hardening was retained: 50 ms polling, a 15 second timeout, and owned-modal close on timeout. The width candidate was rejected: initial 7.6030% -> 13.3183%, populated 7.7021% -> 13.4134%, validation 7.6030% -> 13.3183%. All pixel/luminance/phash metrics are independently recomputed from 32 artifacts. Canonical counts remain 291 surfaces / 141 mismatches / 80 pass / 70 Avalonia extensions. Focused evidence passed 2/2 and host guards passed 3/3.
- **FreeP:** No production renderer change was retained; Aptos substitutes were rejected. Twelve candidate PNGs and 30 pixel metrics are independently recomputed with exact index/hash binding. Candidate/native-Aptos provenance and broader-corpus claims are explicitly not proven; 18 Office references are inventoried only. Focused tests passed 10/10.

## Local Integration Gates

| Gate | Exact source | Status | Result |
|---|---|---|---|
| Full Release build | `d25a66612cb89827ad99ad7694e29a72b5984f7a` | **passed** | Standard `--no-restore`/disabled-build-servers/`-m:1` command passed with 0 warnings and 0 errors; elapsed 00:33:04.79. |
| Repository preflight | `fb56a0f16e1b6be4703a96b87a118d1de1c3bf4b` | **passed** | Mode All passed: portability checked 17,470 tracked paths; conflict-marker scan checked 14,175 text files; generated docs and all remaining checks passed. |

After the Release build, generated-evidence-only remediations refreshed the FreeW shell visual, design-dialog, mail-merge, and shell-platform fingerprints, producing the final pre-dashboard source above. The manifest-driven integration suite and UI/render/release workflow are delegated GitHub gates; they were **not run locally** and are not claimed as run. Exactly six dashboard/report paths are allowlisted after the final pre-dashboard integration boundary.
