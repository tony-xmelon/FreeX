# Every ribbon tab capture renders the same image

`CaptureParitySurfaces_ProducesGridAndDialogPngs` fails asserting that
`contextual.PivotTableAnalyze.png` differs from `tab.Home.png`.

That framing understates the problem.

## Measured

Hashing every ribbon surface as it is captured (SHA-256, first 12 hex chars):

```
tab.File                    = CD05112E75E2
tab.Home                    = E047079BF97D
tab.Insert                  = E047079BF97D
tab.Draw                    = E047079BF97D
tab.PageLayout              = E047079BF97D
tab.Formulas                = E047079BF97D
tab.Data                    = E047079BF97D
tab.Review                  = E047079BF97D
tab.View                    = E047079BF97D
tab.Help                    = E047079BF97D
contextual.ShapeFormat      = E047079BF97D
contextual.PictureFormat    = E047079BF97D
contextual.ChartDesign      = E047079BF97D
contextual.ChartFormat      = E047079BF97D
contextual.TableDesign      = E047079BF97D
contextual.PivotTableAnalyze= E047079BF97D
contextual.PivotTableDesign = E047079BF97D
```

**Sixteen of the seventeen ribbon surfaces are byte-identical.** Only `tab.File` differs,
and only because Backstage is a full-window overlay that replaces the whole client area.

So `PivotTableAnalyze` is not "falling back to Home". Nothing ribbon-related is being
captured at all, and the test only noticed because one of its assertions happened to
compare two of the sixteen identical files.

## Not a selection bug

Instrumenting `CaptureRibbonTab` immediately before the render shows the ribbon state is
exactly right every time:

```
contextual.PivotTableAnalyze|want=PivotTableAnalyzeTab|sameControl=True
  |selIdx=10|selTag=PivotTableAnalyzeTab
  |tags=FileTab,FileTab,HomeTab,InsertTab,DrawTab,PageLayoutTab,FormulasTab,
        DataTab,ReviewTab,ViewTab,PivotTableAnalyzeTab,PivotTableDesignTab,HelpTab
```

The contextual tab is present, correctly tagged, selected, and on the same `TabControl`
instance the capture reads. The previously-recorded leads (dispatcher timing, context never
applied, selection reset by rebuild, tabs not tagged) are all confirmed dead — the state is
correct and the render still does not reflect it.

## Not a render-target or visual-tree bug either

Instrumenting `RenderWindowClientContentToBitmap` at the moment of render, after the
`Measure`/`Arrange`/`UpdateLayout`/`RunJobs(Render)` sequence:

```
content=Grid|ribbon=TabControl|insideContent=True|ribBounds=0, 0, 1120, 122|selTag=FileTab
content=Grid|ribbon=TabControl|insideContent=True|ribBounds=0, 0, 1120, 130|selTag=HomeTab
content=Grid|ribbon=TabControl|insideContent=True|ribBounds=0, 0, 1120, 130|selTag=InsertTab
content=Grid|ribbon=TabControl|insideContent=True|ribBounds=0, 0, 1120, 130|selTag=DrawTab
...
```

The ribbon is a visual descendant of the exact `Grid` being rendered, it has real non-zero
bounds, and the selection is correct and different on every pass. Nothing about the render
call is looking at the wrong visual or a stale tree.

## The likely explanation

`tab.File` is the only surface that differs, and its ribbon measures **122px tall** where
every other tab measures **130px**. That 8px delta shifts everything below it, which is
sufficient on its own to change the image — no ribbon content needs to have been drawn.

Read together with the strip highlight never changing, the ribbon region is most likely
rasterizing **blank**: identical for every tab because nothing inside it is drawn, and
different for File only because the empty band is a different height.

Next step: count non-background pixels in rows 0..130 of any captured tab PNG. If that band
is uniform, the question becomes why `AvaloniaRibbonRenderer`'s content produces no draw
operations under the Skia headless render target, which is a rendering-path question rather
than anything to do with tab selection or the capture harness.

## Consequence

Sixteen parity PNGs currently carry no information. Any parity review that consumed them
compared identical images. This should be fixed before those surfaces are trusted again,
and a cheap guard — assert the tab captures are pairwise distinct — would stop it silently
recurring.

## Incidental

The tag list shows `FileTab` twice. Unexamined, but it looks wrong.
