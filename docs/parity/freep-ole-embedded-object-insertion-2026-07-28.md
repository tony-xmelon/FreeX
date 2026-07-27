# FreeP Embedded Object Insertion

## Scope

FreeP already preserved embedded OLE packages and could activate a selected object, but it had no authoring path to insert one from a file. This slice adds the missing shared insertion contract for WPF and Avalonia.

## Behavior

- The Insert ribbon exposes `freep.object.insert-embedded` in both generated host profiles.
- WPF and Avalonia use their native file-picker adapters for common Office packages.
- The shared editor creates an undoable `SlideShapeKind.Ole` add command.
- The inserted payload retains copied bytes, extension, OPC content type, ProgId, and a minimal embedded `p:oleObj` payload.
- Existing selected-object activation remains unchanged.

## Verification

- `FreeP.App.Presentation.Tests`: 158/158, including package write/reopen and undo/redo coverage.
- `FreeP.App.Host.Tests`: 195/195 focused host/OLE suites.
- `FreeP.App.Localization.Tests`: 21/21.
- WPF host and Avalonia Release builds: 0 warnings, 0 errors.
- FreeP command inventory regenerated after the shared command was added.

This is a functional/package-authoring slice. It makes no new visual-parity claim for an OLE preview surface.
