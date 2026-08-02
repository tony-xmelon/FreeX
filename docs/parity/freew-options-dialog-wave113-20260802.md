# FreeW Options AutoCorrect Parity Wave 113

Date: 2026-08-02
Authority: WPF Options dialog
Branch: `codex/avalonia-parity-wave113-freew-autocorrect-20260802`

## Scope

This slice completes the FreeW Options AutoCorrect visual and functional parity pass. The shared `OptionsDialogPlanner` now owns the WPF-authority dialog, tab, content, action-row, table, toggle, and help-text metrics used by both desktop adapters. Avalonia now follows the WPF content/action-row order, compact checkbox sizing, replacement-table sizing, and AutoCorrect state policy. WPF remains the behavioral authority for replacement parsing and product behavior.

The Avalonia AutoCorrect interaction coverage verifies that the master AutoCorrect toggle gates the dependent Smart Quotes toggle, the Replace text toggle gates the replacement table, and both controls become available again when their parent toggle is enabled. The relevant tabs and action controls are also checked in both host implementations.

The review follow-up removed an inert hidden Avalonia button that had existed only to imitate a WPF `DataGrid` visual-tree implementation detail. Both harness hosts now use the shared `DialogSemanticText.TryResolveActionButtonText` predicate: an action must be effectively visible and expose either a non-empty automation name or supported user-facing text content. Framework/internal unnamed buttons and type-name fallbacks are excluded. The fresh AutoCorrect manifests report `OK|Cancel` for both hosts while preserving default `OK` and cancel `Cancel` detection.

## Paired Evidence

The tracked canonical baseline identified `options.tab-auto-correct` as a genuine mismatch with an `action-button-order` semantic difference:

| Scenario | Canonical before | Wave113 after | Result |
| --- | ---: | ---: | --- |
| `options.tab-auto-correct` changed pixels | 55,887 / 336,000 (16.633%) | 39,903 / 336,000 (11.876%) | 28.6% relative reduction |
| `options.tab-auto-correct` mean channel delta | 11.841746 | 10.057894 | semantic difference cleared |

The fresh options-route run captured 8 WPF scenarios and 6 Avalonia scenarios. The remaining captured options rows are genuine visual mismatches from native control-template and text-rasterization differences; `options.tab-replace` and `options.tab-with` are WPF-only state-not-applicable rows. No semantic difference remains on the fresh AutoCorrect comparison.

## Route Merge

The existing dialog harness was rerun against the filtered 14-scenario Options inventory after the semantic correction. Only `options.*` rows were considered for merge. Their classifications and pixel metrics were byte-identical to the previous Wave113 canonical rows, so the comparison JSON, Markdown, and HTML required no content change; the freshness artifact was updated for the corrected source. The 287 unrelated canonical rows were serialized and hashed before and after merge:

`85362c25687e49fc401d7cd8b04456b834314537453434970b6ced0e8c733999`

The before/after hashes are identical, proving unrelated canonical row data remained byte-equivalent under the comparison serialization and semantically unchanged.

## Verification

- `FreeW.App.Presentation.Tests`: focused `FreeWOptionsPlannerTests`, 17 passed.
- `FreeW.App.Host.Tests`: focused Options and behavior-source guard tests, 29 passed.
- `FreeW.App.Avalonia.Tests`: focused `OptionsDialogVisualParityTests`, 6 passed.
- Review follow-up semantic/helper tests: 8 passed; focused Options and affected Avalonia harness guard tests: 6 passed.
- Both WPF and Avalonia harness projects built with 0 warnings and 0 errors.
- Dialog harness follow-up: options route captured 8 WPF and 6 Avalonia scenarios; canonical comparison content remained unchanged and freshness was updated. The harness exits nonzero when genuine visual mismatches remain, as expected for this cross-renderer comparison.

## Residuals

`options.tab-auto-correct` remains a genuine visual mismatch at 11.876% changed pixels / 10.057894 mean delta because WPF and Avalonia still rasterize native text and control templates differently. The former action-button-order semantic mismatch is closed. Disposable capture/build output was removed after evidence extraction; the tracked scope contains source, focused tests, canonical route comparison artifacts, and this note only.
