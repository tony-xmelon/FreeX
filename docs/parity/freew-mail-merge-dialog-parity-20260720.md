# FreeW Mail Merge Dialog Parity

Generated from the WPF authority and shared/presentation/Avalonia source hashes. This report is deterministic; run 	ools/Generate-FreeWMailMergeDialogParityEvidence.ps1 -Check to verify freshness.

- Schema: $(System.Collections.Specialized.OrderedDictionary.schema)
- Surfaces inventoried: 16
- Implemented dialog/policy surfaces: 16
- Implemented policy-only surfaces awaiting forbidden shell wiring: 3
- Authority: $(System.Collections.Specialized.OrderedDictionary.authority)

| Surface | Status | Shared policy | Exact shell-wiring gap |
|---|---|---|---|
| Envelopes | implemented | CreateEnvelopeDialogPlan/PlanEnvelope | MainWindow and ribbon command files are ownership-forbidden; dialog route is recorded but not connected in this slice. |
| Labels | implemented | CreateLabelDialogPlan/PlanLabel | MainWindow and ribbon command files are ownership-forbidden; dialog route is recorded but not connected in this slice. |
| Start Mail Merge/type selection | implemented | MailMergeStartDialogPlanner | FreeWAvaloniaRibbonCommands.cs is command-registry-owned and cannot be edited here. |
| Select/Edit Recipients | implemented | MailMergeRecipientDialogPlanner | Existing callback wiring remains in forbidden MainWindow.cs. |
| Address Block | implemented | MailMergeInsertionPlanner | Existing shell command route is outside the ownership boundary. |
| Greeting Line | implemented | MailMergeInsertionPlanner | Existing shell command route is outside the ownership boundary. |
| Insert Merge Field | implemented | MailMergeInsertionPlanner | Existing callback wiring remains in forbidden MainWindow.cs. |
| Rules | implemented | MailMergeRuleDialogPlanner | Existing rule callbacks are supplied by forbidden MainWindow.cs. |
| Match Fields | implemented | MailMergeMatchFieldsDialogPlanner | FreeWAvaloniaRibbonCommands.cs and MainWindow.cs are command/shell-owned and cannot be edited here. |
| Filter and Sort Recipients | implemented | MailMergeFilterSortDialogPlanner | FreeWAvaloniaRibbonCommands.cs and MainWindow.cs are command/shell-owned and cannot be edited here. |
| Update Labels | implemented-policy-only | MailingsEnvelopeLabelPlanner | Ribbon update-label command construction is forbidden; no new Avalonia callback was added. |
| Preview Results | implemented | MailMergePreviewDialogPlanner | Preview action routing lives in forbidden MainWindow.cs/ribbon files. |
| Find Recipient | implemented | MailMergeFindRecipientPlanner | Find action routing is shell-owned and intentionally not edited. |
| Check for Errors | implemented | MailMergeCheckForErrorsPlanner | No Avalonia command callback was added because command registry/MainWindow files are forbidden. |
| Finish and Merge destination/options | implemented-policy-only | MailMergeFinishPlanner.CreateDialogPlan/Plan | Existing engine finishes to a new document; destination dialog wiring and printer/email routes are shell-owned. |
| Send E-mail Messages | implemented-policy-only | MailMergeEmailDeliveryPlanner | Existing route plans only and deliberately sends no mail. |

## Boundary

MainWindow, ribbon construction/command registry/profile, Backstage, page-layout/media/design, and shared shell files were not edited. The shellWiringGap column is the handoff list for those files.

## Freshness

The JSON records SHA-256 hashes for every authority, implementation, and focused-test input. -Check regenerates both artifacts in memory and fails if either committed artifact differs.