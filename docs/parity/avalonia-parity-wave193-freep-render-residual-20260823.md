# FreeP Wave193 deck17 slide02 render residual

Date: 2026-08-23

Branch: `codex/parity-wave193-freep-20260823`

Static-analysis base: `7be852a085b51e22ef48e4de28eacbb38415c996`

Retained measurement baseline: Wave192 evidence at
`docs/parity/evidence/avalonia-parity-wave192-freep-evidence-20260823/`

## Decision

No runtime rendering change is retained in Wave193. The next executable
existing-corpus residual is `17-bullets-autofit` slide 02 at `2.5360%`
Avalonia/Office and `2.9091%` WPF/Avalonia, with WPF/Office at `3.0587%`.

Static inspection identifies the residual as host font/raster variation, not
an incorrect shared text or autofit semantic. The target slide's body shape is
an explicit `a:noAutofit` text box containing eight one-run paragraphs. Each
run inherits the 18pt theme-body Aptos family from the slide master; there is
no stored `fontScale`, line-spacing override, bullet, column, or shape-growth
request. The title is a separate 28pt Aptos Display run.

The accepted Avalonia route already applies the corpus-supported host policy
to fixed-size, single-column, no-autofit, non-bullet Aptos text: Arial fallback,
the measured `0.930` scale, grayscale-like antialiasing, disabled hinting, and
unaligned baseline pixels. WPF keeps its independently measured Aptos fallback
policy. Both consume the same compositor and text planner.

## Static probes

The retained Wave177/Wave182/Wave185 evidence rejects the available general
corrections:

| Probe | Target result | Control / pair result | Decision |
| --- | ---: | ---: | --- |
| Port WPF Light/1.016-width paint policy to Avalonia | 3.6208% Avalonia/Office | 3.3449% WPF/Avalonia | Reject |
| Remove Light weight but keep width scale | 3.6209% Avalonia/Office | Not improved | Reject |
| Change fixed no-autofit line spacing 1.20 to 1.21 | 3.5344% Avalonia/Office | Not improved | Reject |
| Map Aptos to Calibri at 1.0 | 3.9395% Avalonia/Office | 1.0304% slide01 control | Reject |
| WPF-only Aptos-to-Arial substitution | 4.8240% WPF/Office | 1.0498% slide01 control | Reject |
| WPF vertical raster, display metrics, and centered-height probes | 3.3828%-3.8637% WPF/Office | Slide01 controls stable | Reject |

These probes change host typography or draw-time geometry and do not provide a
corpus-wide improvement. No fixture name, visible string, screenshot hash, or
corpus-only coordinate is introduced.

## Retained metrics

Fresh Wave193 current-source renders reproduce the Wave192 measured baseline:

| Aggregate | Average | Maximum slide residual |
| --- | ---: | ---: |
| WPF vs Office | 1.0309% | 3.0587% |
| Avalonia vs Office | 0.9962% | 2.5815% |
| WPF vs Avalonia | 0.6097% | 2.9091% |

The target row is retained as `3.0587% / 2.5360% / 2.9091%` for WPF/Office,
Avalonia/Office, and WPF/Avalonia. All 53 row-level comparisons and channel
maxima are exactly equal to Wave192. Avalonia remains better than WPF against
Office by `0.0347` percentage points on the corpus average.

Machine-readable metrics, the target Office/WPF/Avalonia images, all three
target heatmaps, SHA-256 hashes, Office-reference provenance, and the retained
integrity check are under
`docs/parity/evidence/avalonia-parity-wave193-freep-evidence-20260823/`.

## Verification

- `FreeP.RenderCompare` Release build: 0 warnings, 0 errors.
- Focused Avalonia Aptos raster and line-spacing policy tests: 22/22 passed.
- Focused presentation bullets/autofit and text-layout tests: 130/130 passed.
- Full `FreeP.RenderCompare.Tests`: 88/88 passed.
- Full corpus: 106/106 WPF/Avalonia renders and 159/159 Office/pair diffs.
- Wave193 retained integrity: 53 unique rows across 27 decks / 53 slides,
  recomputed aggregates and maxima, exact Wave192 row equality, Avalonia's
  better-than-WPF aggregate, 53/53 Office reference hashes and dimensions, and
  6/6 retained image hashes and dimensions.
- PowerPoint COM was not needed; the unchanged committed Office PNGs remain the
  authority.

## Evidence boundary

The retained bundle proves the current-source render count, all 159 rounded
row metrics, exact equality with Wave192, aggregate values, reference mapping,
and the six target PNG hashes. It does not claim a new Office export or a
runtime improvement. The generated non-target WPF/Avalonia PNGs remain ignored
work artifacts and are not required by the retained integrity check.
