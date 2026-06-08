# Data Import And Refresh Parity Pass - 2026-06-08

## Scope

- Reviewed Data tab Get & Transform / import-refresh commands outside the sort/filter, outline, and scenario workstreams.
- Focused on `Get Data`, the absent dedicated `From Text/CSV` affordance, `Queries & Connections`, `Refresh All`, command enablement, and automation/help text.

## Findings Addressed

- `Get Data` already imports through the local file adapter path for `.csv`, `.txt`, `.tsv`, `.tab`, and SpreadsheetML `.xml`, but the neutral tooltip only advertised CSV. The help copy now names the supported local text/XML formats while continuing to call out excluded database, web, and Power Query connectors.
- `Get Data` and `Refresh All` did not have stable XAML automation IDs or explicit help text. The ribbon buttons now expose `DataGetDataButton` and `DataRefreshAllButton` with localized automation names/help text.
- `Refresh All` remains a live recalc/FreeX-managed refresh command. Source tests now cover its ribbon metadata, QAT catalog entry, always-enabled QAT state, and routing to `CalcNowBtn_Click`.
- `Queries & Connections` remains intentionally a group label, not a disabled placeholder command. Source tests now prove the group surfaces only the live `Refresh All` command and does not expose fake connection-manager or `From Text/CSV` placeholder commands.

## Remaining Gaps

- FreeX still has no dedicated Excel-style `Get Data` dropdown, `From Text/CSV` subcommand, recent sources, existing connections, connection properties/status pane, database/web connectors, or Power Query connectors.
- Satellite locale copies retain their previous localized import-help wording until the next localization sweep; the neutral resource now matches the implemented importer.
