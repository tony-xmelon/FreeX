# Format Cells Localized Date/Time Picker Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Surface the already-supported Excel `[$-F800]` long-date and `[$-F400]` long-time special formats in the Format Cells number picker.

**Architecture:** The formatter remains the source of truth for rendering localized long date/time patterns. `FormatCellsDialog` only adds picker entries that resolve to those format codes so command UI can reach the existing engine behavior.

**Tech Stack:** C# 12, WPF, xUnit, FluentAssertions.

---

### Task 1: Add Localized Date/Time Picker Entries

**Files:**
- Modify: `src/FreeX.App.Host/FormatCellsDialog.xaml.cs`
- Test: `tests/FreeX.App.Host.Tests/FormatCellsDialogXamlTests.cs`
- Modify: `docs/COMMAND_SURFACE_PARITY.md`
- Modify: `docs/ARCHITECTURE.md`

- [x] **Step 1: Write failing dialog tests**

Add tests proving the Date category exposes `Long date ([$-F800])`, the Time category exposes `Long time ([$-F400])`, and `ResolveNumberFormat` maps those labels to the raw format codes.

- [x] **Step 2: Run the focused test slice and verify RED**

Run: `dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj --no-restore --filter "FormatCellsDialog_NumberTab" --logger "console;verbosity=minimal"`

Observed: 2 failures because `Long date ([$-F800])` and `Long time ([$-F400])` are not present/resolved yet.

- [x] **Step 3: Add picker entries**

Add `NumberFormatOption` rows for Date and Time using `[$-F800]` and `[$-F400]`.

- [x] **Step 4: Verify GREEN**

Focused Format Cells tests passed: 11 passed, 0 failed.

- [x] **Step 5: Update docs and merge**

Record that OS-localized long date/time tokens are available from both the formatter and Format Cells dialog.
