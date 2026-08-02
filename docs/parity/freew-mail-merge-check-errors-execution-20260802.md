# FreeW mail merge Check for Errors execution

## Gap

WPF and Avalonia exposed Word's three Check for Errors choices, but both commands only reported the selected
enum. No recipient was simulated, malformed rules and missing fields were not detected, and the two complete
modes never completed a merge.

## Result

`MailMergeCheckForErrorsPlanner.Check` now validates the current template and simulates every selected
recipient through the rules-aware merge path. It reports:

- ordinary merge fields absent from the recipient source;
- malformed If, Skip Record If, Next Record If, Set, Ref, Fill-in, and Ask instructions;
- valid conditional rules that reference a missing recipient field;
- body plus default header/footer merge instructions; and
- per-record merge exceptions, tagged with the 1-based recipient number.

Address Block, Greeting Line, Next Record, Merge Record #, and Merge Sequence # remain recognized special
instructions. Both hosts pass their mapped/augmented recipient rows to the shared checker.

The completion policies now execute:

- **Simulate and report** never mutates the template and opens a separate editable report document in a
  new WPF or Avalonia shell window. The report includes the record count and every issue/instruction pair.
- **Complete and pause** completes only when simulation is clean.
- **Complete without pausing** completes even when the report contains errors.

WPF delegates successful completion to its existing `FinishMergeCommand`; Avalonia delegates to
`MailMergeEngine.FinishMerge`, preserving each host's existing rules, skipped-record, composite-field, and
output-mode behavior.

## Verification

- shared mail-merge dialog planners: 15/15;
- full `FreeW.App.Presentation.Tests`: 1,179/1,179;
- WPF Find Recipient / Check for Errors command contracts: 3/3;
- Avalonia focused Check for Errors route and execution contracts: 4/4;
- full Avalonia Mailings engine tests: 29/29;
- focused merge-model and rule tests: 98/98;
- WPF and Avalonia Release test consumers built successfully.

## Residual

Even/first and non-final-section header/footer merge coverage is covered by the follow-up section-story slice.
The follow-up execute-policy slice aligns Complete-and-pause and Complete-without-pausing with Word's documented
completion/report behavior.
