# FreeX Visual Refresh Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Apply a consistent Excel-aligned minimal visual system across FreeX's WPF shell and ribbon.

**Architecture:** Add focused WPF resource dictionaries for theme tokens and reusable glyph snippets, merge them into `MainWindow.xaml`, and update button styles plus high-traffic glyphs to consume the shared resources. Keep behavior unchanged and verify with source-hygiene tests plus a WPF build.

**Tech Stack:** .NET 10, WPF XAML, xUnit, FluentAssertions.

---

### Task 1: Source Guards

**Files:**
- Modify: `tests/FreeX.App.Host.Tests/MainWindowSourceHygieneTests.cs`

- [ ] Add tests that require `ThemeResources.xaml` and `IconResources.xaml` to exist and be merged by `MainWindow.xaml`.
- [ ] Add tests that require the quick access toolbar to avoid emoji/mojibake glyph content.
- [ ] Run: `dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj --filter MainWindowSourceHygieneTests`
- [ ] Expected before implementation: new tests fail because the resources are not present.

### Task 2: Theme Resources

**Files:**
- Create: `src/FreeX.App.Host/Resources/ThemeResources.xaml`
- Create: `src/FreeX.App.Host/Resources/IconResources.xaml`
- Modify: `src/FreeX.App.Host/MainWindow.xaml`

- [ ] Add shared brushes for Excel green, text, muted text, ribbon backgrounds, borders, hover, pressed, checked, danger, sheet tab, and status surfaces.
- [ ] Add reusable styles for ribbon labels, glyph text, app mark, and color swatches.
- [ ] Merge both dictionaries into `MainWindow.xaml`.

### Task 3: Shell And Ribbon Polish

**Files:**
- Modify: `src/FreeX.App.Host/MainWindow.xaml`

- [ ] Update title bar, app mark, QAT buttons, tab style, ribbon buttons, combo boxes, context menus, sheet tabs, and status bar colors to use the shared resources.
- [ ] Replace QAT save/undo/redo content with consistent Segoe MDL2 / Segoe UI Symbol glyphs.
- [ ] Keep existing command handlers, names, tooltips, key tips, and layout structure unchanged.

### Task 4: Generated Command Glyph Consistency

**Files:**
- Modify: `src/FreeX.App.Host/RibbonCommandPresentationPlanner.cs`
- Modify: `tests/FreeX.App.Host.Tests/RibbonCommandPresentationPlannerTests.cs`

- [ ] Prefer Segoe MDL2 Assets for generated command icons where available.
- [ ] Keep semantic glyph mappings for formulas, sorting/filtering, charting, page layout, review, and view commands.
- [ ] Update tests only where expected glyphs intentionally change.

### Task 5: Verification

**Files:**
- Build and test only.

- [ ] Run: `dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj --filter "MainWindowSourceHygieneTests|RibbonCommandPresentationPlannerTests"`
- [ ] Run: `dotnet build FreeX.slnx`
- [ ] If the app can launch in the current desktop session, run the WPF host and inspect the shell visually.
