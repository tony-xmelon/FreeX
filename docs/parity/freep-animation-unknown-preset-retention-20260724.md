# FreeP Unknown Animation Preset Retention

## Scope

FreeP now preserves unsupported PowerPoint animation `presetClass`, `presetID`, and authored `presetSubtype` tokens while reading, cloning, and writing a presentation.

Playback continues to use the existing deterministic enum fallback, so unsupported effects do not change the current runtime behavior. On save, the preserved tokens are emitted instead of silently replacing the authored effect with the fallback preset.

## Evidence

- `AnimationPresetRoundTripTests.UnknownPresetTokensSurviveReadCloneAndWrite` passed in compiled and `--no-build` runs.
- `tools/FreeP.RenderCompare` Release build passed with 0 warnings and 0 errors.
- The test verifies the model after read, the cloned slide, and the final `ppt/slides/slide1.xml` attributes.

This is a package/function parity improvement. It does not claim a new visual playback implementation for unsupported animation types.
