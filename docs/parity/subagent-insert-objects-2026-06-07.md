# Insert Objects Parity Findings - 2026-06-07

## Scope

Inspected Insert ribbon object commands: Pictures, Shapes, Text Box, Header/Footer, Link, Comment, Symbol, and intentionally absent Object-like commands.

## FreeX vs Excel Notes

- Pictures: Excel inserts a selected image at its natural image size at the active cell. FreeX previously inserted file pictures at a command fallback size regardless of source image dimensions.
- Shapes and Text Box: Excel switches into a draw/place interaction. FreeX now has worksheet placement behavior for core shape/text-box flows in the parent parity branch, with fuller interaction polish still tracked separately.
- Header/Footer, Link, Comment, and Symbol: FreeX routes through the expected dialogs/delegates for the current feature set.
- Object-like commands such as Object, Equation, and Add-ins are intentionally not surfaced in the current Insert ribbon tests.

## Changes

- `ImageDimensionDecoder` now reads image natural size in device-independent units.
- `InsertObjectPlacementPlanner` creates file-picture insert commands with decoded dimensions and fallback defaults for invalid or unsupported bytes.
- `MainWindow.Drawing` routes Insert > Pictures through the placement planner.
- Focused host tests cover image dimension decoding, fallback sizing, and planner-backed picture insertion.
