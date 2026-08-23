# Avalonia Parity Wave 192: FreeW Font Checkbox Raster Tail

Date: 2026-08-23
Scope: FreeW Avalonia Font dialog, `initial`, `populated`, and `validation-error` states at the existing 460 x 340 logical target
Authority: fresh FreeW WPF `FontDialog` captures

## Finding

Fresh current-source captures retained the Wave191 Font combo correction but showed a route-local
checkbox/effect-lane registration tail. Avalonia's first effect indicator began one device pixel
left of WPF, and native text-width differences accumulated one-pixel offsets at the ends of the
first two wrapped effect rows. The WPF and Avalonia painted bounds were already exact at `421 x 321`
in every state.

## Correction

The production Avalonia Font realization now applies one pixel to the complete effects lane rather
than adding it independently to every wrapped checkbox. The Underline and Small Caps controls use
measured `-1` and `+1` DIP trailing-margin corrections so the first two effect rows keep the WPF
indicator registration without changing the third row. The shared checkbox template, WPF renderer,
shared planner semantics, validation behavior, and other compact dialogs are unchanged.

## Fresh paired evidence

Fresh WPF and Avalonia route captures were produced from this checkout after the correction. Both
hosts captured `3/3` states at `460 x 383` capture pixels, with exact WPF/Avalonia painted bounds of
`421 x 321` in every state.

| State | Before changed | After changed | Before ratio | After ratio | Before mean | After mean | Bounds |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| `font.initial` | 11,846 | 11,227 | 6.723805% | 6.372460% | 6.649145 | 5.956490 | WPF/AV `421 x 321` / `421 x 321` |
| `font.populated` | 12,003 | 11,384 | 6.812919% | 6.461573% | 6.737293 | 6.044638 | WPF/AV `421 x 321` / `421 x 321` |
| `font.validation-error` | 12,204 | 11,585 | 6.927006% | 6.575661% | 6.891931 | 6.199275 | WPF/AV `421 x 321` / `421 x 321` |
| **Aggregate** | **36,053** | **34,196** | **6.821243%** | **6.469898%** | **6.759456** | **6.066801** | **exact painted bounds** |

The accepted change removes `1,857` changed pixels, a `5.1508%` relative reduction, and lowers
the mean channel delta by `0.692655` in the aggregate. Every affected state improves in both
changed pixels and mean channel delta. The rows remain `genuine-visual-mismatch` because native
WPF/Avalonia glyph and control rasterization still differs.

## Evidence and verification

- Fresh WPF route capture: `3/3` captured and content-gated.
- Fresh Avalonia route capture: `3/3` captured and content-gated.
- Canonical refresh used `--baseline` plus `--refresh-route font`.
- Canonical inventory: `180` routes and `512` scenarios; `inventory --check` passed.
- Canonical comparison: `221` WPF captures, `291` Avalonia captures, `291` rows; `comparison --check` passed.
- Canonical classifications remained `141` genuine mismatches, `80` passes, and `70` Avalonia extensions.
- An explicit pre/post row comparison confirmed all `288` non-Font rows are structurally identical;
  only `font.initial`, `font.populated`, and `font.validation-error` changed.
- Focused `FontDialogPlannerTests` plus `DialogTextRasterizationPolicyTests`: `35/35` passed.
- Focused `FontDialogVisualParityTests` plus `FontDialogPolicySourceGuardTests`: `6/6` passed.
- FreeW evidence consistency guard: passed for `291` rows.

## Repository-backed provenance

The prior `freew_dialog_visual_freshness.json` sidecar authenticated only opaque hashes for
externally supplied WPF and Avalonia capture manifests. Wave192 now includes the compact
`docs/parity/freew-dialog-harness/freew_font_visual_provenance.json` bundle. It binds each of the
three WPF/Avalonia state pairs to its host, state, `460 x 383` capture dimensions, `421 x 321`
painted bounds, exact comparison-row JSON pointer and SHA-256, source revision and source-file
hashes, and the host-manifest SHA-256. `tools/Test-FreeWFontVisualProvenance.ps1` verifies those
bindings and fails on stale or mismatched tracked evidence; it passed with `3` states and `6`
host captures.

The PNG captures and the two source capture manifests used for the Wave192 run are not committed
in this repository. That is an explicit limitation, not an implied fresh local capture: the
manifest hashes preserve their identity, while the tracked comparison rows preserve the exact
inspectable result and content-gate metadata. Reproducing the pixels still requires the WPF and
Avalonia capture hosts. The generation and check commands are recorded in the provenance bundle;
the legacy freshness sidecar is supplemental and is no longer the only authority.

## Remaining tail

The remaining Font delta is the native WPF/Avalonia text and control raster tail, including checkbox
edge antialiasing, glyph rasterization, action-button and tab-template edges. No classification was
weakened and no unrelated route rows were refreshed.
