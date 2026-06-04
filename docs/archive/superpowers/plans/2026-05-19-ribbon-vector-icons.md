# Ribbon Vector Icons Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the ribbon's glyph-font presentation with a crisp, consistent vector icon layer and improve the FreeX titlebar/app icon spacing between `FREE` and `X`.

**Architecture:** Keep command classification in `RibbonCommandPresentationPlanner`, but return semantic icon kinds instead of font glyphs. Render those kinds through a focused WPF `RibbonIconFactory` that creates vector shapes with shared stroke widths, padding, and accent colors. Regenerate `Resources/FreeX.ico` with a separated top `FREE` band and centered `X`.

**Tech Stack:** C# 13, WPF vector primitives, xUnit/FluentAssertions source and behavior tests, PowerShell/System.Drawing for `.ico` generation.

---

### Task 1: Semantic Ribbon Icon Model

**Files:**
- Modify: `src/FreeX.App.Host/RibbonCommandPresentationPlanner.cs`
- Modify: `tests/FreeX.App.Host.Tests/RibbonCommandPresentationPlannerTests.cs`

- [ ] **Step 1: Write failing tests**

Add tests that assert command icons expose semantic kinds and no longer expose glyph/font data:

```csharp
[Theory]
[InlineData("PivotTable", RibbonCommandIconKind.PivotTable)]
[InlineData("Table", RibbonCommandIconKind.Table)]
[InlineData("Column Chart", RibbonCommandIconKind.ChartColumn)]
[InlineData("Line Chart", RibbonCommandIconKind.ChartLine)]
[InlineData("Get Data", RibbonCommandIconKind.GetData)]
[InlineData("Protect Sheet", RibbonCommandIconKind.Protect)]
[InlineData("Help Online", RibbonCommandIconKind.Help)]
public void GetIcon_MapsCommandsToSemanticVectorKinds(string commandName, RibbonCommandIconKind expectedKind)
{
    RibbonCommandPresentationPlanner.GetIcon(commandName).Kind.Should().Be(expectedKind);
}
```

Update the existing glyph tests so they no longer assert glyph strings or font family sources.

- [ ] **Step 2: Verify RED**

Run:

```powershell
dotnet test FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --filter RibbonCommandPresentationPlannerTests -p:UseSharedCompilation=false -p:NodeReuse=false --logger "console;verbosity=minimal"
```

Expected: FAIL because `RibbonCommandIconKind` and `Kind` do not exist.

- [ ] **Step 3: Implement semantic model**

Change `RibbonCommandIcon` to:

```csharp
public sealed record RibbonCommandIcon(
    RibbonCommandIconKind Kind,
    RibbonCommandIconAccent Accent = RibbonCommandIconAccent.None);
```

Add a `RibbonCommandIconKind` enum with the command families used by the ribbon. Replace glyph mappings with semantic mappings.

- [ ] **Step 4: Verify GREEN**

Run the same planner test command and expect PASS.

### Task 2: Vector Ribbon Icon Factory

**Files:**
- Create: `src/FreeX.App.Host/RibbonIconFactory.cs`
- Modify: `src/FreeX.App.Host/MainWindow.xaml.cs`
- Modify: `tests/FreeX.App.Host.Tests/MainWindowSourceHygieneTests.cs`

- [ ] **Step 1: Write failing tests**

Update source hygiene tests to assert:

```csharp
source.Should().Contain("RibbonIconFactory.CreateIcon");
source.Should().NotContain("new TextBlock");
planner.Should().NotContain("FontFamily");
planner.Should().NotContain("Glyph");
File.Exists(Path.Combine(appHostDirectory, "RibbonIconFactory.cs")).Should().BeTrue();
```

- [ ] **Step 2: Verify RED**

Run:

```powershell
dotnet test FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --filter MainWindowSourceHygieneTests -p:UseSharedCompilation=false -p:NodeReuse=false --logger "console;verbosity:minimal"
```

Expected: FAIL because `RibbonIconFactory` is absent and `CreateRibbonCommandContent` still builds glyph `TextBlock`s.

- [ ] **Step 3: Implement factory**

Create `RibbonIconFactory.CreateIcon(RibbonCommandIcon icon, double size, Brush glyphBrush)` returning a WPF `Grid`/`Canvas` with vector primitives. Use shared helpers for page, table, chart, arrows, shield, magnifier, help, and simple text-based marks where Excel uses letters such as `fx`, `A-Z`, or `123`.

- [ ] **Step 4: Wire factory into ribbon content**

In `CreateRibbonCommandContent`, replace the icon `TextBlock` with:

```csharp
Child = RibbonIconFactory.CreateIcon(icon, iconSize, glyphBrush)
```

Keep the existing slot sizing, accent brush selection, and label layout.

- [ ] **Step 5: Verify GREEN**

Run the same hygiene test command and expect PASS.

### Task 3: App Icon Spacing

**Files:**
- Modify: `src/FreeX.App.Host/MainWindow.xaml`
- Modify: `src/FreeX.App.Host/Resources/FreeX.ico`
- Modify: `tests/FreeX.App.Host.Tests/MainWindowSourceHygieneTests.cs`

- [ ] **Step 1: Write failing tests**

Extend the branding test to assert a distinct `TitleBarAppFreeBand`, a centered `TitleBarAppX`, and larger top/bottom spacing.

- [ ] **Step 2: Verify RED**

Run:

```powershell
dotnet test FreeX\tests\FreeX.App.Host.Tests\FreeX.App.Host.Tests.csproj --filter MainWindow_UsesVisibleFreeXBrandingAndWindowIcon -p:UseSharedCompilation=false -p:NodeReuse=false --logger "console;verbosity:minimal"
```

Expected: FAIL because the named band elements are absent.

- [ ] **Step 3: Implement titlebar spacing and regenerate `.ico`**

Change the titlebar icon grid to have a top band for `FREE`, a small separator gap, and a centered `X`. Regenerate the `.ico` with matching geometry at 16, 24, 32, 48, and 256 pixel sizes.

- [ ] **Step 4: Verify GREEN**

Run the branding test and expect PASS.

### Task 4: Visual Verification

**Files:**
- No source files beyond Tasks 1-3.

- [ ] **Step 1: Build**

Run:

```powershell
dotnet build FreeX\FreeX.slnx -m:1 -p:UseSharedCompilation=false -p:NodeReuse=false --nologo -v:minimal
```

Expected: Build succeeded with 0 warnings and 0 errors.

- [ ] **Step 2: Launch and capture**

Launch `FreeX.App.Host.exe` from this branch, capture Home, Insert, Data, Review, View, and Help tabs, and inspect the screenshots for visible vector icons and icon/titlebar spacing.

- [ ] **Step 3: Commit**

Run:

```powershell
git add FreeX/src/FreeX.App.Host FreeX/tests/FreeX.App.Host.Tests FreeX/docs/superpowers/plans/2026-05-19-ribbon-vector-icons.md
git commit -m "feat: replace ribbon glyphs with vector icons"
```
