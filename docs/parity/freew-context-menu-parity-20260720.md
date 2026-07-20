# FreeW Context-Menu Parity Inventory (2026-07-20)

## Authority and counts

The WPF host contains exactly seven explicit `new ContextMenu()` construction families. The WPF
`RichTextBox` also contributes a framework-owned editor context menu. The shared executable inventory is
`FreeWContextMenuPlanner.Inventory`; `FreeWContextMenuInventorySourceTests` guards the WPF construction
count and each explicit family's planner use.

| Family | WPF authority | Avalonia surface | Commands | Coverage |
| --- | --- | --- | ---: | --- |
| Editor core | WPF `RichTextBox` framework menu | `DocumentView` context menu | 7 | Paired |
| Content-control list/combo | `Editing/DocumentView.cs` | `Editing/DocumentView.cs`, body and table cells | Dynamic (4 defaults) | Paired |
| Content-control date | `Editing/DocumentView.cs` | `Editing/DocumentView.cs`, body and table cells | 3 | Paired |
| Outline restructure | `MainWindow.cs` | `NavigationPane.cs` | 6 | Paired |
| Find/Replace Special | `FindReplaceDialog.cs` | `FindReplaceDialog.cs` | 9 | Paired |
| Paragraph Spacing | `Ribbon/ThemeGallery.cs` | Design dropdown | 6 | Paired |
| Effects | `Ribbon/ThemeGallery.cs` | Design dropdown | 4 | Paired |
| Table Styles | `Ribbon/TableStylesGallery.cs` | Table Design dropdown | 21 | Paired |
| Native spelling suggestions/dictionary | Windows/WPF spell checker | No portable OS dictionary provider | Dynamic | External-only |

Fixed explicit WPF commands total 49: date 3, outline 6, Find Special 9, Paragraph Spacing 6,
Effects 4, and Table Styles 21. With the four default content-control choices this is 53 explicit
commands. Adding the seven-command editor core gives 60 commands in the standard fixture. There are
eight paired semantic families and one external-only family.

## Behavioral coverage

- Editor state is recomputed when opened: Undo, Redo, Cut, Copy, Paste, Delete, and Select All honor
  history, selection, clipboard availability, and editing protection.
- Content-control choices and relative dates preserve current checked state, protection enablement,
  model mutation, and undo in both body paragraphs and table cells.
- Outline Move Up/Down, Promote/Demote, and Collapse/Expand use live heading boundaries and collapse
  state. Avalonia supports right-click, Apps, Shift+F10, first-enabled-item focus, and Escape.
- Find Special, Paragraph Spacing, Effects, and Table Styles share catalog ordering and command IDs.
  Effects and table style selection mutate real document state through undoable commands.
- The shared Avalonia renderer preserves enabled and checked state and closes on Escape.

## Table and image audit

The only explicit WPF table context menu is the 21-item Table Styles gallery. WPF has no explicit
image, shape, chart, WordArt, SmartArt, drawing-group, or generic object right-click menu in FreeW.
Those object commands are ribbon/contextual-tab surfaces and are outside this context-menu slice, so no
direct WPF behavior was classified away or invented for Avalonia.

## External-only gap

One gap remains: native spelling suggestions and add/ignore dictionary actions supplied by the Windows
WPF spell-checking stack. FreeW has no cross-platform dictionary provider with equivalent suggestions and
effects. The portable editor command core is paired and is not counted as external-only.

## Verification lanes

- `FreeWContextMenuPlannerTests`: inventory counts, catalog counts, dynamic checked state, and editor and
  outline enablement.
- `FreeWContextMenuInteractionTests`: Apps/Shift+F10, Escape, body/table control effects, protection,
  undo, Effects, Table Styles, and outline effects.
- `FreeWContextMenuInventorySourceTests`: exact WPF construction count and shared-planner consumption.
- `AvaloniaContextMenuRendererTests`: neutral rendering, separators, nesting, enabled state, checked
  state, and command dispatch.
