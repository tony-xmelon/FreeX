# Paste Special Full Matrix Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Complete Excel-style Paste Special modes that FreeX can represent in its workbook model.

**Architecture:** Add explicit paste-special mode fields to the existing command options and keep mode behavior in `PasteCommandFactory`/`PasteSpecialCellsCommand`. Add small model commands for comments and validation paste so `MainWindow` can compose commands without owning model mutation rules. Keep unsupported linked-picture semantics as a normal picture snapshot because FreeX has no live linked picture model.

**Tech Stack:** .NET 10, C#, WPF host, xUnit/FluentAssertions.

---

### Task 1: Core Paste Special Modes

**Files:**
- Modify: `src/FreeX.Core.Commands/PasteSpecialCommand.cs`
- Modify: `src/FreeX.Core.Commands/PasteCommandFactory.cs`
- Test: `tests/FreeX.Core.Model.Tests/PasteSpecialCommandTests.cs`

- [ ] **Step 1: Add failing tests for skip blanks, number formats, and all-except-borders**

Add tests that assert:
- `SkipBlanks` leaves existing destination content unchanged when source is blank.
- `ValuesAndNumberFormats` pastes values and source `NumberFormat`, preserving destination font/fill/borders.
- `FormulasAndNumberFormats` pastes rebased formulas and source `NumberFormat`, preserving destination non-number formatting.
- `AllExceptBorders` copies source content and non-border style while preserving destination borders.

- [ ] **Step 2: Run focused tests and verify failure**

Run: `dotnet test tests/FreeX.Core.Model.Tests/FreeX.Core.Model.Tests.csproj --filter "PasteSpecialCellsCommand_|PasteCommandFactory_"`
Expected: compile failure or failed assertions for the new modes.

- [ ] **Step 3: Extend options and factory**

Add `PasteSpecialContentKind` and fields to `PasteSpecialOptions`:
`SkipBlanks`, `ContentKind`.
Implement mode-specific cell/style construction in `PasteCommandFactory` and `PasteSpecialCellsCommand`.

- [ ] **Step 4: Run focused tests and verify pass**

Run: `dotnet test tests/FreeX.Core.Model.Tests/FreeX.Core.Model.Tests.csproj --filter "PasteSpecialCellsCommand_|PasteCommandFactory_"`
Expected: pass.

### Task 2: Comments and Validation Paste Commands

**Files:**
- Modify: `src/FreeX.Core.Commands/PasteSpecialCommand.cs`
- Test: `tests/FreeX.Core.Model.Tests/PasteSpecialCommandTests.cs`

- [ ] **Step 1: Add failing tests**

Add tests for copying comments from source range to destination offsets and cloning validation rules onto the pasted footprint.

- [ ] **Step 2: Implement commands**

Add `PasteCommentsCommand` and `PasteValidationCommand`, with undo snapshots and protected-sheet checks.

- [ ] **Step 3: Verify**

Run: `dotnet test tests/FreeX.Core.Model.Tests/FreeX.Core.Model.Tests.csproj --filter "PasteComments|PasteValidation"`
Expected: pass.

### Task 3: Host Dialog and Mapping

**Files:**
- Modify: `src/FreeX.App.Host/PasteSpecialDialog.cs`
- Modify: `src/FreeX.App.Host/MainWindow.xaml.cs`
- Modify: `src/FreeX.App.Host/ClipboardPastePlanner.cs`
- Test: `tests/FreeX.App.Host.Tests/ClipboardPastePlannerTests.cs`

- [ ] **Step 1: Add failing planner tests**

Add tests that map all dialog-selectable paste choices to the expected core content kinds and command paths.

- [ ] **Step 2: Update dialog**

Expose radio buttons for all Excel modes: All, Formulas, Values, Formats, Comments, Validation, All except borders, Column widths, Formulas and number formats, Values and number formats, Picture, Linked picture.
Keep checkboxes for Paste Link, Skip blanks, Transpose and arithmetic operation selector.

- [ ] **Step 3: Update host command dispatch**

Map dialog result to `PasteSpecialOptions`, dispatch comments/validation/column-widths/picture/link through focused commands, and use core paste for cell modes.

- [ ] **Step 4: Verify host tests**

Run: `dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj --filter "Clipboard|Paste"`
Expected: pass.

### Task 4: Documentation and Solution Verification

**Files:**
- Modify: `docs/MENU_TOOLBAR_PARITY.md`
- Modify: `docs/COMMAND_SURFACE_PARITY.md`

- [ ] **Step 1: Update parity status**

Change Paste Special notes from partial “most modes present” to full model-backed mode coverage, with explicit note that linked picture is represented as an immutable picture snapshot.

- [ ] **Step 2: Full verification**

Run:
- `dotnet build FreeX.slnx`
- `dotnet test tests/FreeX.Core.Model.Tests/FreeX.Core.Model.Tests.csproj --filter Paste`
- `dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj --filter "Clipboard|Paste"`

Expected: all pass.
