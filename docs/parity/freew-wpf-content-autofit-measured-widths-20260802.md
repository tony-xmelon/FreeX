# FreeW WPF measured content-autofit widths (2026-08-02)

## Result

WPF tables now measure each column's widest paragraph when the imported table is true content autofit with no preferred width, no `tblGrid` widths, no spans, and horizontal text. The measured widths drive both `TableColumn.Width` and the table's trailing block reservation. Preferred-width, fixed-grid, merged, rotated, and paginated routes retain their existing ownership.

The 14-DIP content allowance is the narrowest measured calibration that kept the corpus's single-line cells unwrapped in WPF. Wider/narrower probes were scored rather than inferred from previews.

## Fresh Word evidence

Source: `11-column-widths-autofit.docx`, freshly exported by Word 16.0 at 816x1056 through flat `C:\Temp` staging.

- Word PNG SHA-256: `CB71E94AE37756D1E939D18A2FF104AE866BCE5B2C6352DB1322F1597D409BCC`
- WPF whole page: `1.8701% -> 1.6922%`
- Content-autofit table ROI `(80,270)-(740,430)`: `5.6424% -> 4.6024%`
- Second no-grid autofit ROI `(80,390)-(740,570)`: `4.6234% -> 4.0299%`
- Explicit-width table ROI `(80,130)-(740,270)`: `6.6777%`, pixel-stable

Fixtures `01` through `10` in the table corpus were SHA-256 identical between current main and the candidate. Only fixture `11` changed.

## Verification

- Focused measured/preferred/fixed WPF contracts: 3/3 passed.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.
- Candidate WPF table corpus: 11/11 rendered.
- Current-main WPF controls: 11/11 rendered.
- Fresh Word COM target: 1/1 exported with owned process cleanup.

## Probe record

- A fixed 400-DIP trailing reservation proved the effective WPF width path and improved whole-page error to `1.8400%`, but forced both auto tables to one width.
- An 8-DIP measured allowance improved whole-page error to `1.7803%` but wrapped single-line cells and shifted the following table.
- A 1-DIP allowance matched Word's outer envelopes more closely but retained wrapping; whole-page error was `1.7626%`.
- Removing WPF horizontal padding did not change the table envelope and was rejected.
- A 12-DIP allowance produced `1.6977%`; 14 DIP retained the better `1.6922%` whole-page result.

## Remaining residual

WPF cannot reproduce Word's narrow-cell text overflow with an ordinary `FlowDocument.Table`; it wraps unless enough column width is reserved. The accepted plan improves both auto tables without disturbing any other corpus fixture. Exact outer-envelope parity would require a dedicated non-wrapping cell-content surface rather than further width-only calibration.
