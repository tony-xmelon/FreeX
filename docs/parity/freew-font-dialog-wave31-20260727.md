# FreeW Font Dialog Wave 31

Date: 2026-07-27

## Scope

The Avalonia Font dialog now preserves the WPF-authority 460px outer geometry while fixing two
structural defects identified in the fresh paired review:

- the editable Size ComboBox keeps a full-width `PART_EditableTextBox` and a right-side arrow;
- the selected tab content pane consumes the Fluent horizontal inset when the dialog explicitly
  opts into the WPF authority margin through `ApplyClassicTabChrome`.

The shared compact chrome also uses the WPF input border (`#ABADB3`) and treats editable ComboBox
template textboxes as single-line controls. The Avalonia visual harness reaches the same editable
template textbox as the WPF visual walker when creating the populated state.

## Fresh Paired Evidence

WPF and Avalonia were captured independently at the same 96-DPI logical sizes: 460x340 for the
Font tab states and 460x459 for Advanced. Five WPF and five Avalonia captures were content-valid.

| State | Fresh baseline changed | Final changed | Baseline mean | Final mean | Baseline p95 | Final p95 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `font.initial` | 12.755% | 13.072% | 12.193 | 12.207 | 97.667 | 83.000 |
| `font.populated` | 12.843% | 13.176% | 12.321 | 12.349 | 97.667 | 84.000 |
| `font.tab-font` | 12.755% | 13.072% | 12.193 | 12.207 | 97.667 | 83.000 |
| `font.tab-advanced` | 15.919% | 15.844% | 12.190 | 11.041 | 97.667 | 80.667 |
| `font.validation-error` | 13.045% | 13.331% | 12.590 | 12.538 | 97.667 | 91.667 |

The stale canonical report had reported 17.152% / 13.479 for initial, 17.220% / 13.596 for
populated, and 17.439% / 13.868 for validation; the fresh WPF-authority run supersedes those
numbers. The final result remains a genuine visual mismatch, not a pass: the structural pane and
editable-field defects are fixed, while Fluent control templates, font rasterization, focus
chrome, and some vertical metrics remain visibly different. Changed-pixel ratio is not claimed as
an across-the-board improvement because corrected content width exposes additional compared pixels.

## Verification

- Focused Avalonia dialog/chrome/font tests: **39/39 passed**.
- Fresh WPF captures: **5/5 captured**.
- Fresh Avalonia captures: **5/5 captured**.
- Fresh paired comparison: **5 genuine visual-mismatch rows; no capture failures**.
- Structural regression covers editable template width/height and selected-pane WPF width.

Fresh ignored artifacts are under `artifacts/freew-font-dialog-wave31-*` in the task worktree.
