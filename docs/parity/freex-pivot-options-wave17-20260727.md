# FreeX PivotTable Options Wave 17

Captured 2026-07-27 from the authoritative WPF dialog and Avalonia parity route at matching sizes: `520x676` for Layout & Format and `520x500` for the other five tabs.

The Avalonia dialog now captures every WPF-editable option, including retained-items behavior, seeds controls from `PivotOptionsPlanner.CaptureDialogValues`, validates both numeric fields, and applies Data, Display, Print, Format, Alt Text, totals, and layout values through `ConfigurePivotTableOptionsCommand`. Focused tests cover the full command round trip and the Avalonia control-to-command wiring.

Visual triage score before/after:

| Tab | Before | After |
| --- | ---: | ---: |
| Data | 0.124561 | 0.058823 |
| Display | 0.116482 | 0.069304 |
| Layout & Format | existing | 0.045673 |
| Totals & Filters | existing | 0.044882 |
| Printing | existing | 0.041036 |
| Alt Text | existing | 0.039020 |

The independent parity compare reports `2.59%` Data and `3.75%` Display pixel difference; these remain informational visual differences with matching dimensions and no functional residuals identified in this slice.
