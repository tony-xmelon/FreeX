# Wave189 FreeX: AutoFilter Date Criteria

Date criteria coverage was added to the production Linux X11 workflow for a deterministic typed-date XLSX fixture. The fixture contains `2024-01-01`, `2024-01-15`, `2024-02-01`, and `2024-03-15` as numeric date cells with the `yyyy-mm-dd` number format and an `A1:B5` worksheet AutoFilter.

The probe exercises the rendered B1 filter glyph, Date Filters > Before and Date Filters > After, exact visible-row readback, Ctrl+S, exact worksheet OOXML, and the production Ctrl+F12 Open route. The save helper now follows the proven Wave188 numeric sequence: restore the B1 header focus, send Ctrl+S, wait for the clean title, then inspect the host-mounted package. No product source edits were made.

## Physical Result

Run: `artifacts/linux-interactive/freex/interaction-validation/20260823T082642Z/interaction-validation.json`

- Before: **passed**. Visible rows `Jan01,Jan15`; saved `A1:B5`, `colId=1`, `operator=lessThan`, `value=45323`; Ctrl+F12 reopened and reproduced the same visible rows.
- After: **not credited**. Visible row `Mar15`; clean save and exact OOXML `operator=greaterThan`, `value=45323` both passed, but the second Ctrl+F12 attempt did not open a dialog (`after-dialog-open=false`), so reopen parity was not proven.

The Wave188 numeric sequence and the corrected date save sequence are byte-for-byte equivalent at the save boundary. This run therefore rules out a date-package serialization failure. The remaining blocker is the production Open/modal state after the first save/reopen cycle, and the acceptance guard remains intentionally strict.

Focused source tests: **2/2 passed** (`Wave189AutoFilterDatePhysicalSourceTests`). No speculative product changes are present.
