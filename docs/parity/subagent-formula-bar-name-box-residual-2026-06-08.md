# Formula Bar and Name Box Residual Parity - 2026-06-08

## Scope

Validated a bounded interactive residual around the formula bar and name box:

- Name box display for active cells, typed references, typed defined names, and canceled edits.
- Name box navigation to cell references, ranges, and workbook named ranges.
- Formula bar synchronization with inline edits and Enter/Escape commit/cancel behavior via the existing host tests.
- Selection synchronization after name-box and Go To navigation.

## Excel Behavior Compared

Representative Excel behavior used for this pass:

- Typing a cell reference in the Name Box and pressing Enter navigates to that cell and returns focus to the worksheet.
- Typing a range reference selects that range, with the formula bar showing the top-left cell content.
- Typing a valid new name while a range is selected defines that name for the selected range.
- Typing an existing defined name navigates to the full named range.
- When the selected cell or the entire selected range exactly matches a defined name, Excel displays that defined name in the Name Box; partial selections continue to display the active address/range.
- Escape in the Name Box cancels the typed draft and restores the current selection's display.

Microsoft's Name Box documentation confirms named ranges can be selected through the Name Box; Excel training/reference material confirms the selected named range's name is displayed when the full range is selected.

## FreeX Finding

FreeX already supported the important behaviors for typed references, typed defined names, new-name definition, formula bar commit/cancel, and formula bar/inline-editor synchronization.

The residual gap was display-only but visible: after navigating to an existing named range, or canceling a Name Box draft while an exact named range was selected, FreeX showed the raw address text such as `B2:C3` instead of the defined name such as `SalesData`.

## Fix

Added a small name-box display formatter that:

- Returns the alphabetically first workbook defined name whose range exactly equals the selected range.
- Falls back to the existing formatted A1/R1C1 range text when no exact defined-name match exists.
- Is used for active-cell selection, range selection, Go To selection, option refresh, and Escape restore.

Formula editing behavior was not changed.

## Verification Added

Added/updated focused host tests around:

- Name-box navigation to defined ranges preserving the canonical defined-name display.
- Case-insensitive and padded defined-name input restoring the workbook's defined-name casing.
- Exact single-cell defined names displaying the name when selected.
- Escape restore displaying the defined name for an exact named-range selection.
- Go To source refresh using the same name-box selection formatter.

## Wave67 Completion Note - 2026-07-30

The dropdown residual is now implemented through the shared `NameBoxDropdownPlanner` presentation
contract consumed by both WPF and Avalonia. It projects workbook-global names, active-sheet-scoped
names, structured tables, and visible named drawing objects. Selection uses each host's production
navigation/object-selection route, including sheet switching for targets on another sheet. Typed A1,
defined-name, table-name, casing, Escape, and focus-return paths remain unchanged.

Ordering is deterministic: case-insensitive display name, then DefinedName/Table/Object kind, then
sheet id and object id. Duplicate display names are retained as separate entries rather than silently
collapsing targets. Focused shared, WPF, and Avalonia tests cover the ordering, collisions, table body
range, and cross-sheet object/table selection routes.

The bounded X11 lane is available through `-PhysicalProbeSelector name-box-dropdown`. It seeds an
explicit validation-only fixture and drives the Avalonia Popup with real X11 input. The completed lane
resets to neutral `G10` before each case, records a new visible X11 popup XID in before/open snapshots,
uses focused keyboard navigation, and verifies exact clipboard values for both `PhysicalName` (`Region`)
and the non-defined-name `PhysicalTable` (`North\t120`). The managed Avalonia test additionally covers
keyboard selection of the third table entry and the cross-sheet table/object production routes.

Residuals are limited to the existing physical-environment dependency: the X11 lane requires Docker,
Xvfb/VNC, xdotool, scrot, ImageMagick, and xclip. Chart object anchors use the model's chart data-range
start because the current chart model does not expose a separate drawing anchor.

## 2026-06-10 Visual Evidence Slice

Added a deterministic FreeX-only screenshot tour behind `FREEX_FORMULA_BAR_NAME_BOX_TOUR=1`. With `FREEX_SS_TOUR_ALLOW_BACKGROUND_RENDER=1`, it emits 12 PNGs plus `screenshots/formula-bar-name-box-tour/formula_bar_name_box_tour_manifest.json`.

Covered visual states:

- Exact defined-name display for `Sales` (`B2:C3`) in the Name Box.
- Name Box dropdown opening and dropdown selection navigation back to the named range.
- Formula bar edit mode with visible Cancel and Enter controls, plus cancel restore and enter commit states.
- Formula bar `fx` focus and the production Insert Function dialog surface.
- Expanded formula bar, formula bar focus, and top-level keytips while focus starts in the Name Box.

Limitations:

- Evidence is in-process WPF `RenderTargetBitmap` output, not foreground OS `CopyFromScreen`.
- Name Box dropdown navigation and Formula Bar Cancel/Enter use production control state/handlers without global mouse or keyboard input.
- The Insert Function dialog is shown by the tour using the production dialog type because the formula-bar `fx` handler is modal; physical `fx` click and Shift+F3 foreground proof remain open.
- Microsoft Excel paired screenshots remain open.
