# Preserved Style Numbering Rendering

## Scope

FreeW already retained unsupported Word style-level `w:numPr` and its original
`numbering.xml`, but both editors displayed the body paragraph without its visible
marker. This affected common legal and outline styles such as `Section I.`.

A shared planner now resolves direct paragraph numbering before inherited style
numbering, follows style chains safely, reads the preserved `w:num` /
`w:abstractNum` definition, applies level templates, number formats, and
`startOverride` values, and maintains counters per Word `numId`.

WPF renders the result as a tagged non-editable leading run. Avalonia renders it via
its existing out-of-band marker layer. In both hosts, the marker is display chrome:
paragraph body text, native FreeW list state, style metadata, and the preserved
numbering payload remain unchanged for save.

## Verification

- Shared planner contracts: 3/3 passed.
- WPF multilevel-marker/commit contracts: 13/13 passed.
- Avalonia list-layout/edit contracts: 24/24 passed.
- WPF and Avalonia Release host builds: 0 warnings, 0 errors.

The slice covers body text paragraphs with direct or inherited preserved numbering.
Native FreeW lists remain on their established render paths; unsupported numbering in
tables and advanced Word numbering properties remain separate compatibility work.
