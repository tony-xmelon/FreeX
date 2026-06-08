# Data Import Localization Residual - 2026-06-08

## Scope

- Rechecked the Data tab `Get Data` / `Refresh All` strings after the data-import parity slice landed on `main`.
- Focused on neutral and satellite resource alignment, command inventory copy, and the documented missing Excel-style `From Text/CSV` affordance.
- Avoided product XAML changes; `Get Data` remains the single live local import command.

## Follow-up Completed

- English satellite resources (`en-AU`, `en-CA`, `en-GB`, `en-IE`, `en-NZ`, `en-ZA`) now match the neutral `Get Data` help text that advertises local CSV, text/TSV/TAB, and SpreadsheetML XML import while keeping database, web, and Power Query connectors excluded.
- Added a focused localization guard so English satellite variants stay aligned with future neutral `Get Data` supported-format copy.
- Confirmed `Refresh All` already uses localized content/title/help text and remains documented as the live FreeX-managed refresh/recalc command.
- Confirmed command inventory docs already describe `Get Data (CSV)` as local CSV/TXT/TSV/TAB and SpreadsheetML XML import; no inventory regeneration was needed for this residual.

## Deferred

- Non-English satellite copies still retain their previous localized wording that mentions a local CSV file only. Updating those 37 values should wait for the normal localization sweep or translation-generation process so FreeX does not replace localized text with ad hoc English or unreviewed translations.
- FreeX still has no dedicated Excel-style `From Text/CSV` subcommand, `Get Data` dropdown, recent sources, existing connections, database/web connectors, or Power Query connector surface. The current safe state is a single live `Get Data` button plus tooltip copy that names the implemented local adapter formats.
