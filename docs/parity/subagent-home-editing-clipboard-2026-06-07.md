# Home Editing / Clipboard Parity Notes - 2026-06-07

## Scope

- Reviewed Home ribbon clipboard commands: Cut, Copy, Paste, paste variants, Paste Special side paths, and Format Painter.
- Reviewed Home ribbon editing commands: Fill, Clear, Sort & Filter, Find & Select, Go To, and active editing dropdown behavior.
- Left `docs/testing/ui-test-catalog.md` untouched in the worker branch; the integration branch records catalog status centrally.

## Excel comparison

- Excel keeps a moving border around copied cells until copy mode is cancelled, for example with Esc.
- Excel's Home > Clear menu distinguishes clearing contents, formats, comments/notes, and hyperlinks.

## Findings

- FreeX already routes Home editing dropdowns to the expected scoped command handlers for Fill, Clear, Sort & Filter, Find/Replace, Go To, and Go To Special.
- FreeX already separates Clear All, Clear Formats, Clear Contents, Clear Comments and Notes, and Clear Hyperlinks into distinct commands.
- The clear mismatch found in this slice was copy-mode visual state after an internal paste: FreeX cleared the copied source range marquee after paste even though the internal clipboard remained reusable. Excel keeps copy mode visible after paste. Cut mode should still end after paste.

## Fix

- Added a clipboard planner rule that preserves the source clipboard visual for copy paste and clears it for cut paste.
- Applied that rule to normal internal paste, insert copied cells, Paste Special side paths, Paste Column Widths, Paste Comments, Paste Validation, Paste as Picture, and Paste Link.
