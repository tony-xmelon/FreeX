# FreeP Slide-Pane Chrome Parity: Round 2

This bounded slice aligns the FreeP slide-pane thumbnail chrome to the WPF-authoritative visual plan and makes both hosts consume the same presentation tokens.

## Production change

- `FreeP.App.Presentation/SlidePanePlanner.cs` owns label font size, label spacing, thumbnail border thickness, and item margins.
- `FreeP.App.Host/SlidePane.cs` consumes those tokens for the WPF label, thumbnail border, and item margin.
- `FreeP.App.Avalonia/MainWindow.cs` consumes the same tokens and matches WPF's label-above-thumbnail order, thumbnail border, item padding, and item margins.
- Avalonia's slide-pane list host now uses a star-sized content row so the pane fills the same available height as WPF.

## Paired evidence

The production WPF and Avalonia entry points captured `startup.slide-pane.seeded` at the shared 1280x760 logical shell size and normalized 96 DPI. Both manifests report `captureStatus: complete`, all four scenario assertions passed, and no host limitations were reported.

- [WPF manifest](wpf/manifest.json) / [WPF capture](wpf/startup.slide-pane.seeded.png) / [WPF target](wpf/targets/startup.slide-pane.seeded.png)
- [Avalonia manifest](avalonia/manifest.json) / [Avalonia capture](avalonia/startup.slide-pane.seeded.png) / [Avalonia target](avalonia/targets/startup.slide-pane.seeded.png)

The focused pane target is 180x578 for both hosts. Full-shell raster differences remain in unrelated FreeP shell areas and are intentionally outside this slice.
