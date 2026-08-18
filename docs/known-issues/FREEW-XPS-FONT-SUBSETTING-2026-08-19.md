# WPF cannot subset this machine's Calibri, breaking the FreeW text layer

## Symptom

`FreeW.App.Host.Tests` fails with:

```
System.IO.FileFormatException : File 'file:///C:/WINDOWS/FONTS/CALIBRI.TTF'
  has an invalid file format.
   at MS.Internal.TrueTypeSubsetter.ComputeSubset(...)
```

## Status

**Partly fixed.** 15 failures -> 7.

## What was actually broken (fixed)

`PdfExport.BuildTextOverlaysPerPage` round-trips the paginator through WPF's XPS serializer purely
to recover a *selectable-text layer*. WPF subsets every font it serializes, and the subsetter
throws on a font it cannot parse. That exception escaped, so the **entire PDF export failed over an
enhancement** -- one unparseable system font meant a user could not export a PDF at all.

Now caught: the export degrades to a raster-only PDF. That is the correct product behaviour
regardless of this machine, and it fixed 8 of the 15.

## What remains (environment)

Seven tests assert the text layer or the XPS package itself, which genuinely cannot be produced
while the font cannot be subset:

- `PdfExportTests.RenderToBytes_SampleDocument_CarriesSelectableTextLayer`
- `PdfExportTests.RenderToBytes_MultiPageDocument_PlacesEachPagesTextOnItsOwnPage`
- `XpsExportTests.RenderToBytes_SampleDocument_ProducesValidXpsPackage`
- `XpsExportTests.RenderToBytes_MultiPageDocument_SerialisesEveryPage`
- `PrintLayoutBalloonsTests.RenderToBytes_ShowMarkupBalloonsOnWithComment_DrawsCommentTextInPrintedPage`
- `PrintLayoutImageCloneTests.XpsExport_DocumentWithImage_ProducesNonEmptyArtifact`
- `DocumentViewPdfImageDiagnosticsTests.ExportToPdf_MergeComposition_ProducesNoWarningsForACleanTextOnlyDocument`

The font file itself is not corrupt: 1,650,632 bytes, valid TrueType signature `00 01 00 00`. The
failure is inside WPF's `TrueTypeSubsetter`, so it is a platform limitation on this Calibri build
rather than anything FreeW controls.

The fixtures inherit the default document font. Pinning them to a font WPF can subset would make
them deterministic and keep the assertions meaningful -- worth doing, but it needs someone to
confirm which fonts subset cleanly here rather than guessing.

## Note on visibility

`FreeW.App.Host.Tests` is **not** part of `FreeX.DefaultTests.slnx`, so none of this shows up in the
gate. It was found by running the FreeW suites directly.
