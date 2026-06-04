# FreeX Command Icon Visual Consistency Review

**Date:** 2026-05-30
**Branch:** `codex/icon-audit-20260530`
**Status:** Review proposal only. No icon artwork or runtime behavior changes are included in this report.

## Scope

This pass focuses on visual consistency across the command icon system:

- unnecessary borders, side borders, frames, backplates, and filled backgrounds
- optical icon size inside the available 16 / 18 / 22 / 32 px slots
- crispness at native rendered sizes
- consistent stroke weight, color use, geometry, and metaphor style
- visible ribbon screenshots plus source-level SVG metrics

Primary files reviewed:

- `src/FreeX.App.Host/MainWindow.Ribbon.cs`
- `src/FreeX.App.Host/MainWindow.xaml`
- `src/FreeX.App.Host/RibbonCommandPresentationPlanner*.cs`
- `src/FreeX.App.Host/RibbonIconFactory*.cs`
- `src/FreeX.App.Host/Resources/CommandIconsSvg/*.svg`

Fresh visual evidence was captured with `tools/screenshot_ribbon.ps1` after a Release build. The generated PNGs were used for review only and are not intended to be checked in.

## Review Controls

Use the empty columns in each table as the review control.

| Field | Meaning |
|---|---|
| Accept | Implement the recommendation as proposed. |
| Decline | Keep current behavior. |
| Comment | Reviewer note, variant request, or exception. |

Priority:

- `P0`: global rule that affects many visible icons
- `P1`: visible inconsistency that should be fixed in the next icon pass
- `P2`: cleanup or family-level polish
- `P3`: acceptable as-is or future-only

## Baseline Measurements

SVG asset inventory after the latest icon readability work:

| Metric | Result | Review |
|---|---:|---|
| Command SVG files | 259 | Broad library, but not one coherent visual language yet. |
| `54x54` artboards | 119 | Most likely to look scaled/fuzzy when rendered in 22 px slots. |
| `32x32` artboards | 125 | Best current candidate for a canonical command grid. |
| `22x22` artboards | 9 | Too few dedicated small icons. Mostly alignment-only. |
| `20x20` artboards | 6 | Mostly chrome/backstage-ish exceptions. |
| Distinct stroke-width values | 24 | Too many. Values range from `0.8` to `3`. |
| Text-based SVGs | 54 | Useful for formula/format commands, but many need native small variants. |
| Icons with framed/card-like shapes | about 138 | Not all wrong, but this is far too common for a ribbon icon set. |
| High visual-noise candidates | about 53 | Multiple colors, thick strokes, tiny text, or lots of fractional geometry. |

The strongest conclusion: the current set is an accumulation of several icon styles. Individual icons are often understandable, but adjacent icons do not look authored as one system.

## Global Style Contract Proposal

| ID | Recommendation | Rationale | Priority | Accept | Decline | Comment |
|---|---|---|---|---|---|---|
| V1 | Remove the default icon slot background and border for most accented commands. | `CreateRibbonCommandContent` wraps icons in a `Border`; `GetRibbonIconAccentBrushes` adds colored backplates/borders for many commands. This creates boxed icons even when the command is not about boxes, borders, or backgrounds. | P0 | [ ] | [ ] |  |
| V2 | Keep backplates only for semantic color/background commands and true state badges. | Borders/backgrounds are appropriate for `Borders`, `Fill Color`, `Background`, selected/disabled state, or small status badges. They should not be general decoration. | P0 | [ ] | [ ] |  |
| V3 | Use one canonical base style: neutral outline plus one accent color. | The set currently mixes black-only, teal-only, blue table tiles, yellow badges, purple theme tiles, red warnings, and thick black magnifiers. | P0 | [ ] | [ ] |  |
| V4 | Normalize to a 32 px command artboard plus explicit 22 px small variants for dense commands. | The 54 px generated family scales down, but fractional coordinates and dense details still read blurred at 22 px. | P1 | [ ] | [ ] |  |
| V5 | Define target optical bounds for each slot. | Large icons should fill roughly 24-27 px of a 32 px slot; small icons should fill roughly 16-19 px of a 22 px slot. Current icons range from tiny to overfilled. | P1 | [ ] | [ ] |  |
| V6 | Limit stroke weights by rendered size. | Suggested defaults: 1.25-1.4 px for 22 px icons, 1.5-1.8 px for 32 px icons, 2 px only for deliberate emphasis, 3 px almost never. | P1 | [ ] | [ ] |  |
| V7 | Prefer pixel-aligned geometry for grid/table/document icons. | Crisp rectangular icons should use integer or half-pixel coordinates at native size. Curved icons should use `geometricPrecision`, not mixed snapped and fractional shapes. | P1 | [ ] | [ ] |  |
| V8 | Avoid tiny text inside icons unless there is a dedicated small version. | Text such as `fx`, `12`, `AM`, `A1`, `R1C1`, and decimal markers can work, but not when scaled from 54 px art. | P1 | [ ] | [ ] |  |
| V9 | Keep command button disabled/focus/hover chrome separate from icon artwork. | Disabled add-in/help commands currently make icon chrome and button chrome visually compete. State should belong to the button template, not the SVG metaphor. | P1 | [ ] | [ ] |  |

## Key Findings

### 1. Runtime Slot Chrome Is Making Many Icons Look Boxed

The most visible source of unnecessary backgrounds/borders is not only the SVG files. In `MainWindow.Ribbon.cs`, `CreateRibbonCommandContent` creates an icon `Border` slot. Accent categories currently return colored slot backgrounds and borders:

- `Green`
- `Chart`
- `Data`
- `Theme`
- `Fill`
- `Color`
- `Border`
- `Warning`
- `Protect`
- `Help`

This makes commands like PivotTable, Format as Table, Recommended Charts, Add-ins, Protect Sheet, Accessibility, Contact Support, and What's New look like they are inside tiny UI controls. The actual ribbon button already provides hover/focus/disabled chrome, so the icon usually should not have its own mini-button chrome.

| Action | Scope | Priority | Accept | Decline | Comment |
|---|---|---|---|---|---|
| Make `GetRibbonIconAccentBrushes` return transparent/no border for non-semantic accent categories. | Runtime icon wrapper | P0 | [ ] | [ ] |  |
| Keep slot chrome only for an allow-list: `Border`, `Fill`, `Color`, `Background`, maybe `Warning` if the warning triangle needs a pale fill. | Runtime icon wrapper | P0 | [ ] | [ ] |  |
| Move category color into the SVG/glyph itself, not the icon slot. | Runtime + SVG library | P1 | [ ] | [ ] |  |

### 2. Framed/Card Metaphors Are Overused

Frames are correct when the command is about a page, window, sheet, grid, table, or image. They are less appropriate when the command is an action, status, or category.

Examples that currently read too framed or card-like:

| Icon/File | Current Issue | Recommendation | Priority | Accept | Decline | Comment |
|---|---|---|---|---|---|---|
| `recommended-charts.svg` | Chart is inside a bordered card and also has a star badge. Reads busier than neighboring chart/sparkline icons. | Remove card frame; use chart bars plus small recommendation sparkle/star. | P1 | [ ] | [ ] |  |
| `recommended-pivottables.svg` | Table card plus badge feels like a document tile. | Keep grid metaphor but reduce outer frame and badge weight. | P1 | [ ] | [ ] |  |
| `quick-analysis.svg` | White card frame plus multiple colors. | Use a simple grid with lightning/spark cue, no card backplate. | P1 | [ ] | [ ] |  |
| `copy-diagnostics.svg` | Two stacked white cards plus multiple colored details. | Use one document outline and diagnostic marker. | P2 | [ ] | [ ] |  |
| `watch-add.svg`, `watch-delete.svg`, `watch-window.svg` | Window/card frame dominates the command. | Make watch/magnifier or watch-window silhouette primary; use plus/delete as small badge. | P2 | [ ] | [ ] |  |
| `protect-sheet.svg`, `protect-workbook.svg` | Sheet/workbook frame plus lock can look like a boxed tile. | Keep document/sheet context but reduce frame stroke and remove external slot chrome. | P1 | [ ] | [ ] |  |
| `show-notes.svg`, `hide-unhide.svg` | Framed panels compete with command semantics. | Simplify to note/window plus visibility cue. | P2 | [ ] | [ ] |  |
| `shape-gradient.svg`, `effects.svg` | Framed tile and/or heavy decorative color. | Use shape outline plus minimal effect sparkle/gradient cue. | P1 | [ ] | [ ] |  |

### 3. Optical Size Is Inconsistent

Some icons use only a small fraction of their slot; others nearly fill it and feel heavy. This is especially visible in large ribbon commands next to each other.

Underfilled candidates:

| Icon/File | Symptom | Recommendation | Priority | Accept | Decline | Comment |
|---|---|---|---|---|---|---|
| `page-break-preview.svg`, `breaks.svg` | Page shape is narrow and tall; it reads small compared with adjacent icons. | Enlarge page silhouette or simplify to a stronger page-break mark. | P1 | [ ] | [ ] |  |
| `show-formulas.svg` | `=fx` text occupies too little vertical area in large slot. | Increase text scale or pair with formula sheet baseline. | P1 | [ ] | [ ] |  |
| `create-from-selection.svg`, `define-name.svg`, `use-in-formula.svg` | Label/formula metaphors are too small and text-heavy. | Create 22 px and 32 px formula-name family with shared sizing. | P1 | [ ] | [ ] |  |
| `open.svg`, `new.svg`, `undo.svg` | Silhouettes feel lighter/smaller than surrounding command icons. | Increase optical bounds and normalize stroke. | P2 | [ ] | [ ] |  |
| `theme-colors.svg`, `fonts.svg` | Theme group icons are not optically matched to one another. | Rebuild Themes family on one grid and one stroke scale. | P1 | [ ] | [ ] |  |

Overfilled or heavy candidates:

| Icon/File | Symptom | Recommendation | Priority | Accept | Decline | Comment |
|---|---|---|---|---|---|---|
| `zoom.svg`, `zoom-in.svg`, `zoom-out.svg`, `zoom-to-100.svg`, `zoom-to-selection.svg` | Magnifier ring/handle use 2-3 px strokes and feel heavier than nearby View icons. | Rebuild zoom family with 1.6-1.8 px ring and 2 px max handle at 32 px. | P1 | [ ] | [ ] |  |
| `get-add-ins.svg`, `add-pen.svg` | Badged plus circles fill too much of the icon and dominate the base metaphor. | Reduce badge radius and move to consistent lower-right badge position. | P1 | [ ] | [ ] |  |
| `increase-decimal.svg`, `decrease-decimal.svg` | Much more readable now, but they nearly fill the 22 px slot and are visually dense. | Keep readability, but tune to slightly smaller optical width and consistent text baseline. | P2 | [ ] | [ ] |  |
| `clear-filter.svg`, `contact-support.svg` | Badge/details dominate at small sizes. | Reduce secondary badge weight. | P2 | [ ] | [ ] |  |

### 4. Crispness Problems Come From Mixed Artboards and Fractional Geometry

The renderer compensates pen thickness in `RibbonIconFactory.Svg.cs`, but it cannot fully fix geometry designed on a 54 px grid and shown at 22 px. Many generated 54 px assets use fractional coordinates such as `9.72`, `31.32`, and `43.2`; these can look soft after scaling. Text is also converted to geometry, which helps portability but makes tiny labels unforgiving.

| Action | Scope | Priority | Accept | Decline | Comment |
|---|---|---|---|---|---|
| Add a generated review sheet that renders every SVG at 16, 18, 22, and 32 px. | Tooling | P1 | [ ] | [ ] |  |
| Add source checks for allowed stroke-width values and allowed artboards. | Tests/tooling | P2 | [ ] | [ ] |  |
| Rebuild the most visible 54 px SVGs as native 32 px and 22 px assets. | SVG library | P1 | [ ] | [ ] |  |
| Avoid fractional coordinates in small variants unless they intentionally land on half-pixels. | SVG library | P1 | [ ] | [ ] |  |

## Visible Ribbon Review

### Home

| Area | Assessment | Recommendation | Priority | Accept | Decline | Comment |
|---|---|---|---|---|---|---|
| Clipboard | Paste is readable but uses a filled clipboard style while Cut/Copy/Format Painter are lighter outlines. | Keep semantics, but normalize clipboard family stroke/fill weight. | P2 | [ ] | [ ] |  |
| Font and Alignment | Mostly coherent due small-specific alignment icons. | Keep, use this as the model for crisp small icon variants. | P3 | [ ] | [ ] |  |
| Number | `$`, `%`, comma, and decimals are typographic, while other commands are pictorial. | Accept typographic number commands, but unify optical size and weight. | P2 | [ ] | [ ] |  |
| Styles | Conditional Formatting, Format as Table, Cell Styles all use framed/table tile metaphors. | Remove runtime slot chrome first; then decide which internal frames are semantically needed. | P1 | [ ] | [ ] |  |
| Editing | AutoSum is typographic/large; Fill/Clear/Sort/Find are outline-plus-color. | Accept mixed metaphors here, but keep sizes consistent. | P2 | [ ] | [ ] |  |

### Insert

| Area | Assessment | Recommendation | Priority | Accept | Decline | Comment |
|---|---|---|---|---|---|---|
| Tables | PivotTable, Recommended PivotTables, Table are all framed grids. Understandable, but visually box-heavy. | Keep grid semantics; reduce slot chrome and outer frame emphasis. | P1 | [ ] | [ ] |  |
| Add-ins | Disabled buttons plus icon border/backplate look like extra UI controls. | Remove icon slot chrome; disabled state should be button opacity. | P0 | [ ] | [ ] |  |
| Charts/Tours/Sparklines | Mixed chart line weights and card/no-card styles. | Rebuild chart family together. | P1 | [ ] | [ ] |  |
| Comments/Text/Symbols | Simpler silhouettes, closer to desired style. | Use as a reference for less-boxed commands. | P3 | [ ] | [ ] |  |

### Page Layout

| Area | Assessment | Recommendation | Priority | Accept | Decline | Comment |
|---|---|---|---|---|---|---|
| Themes | Purple slot/background treatment is visually loud compared with rest of ribbon. | Remove slot chrome and standardize theme icon family. | P1 | [ ] | [ ] |  |
| Page Setup | Margins, Print Area, Print Titles, Breaks, Background mix tiny page documents and picture/card metaphors. | Rebuild as one Page Setup family with shared document outline and consistent scale. | P1 | [ ] | [ ] |  |
| Sheet Options | Checkboxes are fine; icons not central. | Keep. | P3 | [ ] | [ ] |  |
| Arrange | Bring Forward/Send Backward/Selection Pane/Rotate/Size are mostly simple but differently weighted. | Normalize stroke and optical size. | P2 | [ ] | [ ] |  |

### Formulas

| Area | Assessment | Recommendation | Priority | Accept | Decline | Comment |
|---|---|---|---|---|---|---|
| Function Library | Large `fx` and sigma are clear; smaller function category icons vary in size and style. | Build a native 22 px function-family set. | P1 | [ ] | [ ] |  |
| Defined Names | Several text-heavy icons are underfilled and soft. | Rebuild with stronger label/name metaphor and small variants. | P1 | [ ] | [ ] |  |
| Formula Auditing | Mixed tiny arrows, warning triangle, watch window, and fx glyphs. | Normalize auditing family strokes and badge placement. | P1 | [ ] | [ ] |  |
| Calculation | Calculate Now icon is small and a different lightning/fx style. | Rebuild with Formula Auditing family. | P2 | [ ] | [ ] |  |

### Data

| Area | Assessment | Recommendation | Priority | Accept | Decline | Comment |
|---|---|---|---|---|---|---|
| Get/Queries/Data Types | Database cylinders are understandable but bordered/boxed treatment is too strong. | Remove slot chrome; unify cylinder stroke and accent. | P1 | [ ] | [ ] |  |
| Sort & Filter | Good compact clarity after label fixes; icons are more line-based. | Keep as near-term baseline. | P3 | [ ] | [ ] |  |
| Data Tools | Compact icons are readable, but Data Validation/Consolidate have heavier tile/detail styles. | Normalize with Sort & Filter weight. | P2 | [ ] | [ ] |  |
| Forecast | What-If uses colorful target/question mark; Forecast uses cleaner chart line. | Reduce What-If color noise and align chart stroke. | P2 | [ ] | [ ] |  |

### Review

| Area | Assessment | Recommendation | Priority | Accept | Decline | Comment |
|---|---|---|---|---|---|---|
| Accessibility | Warning tile/backplate stands out as a button-like icon. | Keep warning triangle, remove extra slot chrome. | P1 | [ ] | [ ] |  |
| Comments/Notes | Mostly readable, but note commands mix yellow note fills, arrows, and dense small badges. | Rebuild note/comment family with consistent badge placement. | P2 | [ ] | [ ] |  |
| Protect | Protect Sheet/Workbook boxed icons feel heavier than Allow Users/Share. | Remove slot chrome and reduce internal document frame weight. | P1 | [ ] | [ ] |  |

### View

| Area | Assessment | Recommendation | Priority | Accept | Decline | Comment |
|---|---|---|---|---|---|---|
| Workbook Views | Normal, Page Break Preview, Page Layout, Custom Views use different metaphor weights. | Rebuild workbook-view family together. | P1 | [ ] | [ ] |  |
| Zoom | Magnifier icons are visibly heavier than adjacent View/Window icons. | Rebuild zoom family with thinner native 32 px strokes. | P1 | [ ] | [ ] |  |
| Window | Mostly readable, but window/grid icons vary between heavy black and thin color accents. | Normalize window family. | P2 | [ ] | [ ] |  |
| Macros | Simple and acceptable. | Keep unless macro family grows. | P3 | [ ] | [ ] |  |

### Help And Backstage

| Area | Assessment | Recommendation | Priority | Accept | Decline | Comment |
|---|---|---|---|---|---|---|
| Help tab | Disabled command button chrome plus icon frames makes Show Training/Contact Support/What's New look boxy. | Let disabled state belong to the button; use simple no-frame icons. | P1 | [ ] | [ ] |  |
| Backstage navigation | White 15 px icons are acceptable but not fully source-of-truth SVG driven. | Keep size, but route through the same SVG family where possible. | P2 | [ ] | [ ] |  |
| Recent/pinned pin icons | 12 px pin remains small. | Increase to 14-16 px if row spacing allows. | P2 | [ ] | [ ] |  |

## Recommended Implementation Sequence

| Step | Change | Why First | Priority | Accept | Decline | Comment |
|---|---|---|---|---|---|---|
| 1 | Remove most runtime slot backgrounds/borders from accented command icons. | Biggest visible consistency win with the least SVG churn. | P0 | [ ] | [ ] |  |
| 2 | Add an icon contact-sheet generator for 16 / 18 / 22 / 32 px rendering. | Makes future fixes reviewable before they hit the ribbon. | P1 | [ ] | [ ] |  |
| 3 | Define SVG authoring lint rules: allowed artboards, allowed stroke widths, no unapproved slot-like frames. | Prevents the pile-of-styles problem from returning. | P1 | [ ] | [ ] |  |
| 4 | Rebuild the Zoom, Theme, Page Setup, Insert Tables/Add-ins, and Formula Auditing families. | These are the most visibly inconsistent groups in current screenshots. | P1 | [ ] | [ ] |  |
| 5 | Add small-specific variants for Data Tools, Defined Names, Formula Auditing, Page Setup, and Chart/Insert families. | These are the places where scaled 54 px art most often looks soft. | P1 | [ ] | [ ] |  |
| 6 | Normalize color use across all remaining SVGs. | Good second pass after geometry and frame problems are under control. | P2 | [ ] | [ ] |  |

## Proposed Do/Do Not Rules

| Rule | Decision | Accept | Decline | Comment |
|---|---|---|---|---|
| Do not use an icon backplate unless the command is about fill, background, border, page, window, sheet, image, or state. | Proposed | [ ] | [ ] |  |
| Do not put a square border around a category icon just to make it colorful. | Proposed | [ ] | [ ] |  |
| Do use a small status badge for add/delete/check/error when the badge is secondary. | Proposed | [ ] | [ ] |  |
| Do keep semantic red/yellow for delete/error/warning, but not decorative multi-color. | Proposed | [ ] | [ ] |  |
| Do create native 22 px SVGs for any icon with text, grid detail, or more than one badge. | Proposed | [ ] | [ ] |  |
| Do treat button hover/focus/disabled chrome as UI, not icon artwork. | Proposed | [ ] | [ ] |  |

## Summary

The current icons are mostly understandable, but not visually unified. The main problem is that several systems overlap:

- runtime accent backplates and borders
- SVG-internal card/document/table frames
- generated 54 px icons scaled into small slots
- fallback canvas icons
- text-as-icon commands
- inconsistent badge size and placement

The fastest improvement is to remove most runtime icon-slot borders/backgrounds, then rebuild the most visible families on one native grid. After that, the SVG library needs guardrails so future icons cannot reintroduce mixed stroke weights, arbitrary backplates, and scaled tiny text.
