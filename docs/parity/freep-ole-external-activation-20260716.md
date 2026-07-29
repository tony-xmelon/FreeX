# FreeP external OLE activation parity

## Scope

PowerPoint activates embedded Excel, Word, and PowerPoint objects on a
double-click. FreeP already preserved the embedded OPC payload and fallback
preview, but treated the object as a static picture during interaction.

The WPF and Avalonia gesture handlers now detect a double-click on an OLE shape,
materialize the preserved payload under the session temporary directory, and
ask the operating system to open it with its registered host application. The
fallback preview remains the slide-rendering path; in-place OLE hosting is still
outside the shared canvas. The activation session observes host-process exit, imports a changed
non-empty payload into the existing model object, and removes its temporary file so an ordinary
FreeP save persists an external edit.

## Verification

- `OleActivationServiceTests`: extension normalization, content-type fallback,
  empty-payload behavior, changed-byte read-back, and unchanged/empty read-back safety covered.
- `PptxRepairCorpusValidityTests`: all 9 package repair/round-trip checks pass.
