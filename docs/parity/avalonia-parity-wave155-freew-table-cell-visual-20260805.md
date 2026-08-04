# Avalonia Parity Wave 155: FreeW Table Properties Cell Visual

Date: 2026-08-05  
Route: `table-properties`  
Authority: app-owned WPF `freew/FreeW.App.Host/TablePropertiesDialog.cs`  
Surface: `560 x 600` logical pixels at `96 DPI`; seven paired states

## Residual and fix

Wave 154 moved the WPF-authority `Positioning` section onto the Cell tab, but Avalonia's
disabled Positioning ComboBox template darkened the realized input surfaces. The Cell raster
therefore retained a large native-template mismatch even though its structure and semantics
matched WPF.

Wave 155 adds a narrow realized-template normalization for the four Positioning ComboBoxes,
applied only while the Cell tab is selected. It restores the existing WPF light input surface
after Avalonia template realization and preserves disabled state, values, bindings, automation
IDs, tab ownership, and all dialog behavior.

## Fresh paired evidence

WPF was captured before editing from this checkout. Avalonia was captured after the production
change against that same WPF manifest and temporary seven-state inventory. All 14 captures passed
the nonblank/content gates. Existing comparison thresholds were unchanged.

| State | Before ratio / mean | After ratio / mean | Result |
| --- | ---: | ---: | --- |
| initial | 9.01% / 6.77 | 9.01% / 6.77 | retained mismatch |
| populated | 9.01% / 6.77 | 9.01% / 6.77 | retained mismatch |
| tab-cell | 18.95% / 10.83 | 12.21% / 8.07 | improved mismatch |
| tab-column | 2.60% / 2.10 | 2.60% / 2.10 | pass, unchanged |
| tab-row | 4.37% / 3.77 | 4.37% / 3.77 | unchanged |
| tab-table | 9.01% / 6.77 | 9.01% / 6.77 | unchanged |
| validation-error | 9.12% / 6.91 | 9.12% / 6.91 | unchanged |

The seven-state average changed from **8.8695% / 6.2754** to **7.9064% / 5.8810**. Cell remains
a genuine visual mismatch because native disabled painting, control-width pixels, and fixed-height
bottom clipping still differ. No threshold or classification was weakened.

## Verification

- Avalonia `WpfAuthoritySurfaceParityTests.Table_properties*`: **5 passed, 0 failed**.
- WPF `TablePropertiesDialogTests`: **3 passed, 0 failed**.
- Final harness capture: **7 WPF / 7 Avalonia captured**, all content gates passed; comparison:
  **6 genuine visual mismatches, 1 pass**, with no semantic differences.
