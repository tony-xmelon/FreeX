# Wave94 R91 Clipboard Diagnostic

Date: 2026-08-01

Target:
`R91_CopyPictureClipboardFlavorTests.ExecuteCopy_PlainRangeCopy_StillPlacesPlainTextUnaffectedByTheNewBitmapFlavor`

Result: no-code conclusion. The target passed in three independent focused runs against the existing Release test output:

- Run 1: 1 passed, 0 failed
- Run 2: 1 passed, 0 failed
- Run 3: 1 passed, 0 failed

The first build-enabled invocation did not reach test execution because another process held the integration worktree's localization resource outputs. No process was terminated and no build-server shutdown was used. The three `--no-build --no-restore` runs completed normally, so the prior all-up `Clipboard.GetText()` failure is treated as a transient or suite-interaction failure, not a deterministic defect in the clipboard path.

The existing `StaTestRunner.RunClipboardIsolated` implementation was inspected: it serializes clipboard tests with a named mutex, creates a dedicated STA for each run, clears and flushes the clipboard before and after the action, and shuts down that dispatcher. No product or test code was changed.
