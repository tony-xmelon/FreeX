# FreeP SmartArt Rich Text Preservation

## Scope

SmartArt outline rewrites rebuilt every point text body. An unchanged node could therefore lose authored runs, hyperlinks, and run properties when a sibling node was edited.

## Change

When an authored node text body has the same normalized visible text as the model node, the rewrite now retains the authored `dgm:t` subtree. Edited nodes continue through the existing text rebuild path.

## Verification

- Focused rich-run rewrite regression: passed.
- `FreeP.App.Host.Tests` SmartArt suite: 211/211 passed.
- `FreeP.App.Presentation.Tests` SmartArt layout and editing suite: 304/304 passed.

This is a functional and package-preservation slice. It makes no new visual parity claim.
