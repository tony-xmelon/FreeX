# FreeP slide-clone hidden and color-map parity

Date: 2026-07-23  
Scope: `FreeP.Core.Model.SlideCloner.CloneSlide`

## Change

Slide duplication and state snapshots now preserve the source slide's `IsHidden` flag and deep-copy its `ColorMapOverride` dictionary. The cloned map uses the same case-insensitive key semantics as the package reader and is independent of the source map, so later edits to a duplicate cannot alter the original slide.

This is a functional parity fix. It does not change the slide raster path for ordinary rendering; hidden-slide behavior and per-slide theme color remapping now survive duplicate, undo, clipboard, and related clone-based workflows.

## Verification

- Focused compiled test: `SlideCloner_CloneSlide_PreservesHiddenAndColorMapOverride` passed 1/1.
- Focused no-build clone family: `SlideCloner_` passed 14/14.
- Consuming Release build: `tools/FreeP.RenderCompare/FreeP.RenderCompare.csproj` passed with 0 warnings and 0 errors.
