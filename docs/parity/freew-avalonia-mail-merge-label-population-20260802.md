# FreeW Avalonia Mail Merge Label Population

## Gap

The Avalonia Labels dialog applied the selected page geometry but did not insert a label grid. The
default ribbon route inserted a blank grid even when the mail-merge session had active recipients.
The WPF host already generated one merged label per recipient.

## Resolution

- Route custom and default Avalonia label setup through one `MailMergeEngine.ApplyLabels` path.
- Build merged cell content before mutating the document, then insert the requested grid.
- Populate cells left-to-right and top-to-bottom while preserving paragraph and run formatting.
- Keep excess cells blank and let skipped recipients advance without consuming a cell.
- Use the stashed template while preview is active, matching the existing merge-session contract.

## Verification

- Focused label and dialog contracts: 4/4 passed.
- Avalonia Mailings, MailMerge, and table-cell contracts: 46/46 passed.
- The focused tests cover page setup, exact grid dimensions, blank no-data sheets, ordered recipient
  population, rich-run preservation, skipped recipients, and custom-dialog delegation.
