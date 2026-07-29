# FreeP Text-Column Authoring

## Scope

FreeP already carried PowerPoint `a:bodyPr numCol`/`spcCol` through the model, package reader/writer, shared text planner, WPF renderer, and Avalonia renderer. The missing functional surface was authoring: users could not change the selected text shape's column count through the shared editing and ribbon paths.

## Integrated behavior

- Added the shared `freep.text-columns` ribbon combo to the WPF and Avalonia profiles.
- Added positive-count parsing for the common ribbon values 1 through 6, while accepting counts through 32 for command callers.
- Added one undoable `SetShapeTextColumnCountCommand` per selected text shape, batched as one user operation.
- Preserved authored `ColumnSpacingEmu` when changing the count.
- Kept the existing package and renderer behavior unchanged; this slice connects the existing end-to-end capability to user authoring.

## Verification

- `FreeP.App.Presentation.Tests`: 110/110 focused tests passed.
- `FreeP.App.Host.Tests`: 194/194 focused ribbon tests passed.
- `FreeP.Ribbon.Definitions.Tests`: 27/27 focused profile and key-tip tests passed.
- `FreeP.App.Avalonia` Release build: 0 warnings, 0 errors.
- Generated command inventory now reports 552 shared WPF/Avalonia commands.

## Remaining boundary

This exposes fixed-count authoring. A future dialog could expose arbitrary counts and explicit column spacing; no spacing mutation is performed here because changing count should not discard authored spacing.
