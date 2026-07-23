# FreeW metadata watermark visible payload - 2026-07-23

## Scope

`wordart-watermark-stress.docx` carried FreeW custom watermark metadata but no
Word VML `PowerPlusWaterMarkObject` payload. Word retained the metadata but did
not paint its diagonal text path. FreeW previously synthesized the path anyway.

The reader now keeps the metadata editable and round-trippable while setting
`NativeVmlTextPathEnabled=false` when a text watermark has no canonical VML
payload. The existing text-watermark planner consequently skips only that
unbacked visual layer. Packages with a visible native VML text path retain their
existing import and render path.

## Evidence

The source DOCX SHA-256 was
`08936E81D9858BCD846EBE8F8D1C5FDD907F357B2C5D66E29452C2DCDD1DBB0C`.
The reference was saved interactively from the open Word document to PDF, then
rasterized through `FreeW.PdfRasterize` at its native `816x1056` page size.
The PDF SHA-256 was
`EA17C5366BB9102D32E1B84DD06715A284C3AE9709B5FA3080CB0EE6126C971A` and
the resulting first-page PNG SHA-256 was
`D5C425CFA1EE139C2F8FEDB1F48D33469306882EDBA2069BEF1A3B1FD917F7BB`.

After rebuilding the consuming Release `FreeW.FidelityRender` artifact, the
matched WPF composite improved against that Word raster:

| Region | Before | After |
| --- | ---: | ---: |
| Whole page | 7.4022% | 7.3682% |
| Diagonal watermark region | 10.7939% | 10.7229% |
| Center | 12.6692% | 12.5380% |
| Lower page | 13.5206% | 13.4493% |

The remaining error is floating-object/text raster and page-flow fidelity, not
an unmodeled VML watermark. The targeted package test confirms that the custom
metadata survives and writes an explicitly disabled VML text path on a future
FreeW save.
