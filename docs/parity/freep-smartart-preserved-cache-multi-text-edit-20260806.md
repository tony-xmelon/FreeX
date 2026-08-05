# FreeP preserved SmartArt multi-text cache synchronization

## Scope

Imported SmartArt families can be displayed from an authored `dsp:drawing`
cache when the live layout planner cannot reproduce the source family. The text
pane must still support a normal multi-node edit without discarding that cache.

## Change

`SmartArtEditingPlanner.SynchronizePreservedDrawingText` now maps every changed
node whose source text is unique to exactly one cached `dsp:txBody` and one
fallback `SlideShape`. It validates all mappings and paragraph shape constraints
before changing any cache or fallback object, then applies the complete edit set
atomically. Node count, model id, level, and assistant role must remain unchanged;
duplicate source text, missing mappings, and structural changes remain rejected.

This preserves the source drawing's geometry, effects, rotation, roles, and run
formatting while updating the semantic `data1.xml` text through the existing
text-pane command path. WPF and Avalonia already share this planner fallback.

## Verification

- Focused preserved-cache synchronization: **4/4**
- FreeP Presentation tests: **3,787/3,787**
- WPF SmartArt tests: **313/313**
- Avalonia SmartArt tests: **33/33**
- WPF Release consumer build: **0 warnings/errors**
- Avalonia Release consumer build: **0 warnings/errors**

This slice is functional parity evidence only. It does not claim that the live
planner now reproduces every PowerPoint SmartArt family visually; unsupported
layout/effect families continue to use their preserved authored cache.
