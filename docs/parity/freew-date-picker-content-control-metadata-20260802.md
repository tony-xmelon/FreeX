# FreeW date-picker content-control metadata parity

Date: 2026-08-02

## Baseline gap

Inspection of the inline `w:sdt` date-control path confirmed that FreeW retained only
`w:dateFormat`. `DocxReader` dropped `w:date/@w:fullDate` and the `w:calendar`, `w:lid`, and
`w:storeMappedDataAs` child values; `DocxWriter` consequently could not restore them.

## Implemented contract

- `ContentControlDateMetadata` retains the four optional Word values on inline date controls.
- The reader normalizes absent or empty values to `null`.
- The writer omits absent metadata and preserves the existing canonical `M/d/yyyy` date-format fallback.
- Present children serialize in schema order: `w:dateFormat`, `w:lid`, `w:storeMappedDataAs`, then
  `w:calendar`; `w:fullDate` remains an attribute on `w:date`.
- Tests cover serialized XML, reopened model state after a text edit, exact second-save `w:date`
  stability, canonical absent/default behavior, and package validation with
  `OpenXmlValidator(FileFormatVersions.Microsoft365)`.

## Verification evidence

- Focused model tests: 2 passed, 0 failed, 0 skipped.
- Focused IO and schema tests: 2 passed, 0 failed, 0 skipped.
- Full `FreeW.Core.Model.Tests`: 1,570 passed, 0 failed, 0 skipped.
- Full `FreeW.Core.IO.Tests`: 1,211 passed, 0 failed, 0 skipped.
- Related-project total: 2,781 passed, 0 failed, 0 skipped.
- `dotnet build FreeX.slnx --configuration Release`: passed with 0 warnings and 0 errors.
- Repository preflight reached generated-doc checks, then reported the unrelated FreeP whole-window
  visual-evidence manifest as out of date.
- The default non-UI lane reached its 15-minute timeout. Eighteen completed TRX files contained 33,783
  passed and 2 unrelated failures, with 129 discovered tests not executed before cancellation. The
  failures were FreeP startup-process shutdown timing and Linux manifest-evidence settle timing; the
  active timed-out assembly was `FreeX.App.Host.Logic.Tests`.
