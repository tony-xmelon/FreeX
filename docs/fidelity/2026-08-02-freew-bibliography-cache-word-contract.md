# FreeW Bibliography Cache Word Contract

## Scope

`references-heavy-fields.docx` contains a cached `BIBLIOGRAPHY` field result immediately before a
generated bibliography content-control region. FreeW previously hid the field result whenever a
generated bibliography paragraph was present.

## Word Reference

- Fixture SHA-256: `EEA91E968B5367FC6687F9FD473304526D866FFFAB7C3350B84F2757F72D6906`
- Export: isolated visible Word 16.0 COM instance, short input/output paths, 96-DPI PDF raster
- Word page-2 PNG SHA-256: `5ECA90AA5B7E51163587C068618791CA6E061950F21CE21031437AC713AA409B`
- Word-visible text: `Bibliography field cache: References`
- Word ink extent for that line: x=96..310, y=919..930

Word keeps the cached result visible even though the generated bibliography region follows it. The
serialized field result is therefore authoritative display content, not a duplicate to suppress.

## Candidate

The shared complex-field planner now returns the cached result unchanged. Both WPF and Avalonia consume
that plan.

- WPF candidate ink extent: x=97..310, y=919..931
- WPF pages 1 and 3: SHA-256 byte-stable
- Page-2 whole-page mean channel diff: 5.9967% -> 6.0044% (+0.0077 pp)
- Field ROI `(88,908)-(328,944)`: 5.3703% -> 6.1420%

This is accepted as a functional/semantic correction, not a raster improvement. The target text and ink
extent now match Word; the small whole-page movement and adverse pixel ROI are caused by the existing
Calibri raster mismatch (Word bands are generally 12 px high, WPF 13 px) and are recorded rather than
misreported as a visual gain.

## Verification

- `ComplexFieldDisplayPlannerTests`: 13/13
- WPF exact bibliography field host test: 1/1
- Avalonia exact bibliography field layout test: 1/1
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors

