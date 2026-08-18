# Every ribbon tab capture renders the same image

`CaptureParitySurfaces_ProducesGridAndDialogPngs` failed asserting that
`contextual.PivotTableAnalyze.png` differs from `tab.Home.png`.

## Status

**RESOLVED** in `bf6e939a9e`. Batch3 is 8/8 and every ribbon surface now hashes differently.

## Root cause

`tab.File` is captured **first** in the ribbon loop. Selecting the File tab opens the
backstage — `AvaloniaRibbonRenderer` invokes `onFileTabSelected` from its `SelectionChanged`
handler and then restores the previous content tab — but the overlay stays open.

`AvaloniaBackstageFrame` is a sibling of the shell `DockPanel` and covers the whole client
area, so every capture taken after `tab.File` photographed the backstage rather than the
ribbon. Sixteen of the seventeen PNGs were therefore byte-identical, and only one assertion
happened to compare two of them.

The fix closes any open backstage immediately before rendering a ribbon tab.

## How it was found

Bisecting the render up the visual tree, hashing each ancestor rendered in isolation:

```
TabControl[1120x130] : distinct per tab   OK
DockPanel[1120x686]  : distinct per tab   OK
Grid[1120x686]       : IDENTICAL          <-- breaks here
```

Listing that Grid's children gave it away immediately:

```
DockPanel[0,0,1120,686]            vis=True
AvaloniaBackstageFrame[0,0,1120,658] vis=True, op=1
```

## Leads killed on the way

Each of these was measured, not reasoned about, and none was the cause:

- **Tab selection.** The contextual tab is present, correctly tagged, selected, and on the
  same `TabControl` the capture reads.
- **Content realization.** Each tab's body is a distinct instance, fully laid out — Home 232
  visual descendants, Insert 128, Draw 108 — and each rendered *distinctly in isolation*.
- **Visual attachment.** The body is a visual child of `PART_SelectedContentHost`, attached,
  and inside the window tree.
- **Clipping.** Disabling `ClipToBounds` on the TabControl and every ancestor changes nothing.
- **Stale-scene rendering.** Withdrawn earlier; rendering the `Window` instead of
  `window.Content`, and draining all dispatcher priorities plus `InvalidateVisual()`, both
  change nothing.
- **Geometry does reach the bitmap.** `tab.File`'s ribbon lays out 122px against 130px and
  that difference *did* show up, which is what separated "content dropped" from "frame stale".

## Guard added

The test now hashes every ribbon surface and requires them all to differ, rather than
comparing the single pair that happened to catch this. Sixteen blank parity PNGs should not
be able to pass again silently.

## Remaining wrinkle (not a failure)

`tab.File` is still mis-specified. Driving it through `tabControl.SelectedIndex` can never
capture backstage, because the renderer deliberately bounces that selection back to the last
content tab. Whatever `tab.File.png` is meant to show, this is not the way to get it — the
`backstage.*` surfaces are captured separately and correctly.

## Incidental

The tab tag list shows `FileTab` twice. Unexamined, but it looks wrong.
