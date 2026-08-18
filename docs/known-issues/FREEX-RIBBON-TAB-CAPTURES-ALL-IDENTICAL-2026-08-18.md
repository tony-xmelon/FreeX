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

## Correction to an earlier reading in this file

An earlier revision concluded "every capture rasterizes the same stale scene" from
`tab.File` differing from `tab.Home` in only one row, reasoning that Backstage replaces the
whole client area so two different states could not be near-identical.

**That inference was wrong.** `tab.File` selects the File `TabItem` in the strip; it does
not open Backstage. Backstage is captured separately as its own `backstage.*` surfaces. So
File and Home being near-identical is not evidence of stale rendering — the File tab body
may legitimately be near-empty.

The stale-scene conclusion is withdrawn. What survives is below, and it is still a real
defect.

## What is certain

The ribbon band is **not** blank. Sampling rows 0..130 of `tab.Home.png` finds 15,002
non-white pixels across 413 distinct colours — the ribbon draws fine. It just draws the
same thing every time.

The hard fact is the SHA table above: **`tab.Home` and `tab.Insert` are byte-identical**,
as are fourteen other tabs. Those tabs have entirely different ribbon bodies — different
groups, different buttons — inside a 130px band that demonstrably rasterizes content. They
cannot legitimately produce the same bytes. Something between "the correct tab is selected"
and "pixels land in the PNG" is dropping the tab body.

Also measured: `tab.File`'s ribbon lays out 122px tall against 130px for every other tab,
yet that 8px difference does not appear in the image — only row 0 differs. So layout state
that is provably different at the moment of the call is not reaching the bitmap.

## Tried and rejected

Draining `Background` + `Loaded` + `Render` priorities and calling `InvalidateVisual()`
before `bitmap.Render(visual)` — on the theory that content realized at lower priorities
was still pending — changes nothing. Reverted.

## Where to look next

`RenderVisualToBitmap` calls `bitmap.Render(visual)` where `visual` is `window.Content`.
Worth checking whether rendering a *child* visual of a live window picks up that child's
current subtree, or whether the capture should render the window itself (or the ribbon
control's own bounds) instead.

## Consequence

Sixteen ribbon PNGs are byte-identical and carry no information. Any parity review that
consumed them compared identical images.

Whether the blast radius extends past the ribbon is unknown — that claim rested on the
withdrawn stale-scene reading. Grid and dialog captures have not been checked.

A cheap guard — assert the tab captures are pairwise distinct — would stop this recurring
silently, and would have caught it at the point it was introduced.

## Incidental

The tag list shows `FileTab` twice. Unexamined, but it looks wrong.
