# FreeP Wave109: Increasing Circle Process

Wave109 adds the previously unsupported common PowerPoint SmartArt layout family `increasingCircleProcess`.

## Shared implementation

- `SmartArtLayoutPreset.IncreasingCircleProcess` is carried through authoring, insertion, and native layout identity. Imported PowerPoint decks retain their cached drawing until the bounded live layout models PowerPoint's background-role geometry.
- `SmartArtLayoutEngine` emits editable ellipse nodes with increasing diameters on a shared baseline and straight connectors between adjacent nodes.
- The renderer-neutral `SlideShape` output is consumed by both WPF and Avalonia through the existing shared compositor path.
- The shared ribbon definition exposes the layout in the SmartArt design group, with routes registered in both `FreeP.App.Host` and `FreeP.App.Avalonia`.
- The generated command inventory now includes both insertion and contextual layout commands.

## Verification

- Presentation focused tests: 510 passed.
- Host focused tests: 440 passed.
- Ribbon definition profile tests: 23 passed.
- Avalonia extended SmartArt registration test: 1 passed.
- The all-up default lane caught and now guards the imported-deck cache boundary: the PowerPoint corpus keeps its neutral background ellipses instead of replacing them with the approximate authoring layout.
- No Docker commands were run.

## PowerPoint-authoritative residuals

PowerPoint remains authoritative for the exact SmartArt XML layout constraints, theme-driven fill progression, connector styling and arrowhead behavior, text-fitting rules, effects, bevels, and cached drawing geometry. FreeP preserves the native layout identity and uses editable shared ellipse/line primitives for live editing and cross-platform rendering; exact PowerPoint rendering may therefore differ in those details until the shared shape contract models them explicitly.
