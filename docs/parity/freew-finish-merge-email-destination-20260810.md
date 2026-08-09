# FreeW Finish & Merge e-mail destination parity

## Scope

- Enable `Send E-mail Messages` in the shared Finish & Merge destination planner.
- Preserve the Finish dialog's All, Current, or From/To record selection as zero-based selected records.
- Open the existing Send E-mail Messages dialog with `Selected records` as its default scope.
- Reuse the verified default-client draft handoff in WPF and Avalonia; FreeW never sends automatically.

## Guardrails

- Direct Send E-mail Messages still defaults to all records.
- Finish-to-document and finish-to-printer behavior is unchanged.
- Attachment delivery still requires a future provider with attachment support.
- The secondary e-mail dialog remains the authority for recipient field, subject, output, and body format.

## Verification

- Shared planner contracts cover destination availability and From/To index preservation.
- E-mail dialog planner contracts cover selected-record defaulting.
- WPF and Avalonia source/host contracts prove the selected indexes reach the existing draft pipeline.
