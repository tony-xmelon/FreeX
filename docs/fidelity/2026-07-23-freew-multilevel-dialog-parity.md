# FreeW Multilevel List Dialog Parity

The Avalonia `Define New Multilevel List` dialog was aligned to the WPF authority route.

## Changes

- Match the WPF 380px prompt width.
- Preserve WPF's stretched field layout while keeping the 80px level selector, 60px start-at fields, and 130px number-style minimum widths.
- Match the compact 20px control and action-button metrics and keep the action row inside the WPF client height.
- Use the shared shell `_OK` and `_Cancel` strings so action semantics and access-key content match WPF.
- Add a focused Avalonia geometry/action contract and make the visual harness use WPF-authority dimensions for this static prompt.

## Evidence

Fresh paired run from this branch:

- WPF: 186/186 captures.
- Avalonia: 273/273 captures.
- Multilevel initial/populated: 14.61% changed pixels, 10.16 mean channel delta, pHash distance 5.
- Multilevel validation: 14.79% changed pixels, 10.36 mean channel delta, pHash distance 5.
- Action semantics: matched (`_OK`, `_Cancel`, order, default, and cancel metadata).

The remaining visual delta is a genuine Avalonia/WPF framework rendering difference in text rasterization and control chrome; it is retained as a mismatch in the comparer.

Evidence outputs are in the ignored branch-local directories `artifacts/freew-multilevel-round76-wpf-full`, `artifacts/freew-multilevel-round76-avalonia-final`, and `artifacts/freew-multilevel-round76-compare-final`.
