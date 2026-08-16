# FreeP SmartArt Office drawing-link repair — 2026-08-16

The apparent worst FreeP visual-baseline failures in
`15-smartart-grouped-list.pptx` were not evidence of ten bad shared layout
plans. Every PowerPoint reference image contained only the slide title; the
entire SmartArt frame was absent. A pixel audit found zero non-white samples
below y=80 on all 10 reference slides.

The package carried a slide relationship to each `dsp:drawing` part, but its
`dgm:dataModel/dgm:extLst` was empty. Office discovers the cached diagram
drawing through `a:ext/dsp:dataModelExt/@relId`; without that link PowerPoint
does not paint the diagram. FreeP inferred sibling drawing parts and rendered
them, so comparing either renderer with the blank Office export produced the
reported 5.61–18.07% deltas. Geometry tuning against those blank images would
have made the product less correct.

This slice moves the relationship contract into shared SmartArt package code:

- inserted SmartArt carries a deterministic drawing relationship id from the
  moment its native parts are created;
- the PPTX writer uses that same stable slide-scoped id and adds or repairs the
  Office `dataModelExt` link while preserving all unrelated diagram content;
- malformed diagram XML still round-trips verbatim instead of making Save fail;
- the fixture generator emits the same required extension for all ten slides.

The checked-in PowerPoint PNGs remain historical evidence for the malformed
fixture. After the corrected fixture is regenerated, the external interactive
machine must recapture the ten PowerPoint references and rerun WPF/Avalonia
comparison. No UI renderer, capture, screenshot, or visual-evidence generator
was run for this change.

Pure verification on this machine:

- full `FreeP.App.Presentation.Tests`: 5,046 passing;
- `FreeP.RenderCompare`, WPF `FreeP.App.Host`, and Avalonia `FreeP.App.Avalonia`
  Release compile-only builds: zero warnings and zero errors.
