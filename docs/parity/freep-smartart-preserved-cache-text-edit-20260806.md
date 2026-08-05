# FreeP SmartArt preserved-cache text editing

## Scope

Imported SmartArt families whose `dsp:drawing` cache is richer than the shared live
layout planner remain rendered from their authored cache. The text pane previously
rewrote `data1.xml` and then failed when cache regeneration was not supported, so a
simple text edit could not be committed even though the native drawing already
contained the matching visible shape.

The shared planner now admits one bounded operation on that path: when the before and
after data have identical node topology and exactly one node text changes, it updates
the uniquely matching cached `dsp:txBody` and model fallback shape in place. Existing
DrawingML geometry, effects, rotations, extra roles, and text-run formatting remain
owned by the imported cache. Structural edits, duplicate text matches, missing cache
shapes, and multiline shape-count changes remain rejected.

WPF and Avalonia SmartArt text-pane commits pass the pre-edit data snapshot into this
fallback after the normal live-cache regeneration attempt. Supported live layouts keep
their existing regeneration path; unsupported structural operations still fail rather
than replacing native geometry with an approximation.

## Evidence

- preserved-cache positive and structural-rejection contracts: **2/2**;
- WPF SmartArt text-pane host contract: **1/1**;
- WPF Release consumer build: **0 warnings/errors**;
- Avalonia Release consumer build: **0 warnings/errors**.

This slice is functional/package behavior only. The native `Opposing Ideas` COM probe
confirmed that its cache contains a background, divider, rotated arrows, and text roles
that the current generic `LayoutOpposingIdeas` planner does not reproduce. No live-layout
admission or visual parity claim is made for that family.
