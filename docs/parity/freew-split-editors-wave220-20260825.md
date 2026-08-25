# FreeW Split editors — rendered-host evidence (wave 220, 2026-08-25)

## Scope

This follow-up validates the backed, synchronized Split editor surface introduced in wave 219 in both desktop hosts. It is a real-host visual check, not a claim of pixel equivalence to Microsoft Word.

The workstream exclusions remain unchanged: Ink/Draw behavior and map-chart fidelity are out of scope. See [UX visual-parity scope](ux-visual-parity-scope-2026-08-25.md).

## Evidence route

Both production-host capture tools now have a deliberate Split path:

- `FreeW.RibbonShot <outDir> split <width> <height>` selects the WPF View tab, invokes the existing backed `ToggleSplitWindow` command, and records `split-view.png` in the normal manifest.
- `FreeW.ShellVisualHarness.Avalonia --include-split` selects the Avalonia View tab, invokes its existing backed `ToggleSplit` command, and records a `split` fixture in the normal shell manifest.

At 1500 x 720, the first WPF capture exposed a real host-only defect: Print Layout preserved the full top and bottom document margins in each roughly half-height editor. WPF's `RichTextBox` then had almost no client height left for its `FlowDocument`, which clipped the contents of both panes. The equivalent Avalonia capture rendered both live panes normally.

## Fix

`DocumentView` now caps only the vertical Print Layout inset while its shared view-depth plan is `SplitVerticalEditors`. The cap is based on the live pane height and reserves at least 96 DIPs for editable document content. Horizontal page geometry is unchanged; ordinary Print Layout and larger Split panes retain the document margins. A size change reapplies this calculation so moving the splitter updates the usable client area.

The recaptured WPF Split surface displays readable title/subtitle content in both panes instead of clipping it. This confirms the page chrome remains active without making the Split view appear empty or broken at a compact shell height.

## Verification

- `dotnet build freew/FreeW.App.Host/FreeW.App.Host.csproj --configuration Release --no-restore`
- `dotnet test freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj --configuration Release --no-restore --filter FullyQualifiedName~PageViewModesTests` — 26 passed
- Both real-host capture commands completed at 1500 x 720; output is deliberately ignored under `artifacts/wave220-freew-split-editors/`.

The focused WPF test asserts that an unmeasured Split editor reserves client height with 48-DIP vertical insets before its final layout pass.
