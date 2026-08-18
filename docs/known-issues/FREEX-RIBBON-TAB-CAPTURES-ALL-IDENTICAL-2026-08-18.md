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

## Where to look next

`RenderWindowWithCapturedTitleBarToPng` renders `this`. Since the strip highlight does not
change between captures either, the ribbon region is almost certainly not being rasterized
at all rather than being rasterized stale — check whether the ribbon host realizes its
content under the headless/Skia render target, and compare the captured bitmap against the
ribbon control's own bounds rather than the window's.

## Consequence

Sixteen parity PNGs currently carry no information. Any parity review that consumed them
compared identical images. This should be fixed before those surfaces are trusted again,
and a cheap guard — assert the tab captures are pairwise distinct — would stop it silently
recurring.

## Incidental

The tag list shows `FileTab` twice. Unexamined, but it looks wrong.
