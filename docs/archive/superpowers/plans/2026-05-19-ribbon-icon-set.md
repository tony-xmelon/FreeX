# Ribbon Icon Set Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Give every ribbon/menu tab a consistent, Excel-like icon system with aligned large, small, and compact command glyphs.

**Architecture:** Add a runtime ribbon icon catalog/decorator that maps command titles to glyphs and decorates text-only ribbon buttons across all tabs. Keep command handlers and existing layout intact. Add shared XAML styles for icon sizing and use targeted Home-tab cleanup where icons already exist but need consistent alignment.

**Tech Stack:** WPF XAML, C# code-behind/helper classes, xUnit source hygiene tests.

**Closeout:** Implemented on 2026-05-19. The final implementation uses `RibbonCommandPresentationPlanner`, shared
`IconResources.xaml` slots, and `MainWindow` ribbon decoration/alignment helpers rather than the original
`RibbonIconCatalog`/`RibbonIconDecorator` file split.

---

### Task 1: Add Source Guards

**Files:**
- Modify: `tests/FreeX.App.Host.Tests/MainWindowSourceHygieneTests.cs`

- [x] Add tests that require a ribbon icon catalog/decorator.
- [x] Guard for representative command mappings across Home, Insert, Draw, Page Layout, Formulas, Data, Review, View, PivotTable, and Help.
- [x] Guard that `MainWindow` applies the decorator after ribbon visual tree creation.

### Task 2: Add Shared Icon System

**Files:**
- Create: `src/FreeX.App.Host/RibbonIconCatalog.cs`
- Create: `src/FreeX.App.Host/RibbonIconDecorator.cs`
- Modify: `src/FreeX.App.Host/Resources/IconResources.xaml`

- [x] Define command icon records with glyph, category, and accent metadata.
- [x] Add size/typography styles for large, small, and color-swatch icon content.
- [x] Decorate string-content ribbon buttons into consistent icon+label content.

### Task 3: Wire Ribbon Decoration

**Files:**
- Modify: `src/FreeX.App.Host/MainWindow.xaml.cs`

- [x] Apply the decorator on load and after ribbon tab selection/layout refresh.
- [x] Keep existing click handlers, context menus, tooltips, and key tips unchanged.

### Task 4: Verify And Review Visually

- [x] Run source hygiene tests.
- [x] Build the app host.
- [x] Launch the app, capture representative screenshots from several tabs, and iterate until the new icons are visible and aligned.
