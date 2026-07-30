# FreeP Wave70: native rich-text selection visual parity

This slice closes the Wave69 visual residual for the production in-canvas rich
text editor. WPF remains the native `RichTextBox` authority. Avalonia keeps its
measured `TextLayout` surface, but now paints selection chrome from the shared
contract in `FreeP.App.Compositor`.

## Shared visual contract

- WPF `InCanvasTextEditor` remains the native selection authority. The shared
  contract reproduces the standard WPF platform selection visual: opaque
  `#0078D7` (`SystemColors.Highlight`) with opaque white
  (`SystemColors.HighlightText`) selection text.
- Avalonia `AvaloniaRichTextEditingSurface` uses those same shared color bytes
  for the selection background and redraws selected glyphs with the shared
  white foreground, preserving mixed runs and measured wrapping.
- The deterministic whole-window selection scenario records the active editor,
  exact logical selection range, selected text, and editor bounds in both host
  semantic manifests.

## Paired verifier

`tools/FreeP.RenderCompare` now treats `editor.rich-text-selection` as a real
pair, not merely two independently passing assertions. It rejects:

- missing or invisible editor/capture evidence as
  `rich-editor-evidence-missing`;
- decoded but blank selection crops as `rich-editor-evidence-blank`;
- wrong range or selected text as `rich-editor-evidence-stale`; and
- geometry or pixel threshold mismatches with dedicated categories.

Selection crops receive the existing whole-window thresholds unchanged:
changed-pixel ratio `<= 20%`, mean channel delta `<= 18`, and perceptual hash
distance `<= 18`. No threshold was relaxed.

## Commands for the orchestrator

Run the deterministic managed WPF/Avalonia pair on Windows:

```powershell
dotnet run --project tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --no-build -- --whole-window-visual-evidence <output-directory> --wpf-exe <wpf-executable> --avalonia-exe <avalonia-executable>
```

Regenerate the paired report without recapturing:

```powershell
dotnet run --project tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj --no-build -- --whole-window-visual-report <output-directory>
```

Run the physical Linux pointer lane through the existing orchestrated harness
(the orchestrator owns Docker/VNC lifecycle; this slice does not run Docker):

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tools/Run-FreePRichTextShortcutValidation.ps1 -PointerSelection -OutputDir <output-directory> -Width 1280 -Height 820 -Dpi 96
```

The strict Linux result must include
`pointer-selection-visual-state.json`, the forward/reverse exact clipboard
transcripts, calibration proof, and forward/reverse screenshots. The state
artifact is not a substitute for the WPF pair; it proves that physical Linux
input selected the deterministic text before visual comparison.

## Verification in this slice

- Shared presentation project: build passed.
- Avalonia rendering project: build passed.
- WPF rendering project: build passed.
- `FreeP.RenderCompare.Tests`: passed, 47/47, including the missing-crop and
  empty rich-editor-state assertions.
- WPF and Avalonia host projects: build passed.
- Physical Linux pointer lane: not run here by instruction; the orchestrator
  must run the command above.

## Remaining residuals

This slice only closes rich-text selection highlight parity. Any remaining
whole-window mismatches, other dialog or ribbon differences, and physical Linux
input lanes remain separate parity work. Fresh paired WPF/Avalonia captures are
still required to publish final pixel numbers for this implementation branch.
