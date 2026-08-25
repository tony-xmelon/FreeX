# FreeW About dialog line cadence — 2026-08-25

## Scope

This slice aligns the FreeW Avalonia About dialog's read-only document line cadence
with the same-checkout FreeW WPF authority. It changes neither About content,
semantics, button behavior, shared About defaults, nor the excluded Ink/Draw and
map-chart scopes.

## Finding and correction

Fresh 96-DPI captures showed that WPF advances the wrapped 12px About text at 16
device pixels. Avalonia's FreeW-specific 16.6-DIP line box caused the centered
document to start above WPF at the first paragraph and drift below it by the last.
FreeW now supplies a measured 16.0-DIP line height to the reusable Avalonia About
host. The correction is product-local; other products retain their existing shared
About realization settings.

## Fresh paired evidence

The WPF and Avalonia harnesses each captured all three About states at 560 x 600
pixels with passing content gates. Every state is static, so their measurements are
identical.

| State | Before changed | After changed | Before ratio | After ratio | Before mean | After mean | Before p95 | After p95 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `about.initial` | 64,147 | 58,910 | 19.0914% | 17.5327% | 19.9089 | 17.9247 | 151.6667 | 138.0000 |
| `about.populated` | 64,147 | 58,910 | 19.0914% | 17.5327% | 19.9089 | 17.9247 | 151.6667 | 138.0000 |
| `about.validation-error` | 64,147 | 58,910 | 19.0914% | 17.5327% | 19.9089 | 17.9247 | 151.6667 | 138.0000 |
| **Aggregate** | **192,441** | **176,730** | **19.0914%** | **17.5327%** | **19.9089** | **17.9247** | **151.6667** | **138.0000** |

The route removes 15,711 changed pixels (8.16%) and improves mean and p95 channel
error in every state. It remains a genuine cross-toolkit mismatch because native text
rasterization and textbox chrome still differ; no comparator threshold or
classification is weakened. The ignored capture artifacts are under
`artifacts/wave195-freew-about-current-b` and
`artifacts/wave195-freew-about-lineheight16` in the implementation worktree.

## Verification

- WPF and Avalonia dialog-harness Release builds: 0 warnings, 0 errors.
- `FreeWProductInfoTests`: 3 passed.
- Avalonia About WPF-authority contract: 1 passed.
- WPF About automation contract: 1 passed.
- FreeW visual-evidence consistency guard: passed (291 rows; 141 mismatches, 80 passes, 70 Avalonia extensions).
