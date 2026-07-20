# FreeW Mail Merge Dialog Parity

Generated from the WPF authority and shared/presentation/Avalonia source hashes. This report is deterministic; run 	ools/Generate-FreeWMailMergeDialogParityEvidence.ps1 -Check to verify freshness.

- Schema: $(System.Collections.Specialized.OrderedDictionary.schema)
- Surfaces inventoried: 16
- Implemented dialog/policy surfaces: 16
- Implemented policy-only surfaces: 0
- Authority: $(System.Collections.Specialized.OrderedDictionary.authority)

| Surface | Status | Shared policy | Exact shell-wiring gap |
|---|---|---|---|
| Envelopes | implemented | CreateEnvelopeDialogPlan/PlanEnvelope |  |
| Labels | implemented | CreateLabelDialogPlan/PlanLabel |  |
| Start Mail Merge/type selection | implemented | MailMergeStartDialogPlanner |  |
| Select/Edit Recipients | implemented | MailMergeRecipientDialogPlanner |  |
| Address Block | implemented | MailMergeInsertionPlanner |  |
| Greeting Line | implemented | MailMergeInsertionPlanner |  |
| Insert Merge Field | implemented | MailMergeInsertionPlanner |  |
| Rules | implemented | MailMergeRuleDialogPlanner |  |
| Match Fields | implemented | MailMergeMatchFieldsDialogPlanner |  |
| Filter and Sort Recipients | implemented | MailMergeFilterSortDialogPlanner |  |
| Update Labels | implemented | MailingsEnvelopeLabelPlanner |  |
| Preview Results | implemented | MailMergePreviewDialogPlanner |  |
| Find Recipient | implemented | MailMergeFindRecipientPlanner |  |
| Check for Errors | implemented | MailMergeCheckForErrorsPlanner |  |
| Finish and Merge destination/options | implemented | MailMergeFinishPlanner.CreateDialogPlan/Plan |  |
| Send E-mail Messages | implemented | MailMergeEmailDeliveryPlanner |  |

## Boundary

MainWindow and ribbon command/definition routes are included in the generated source fingerprints; no mail-merge shell wiring gaps remain.

## Freshness

The JSON records SHA-256 hashes for every authority, implementation, and focused-test input. -Check regenerates both artifacts in memory and fails if either committed artifact differs.