# FreeW Insert SmartArt Shared Geometry, Wave 166

Date: 2026-08-11
Authority: app-owned FreeW WPF dialog harness at 96 DPI

## Gap

The WPF and Avalonia Insert SmartArt adapters shared their state and validation planner but still
owned different geometry. WPF used a 440-DIP dialog, fixed 130-DIP list, explicit field and action
margins, 72-DIP footer buttons, and compact inline-button padding. Avalonia used a 460-DIP dialog,
a growable 130-220 DIP list, different margins, and a generic 12-DIP footer gap. The canonical
initial/populated rows measured 9.7161% changed pixels and 5.1313 mean channel delta, while the
validation row measured 6.3762% and 4.5111.

## Change

`SmartArtDialogPlanner.VisualMetrics` now owns the WPF-authority width, minimum height, outer
margin, label/control gaps, fixed list height, editor and action spacing, button padding, and
footer geometry. Both renderer adapters consume this contract. Avalonia retains one documented
three-pixel host-template compensation between its compact text editor and inline actions; this
accounts for the smaller native TextBox/button paint stack without changing the shared semantic
spacing.

The WPF and Avalonia capture hosts also accept `--route <route-id>`, producing a complete focused
manifest without hand-filtering the inventory. The three current-source SmartArt states were
captured through that path and mechanically merged into the canonical comparison with
`--baseline` and `--refresh-route insert-smart-art`.

## Evidence

All six route captures passed the full and target pixel-content gates. No semantic difference was
reported.

| State | Before ratio / mean | Final ratio / mean | Final WPF bounds | Final Avalonia bounds |
| --- | ---: | ---: | --- | --- |
| initial | 9.7161% / 5.1313 | **7.9902% / 4.4689** | `14,18,517x305` | `14,18,518x305` |
| populated | 9.7161% / 5.1313 | **7.9902% / 4.4689** | `14,18,517x305` | `14,18,518x305` |
| validation-error | 6.3762% / 4.5111 | **4.6557% / 3.8622** | `14,18,517x305` | `14,18,518x305` |

The 11-pixel painted-height residual is closed. The remaining one-pixel width difference and
native text/control rasterization remain visible; all three rows honestly remain
`genuine-visual-mismatch`.

## Verification

- Shared `ChartMediaDialogPlannerTests`: 9/9 passed.
- Avalonia live dialog geometry test: 1/1 passed.
- WPF/Avalonia source-boundary tests: 17/17 passed.
- WPF route captures: 3/3 captured and content-gated.
- Avalonia route captures: 3/3 captured and content-gated.
- Canonical route refresh retained 295 rows: 159 genuine mismatches, 24 passes, 105 Avalonia
  extensions, and 7 state-not-applicable rows.
