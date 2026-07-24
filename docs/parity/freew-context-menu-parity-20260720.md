# FreeW Context-Menu Parity Inventory (2026-07-24)

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
| Portable spelling suggestions/dictionary actions | Windows/WPF spell checker semantics for modeled diagnostics | `ProofingCorrectionCatalog` + `CustomDictionaryStore` | Dynamic | Paired |
| Native OS spelling coverage beyond modeled diagnostics | Windows/WPF spell checker | No portable OS dictionary provider | Dynamic | External-only |

Fixed explicit WPF commands total 49: date 3, outline 6, Find Special 9, Paragraph Spacing 6,
Effects 4, and Table Styles 21. With the four default content-control choices this is 53 explicit
commands. Adding the seven-command editor core gives 60 fixed commands in the standard fixture. There
are nine paired semantic families and one external-only family; portable spelling suggestions are
dynamic and are not included in the fixed command total.

## Behavioral coverage

- Editor state is recomputed when opened: Undo, Redo, Cut, Copy, Paste, Delete, and Select All honor
  history, selection, clipboard availability, and editing protection.
- Content-control choices and relative dates preserve current checked state, protection enablement,
  model mutation, and undo in both body paragraphs and table cells.
- Outline Move Up/Down, Promote/Demote, and Collapse/Expand use live heading boundaries and collapse
  state. Avalonia supports right-click, Apps, Shift+F10, first-enabled-item focus, and Escape.
- Find Special, Paragraph Spacing, Effects, and Table Styles share catalog ordering and command IDs.
  Effects and table style selection mutate real document state through undoable commands.
- Avalonia prepends the portable spelling plan when the caret is on a spelling diagnostic: deterministic
  correction suggestions, a separator, `Ignore All`, `Add to Dictionary`, and the separator before the
  normal editor menu. Suggestions are disabled under edit protection; the dictionary action persists through
  the shared `.lex` store, while `Ignore All` is session-scoped like WPF's native action. Replacement
  uses the document command bus, updates the caret, and is undoable. Grammar diagnostics and clean
  caret positions retain the normal editor menu unchanged.
- The shared Avalonia renderer preserves enabled and checked state and closes on Escape.

## Table and image audit

The only explicit WPF table context menu is the 21-item Table Styles gallery. WPF has no explicit
image, shape, chart, WordArt, SmartArt, drawing-group, or generic object right-click menu in FreeW.
Those object commands are ribbon/contextual-tab surfaces and are outside this context-menu slice, so no
direct WPF behavior was classified away or invented for Avalonia.

## External-only gap

The remaining limitation is the native OS dictionary surface beyond the modeled portable diagnostics.
Avalonia does not claim the full Windows spell-checker's language dictionaries, custom provider behavior,
or arbitrary OS-generated suggestions. The portable editor command core and the deterministic catalog
for every diagnostic currently emitted by `ProofingDiagnosticPlanner` are paired.

## Verification lanes

- `FreeWContextMenuPlannerTests`: inventory counts, catalog counts, dynamic checked state, and editor and
  outline enablement.
- `FreeWContextMenuInteractionTests`: Apps/Shift+F10, Escape, body/table control effects, protection,
  undo, Effects, Table Styles, and outline effects.
- `FreeWContextMenuInventorySourceTests`: exact WPF construction count and shared-planner consumption.
- `AvaloniaContextMenuRendererTests`: neutral rendering, separators, nesting, enabled state, checked
  state, and command dispatch.
- `ProofingCorrectionCatalogTests`: catalog coverage of every portable spelling diagnostic and stable
  casing behavior.
- `FreeWContextMenuPlannerTests`: WPF-order spelling plan, grammar exclusion, and portable inventory.
- `FreeWContextMenuInteractionTests`: replacement/undo, Add to Dictionary persistence/suppression, and
  Ignore All diagnostic suppression in Avalonia.
