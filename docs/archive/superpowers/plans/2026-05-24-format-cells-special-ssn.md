# Format Cells Special SSN Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add the Excel-like Social Security Number format to the Format Cells Special number category.

**Architecture:** Keep the change at the picker/catalog layer. The existing number formatter already handles literal hyphen placement in numeric custom formats, so no formatter engine change is needed.

**Tech Stack:** C# 12, WPF, xUnit, FluentAssertions.

---

### Task 1: Add SSN Special Format

**Files:**
- Modify: `src/FreeX.App.Host/FormatCellsDialog.xaml.cs`
- Test: `tests/FreeX.App.Host.Tests/FormatCellsDialogXamlTests.cs`
- Modify: `docs/COMMAND_SURFACE_PARITY.md`

- [x] **Step 1: Write failing dialog test**

Extend the Format Cells number-category test so the Special category contains `000-00-0000` and resolves that type label to the same format code.

- [x] **Step 2: Verify RED**

Run: `dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj --no-restore -m:1 -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false --filter "FormatCellsDialog_NumberTab" --logger "console;verbosity=minimal"`

Observed: 1 failure because the Special type list does not yet contain `000-00-0000`.

- [x] **Step 3: Add picker row**

Add `new("Special", "000-00-0000", "000-00-0000", "123-45-6789")` to `NumberFormatOptions`.

- [x] **Step 4: Verify and merge**

Run focused Format Cells tests and full solution build, update docs, commit, push to main, and resync.
