# Ribbon Core (`FreeX.Ribbon`) — SP1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build `FreeX.Ribbon`, a BCL-only library that owns the declarative ribbon definition model, command registry, selection-context manager, the relocated responsive layout engine, and the renderer abstraction — the platform-neutral foundation for the modular ribbon program (spec: `docs/superpowers/specs/2026-06-15-ribbon-core-design.md`).

**Architecture:** Phase 1 adds the new core (model, builder, validator, registry, context, renderer/measurer interfaces) with zero changes to `FreeX.App.Host` — pure addition, fully unit-tested. Phase 2 relocates the already-pure layout engine out of `FreeX.App.Host` into the core, kept green by porting the existing engine tests. Phase 3 captures a golden snapshot of today's XAML-derived catalog and adds the parity gate that SP2's big-bang cutover must satisfy.

**Tech Stack:** C# / .NET 10 (`net10.0`, no `-windows`), xUnit + FluentAssertions, `System.Text.Json` (serialization sub-library only).

---

## Implementation progress (2026-06-15)

Branch `ribbon-modular-core-sp1`. **Phase 1 complete and green (11 core tests).** Phase 2 started.

- [x] **Task 1** — `FreeX.Ribbon` + `FreeX.Ribbon.Tests` scaffolded, added to `FreeX.slnx` and `FreeX.DefaultTests.slnx`. Note: the test csproj needs `<Using Include="FluentAssertions" />` and `<Using Include="FreeX.Ribbon" />` (added).
- [x] **Tasks 2–3** — enums relocated (own copies in `FreeX.Ribbon`; App.Host duplicates still present, reconciled in Task 9); full definition model + `RibbonAdaptiveGroup` record created.
- [x] **Task 4** — `RibbonDefinitionBuilder` (+ `CheckBox`/`ComboBox`/`SplitButton`/`Dropdown`/`Gallery` builder methods beyond the plan's minimum).
- [x] **Task 5** — validator + diagnostics (RBN001–RBN004).
- [x] **Task 6** — command registry + contracts.
- [x] **Task 7** — context state + resolver.
- [x] **Task 8** — `RibbonLayoutPlan`, `IRibbonMeasurer`, `IRibbonRenderer`.
- [x] **Phase 2 first step (additive, verified)** — discovered the engine's only WPF coupling is three pure members of `RibbonCollapsedGroupPresentationPlanner` (`BreakpointThresholds`, `GetPlannedWidth`, `GetCacheKey`). Extracted them to `FreeX.Ribbon/Layout/RibbonCollapsedGroupBreakpoints.cs`; App.Host now references `FreeX.Ribbon` and the WPF class delegates to it. App.Host builds; 325 ribbon Logic.Tests green.

- [x] **Task 9 (enum unification)** — global using `FreeX.Ribbon` in App.Host; deleted `RibbonCommandPresentationTypes.cs` and the duplicate `RibbonAdaptiveGroup`/state; added the global using to both test projects. Fixed two refactor-exposed tests (`TestLaneSolutionTests` default-lane list; `RibbonIconSet_UsesSharedIconSlotsAndDecorator` source read). Whole solution builds; default suite green; 590 ribbon App.Host.Tests green.

## SP2 vertical slice landed (2026-06-15)

Proved the declarative→render pipeline end-to-end and **reproduced the Home tab look**:
- [x] `RibbonWpfRenderer` — builds a WPF visual tree from a `RibbonTab`, reusing the existing
  ribbon styles (`RibbonGroupPanel`, `RibbonLargeButton`, `RibbonBtn`, `RibbonGroupDivider`,
  `GroupLbl`) and `RibbonIcon`; Office-style group flow (large columns + small/combo columns,
  dropdown/split chevrons); binds commands through the registry by id (unregistered → disabled).
- [x] `HomeRibbonDefinition` — the Home tab (Clipboard/Font/Alignment/Number/Styles/Cells/Editing)
  authored against the fluent builder, with split/dropdown modeling.
- [x] Visual validation — `screenshots/ribbon-declarative/home_declarative.png` (STA render harness).
- [x] Functional validation — `RibbonWpfRendererTests`: definition validates, click invokes the
  registered command, unregistered renders disabled.

**Remaining for a full live cutover (SP2 breadth + SP3/SP4):**
- [ ] Relocate the pure planners into the core (Task 10 — optional cleanup; engine already works via `RibbonCollapsedGroupBreakpoints`) and the golden snapshot parity gate (Task 12).
- [ ] Author the remaining tabs (Insert, Draw, Page Layout, Formulas, Data, Review, View) + contextual tabs declaratively; register every command (wire existing handlers).
- [ ] Replace the live `MainWindow.xaml` ribbon with the rendered surface; integrate adaptive/realtime reflow via the relocated engine; delete the hand-authored ribbon XAML behind the golden-snapshot gate.
- [ ] SP3 Avalonia renderer; SP4 contextual content + non-Home polish.

---

## File Structure

New library `src/FreeX.Ribbon/` (`net10.0`, BCL only):

| File | Responsibility |
|------|----------------|
| `FreeX.Ribbon.csproj` | Project: `net10.0`, ImplicitUsings, Nullable. No UI framework. |
| `Model/RibbonCommandId.cs` | `readonly record struct RibbonCommandId`. |
| `Model/RibbonCommandIcon.cs` | Relocated `RibbonCommandIcon`/`RibbonCommandIconKind`/`RibbonCommandIconAccent`. |
| `Model/RibbonCommandLayoutKind.cs` | Relocated `RibbonCommandLayoutKind`. |
| `Model/RibbonDefinition.cs` | `RibbonDefinition`, `RibbonTab`, `RibbonTabContext`, `RibbonContextColor`. |
| `Model/RibbonGroup.cs` | `RibbonGroup`, `RibbonGroupSizing`, `RibbonWidthHints`. |
| `Model/RibbonControl.cs` | abstract `RibbonControl` + sealed subtypes. |
| `Model/RibbonMenu.cs` | `RibbonMenu`, `RibbonMenuItem`, `RibbonMenuItemKind`. |
| `Building/RibbonDefinitionBuilder.cs` | Fluent builder. |
| `Validation/RibbonDiagnostics.cs` | `RibbonDiagnostic`, `RibbonDiagnosticSeverity`, `RibbonDiagnostics`. |
| `Validation/RibbonDefinitionValidator.cs` | Structural validation. |
| `Commands/RibbonCommandContracts.cs` | `IRibbonCommand`, `IRibbonStatefulCommand`, `RibbonCommandState`, `RibbonCommandContext`. |
| `Commands/RibbonCommandRegistry.cs` | `IRibbonCommandRegistry` + default impl. |
| `Context/RibbonContextState.cs` | `RibbonContextState`. |
| `Context/IRibbonContextSource.cs` | `IRibbonContextSource`. |
| `Context/RibbonContextResolver.cs` | `RibbonContextResolver.Resolve`. |
| `Layout/RibbonAdaptiveGroup.cs` | Relocated `RibbonAdaptiveGroup`, `RibbonAdaptiveGroupState`. |
| `Layout/RibbonAdaptiveLayoutPlanner.cs` | Relocated. |
| `Layout/RibbonAdaptivePriorityPlanner.cs` | Relocated. |
| `Layout/RibbonAdaptiveLayoutEngine.cs` | Relocated. |
| `Layout/RibbonResizeThresholdGate.cs` | Relocated. |
| `Layout/RibbonCommandPresentationPlanner*.cs` | Relocated. |
| `Layout/RibbonAdaptiveTabProfiles.cs` | Relocated, then generalized to be definition-driven. |
| `Layout/IRibbonMeasurer.cs` | `IRibbonMeasurer`. |
| `Layout/RibbonLayoutPlan.cs` | `RibbonLayoutPlan`, `RibbonResolvedGroup`. |
| `Rendering/IRibbonRenderer.cs` | `IRibbonRenderer`. |

New test project `tests/FreeX.Ribbon.Tests/` mirrors `FreeX.Core.Model.Tests` (xUnit, FluentAssertions).

---

## Phase 1 — Additive core (no `FreeX.App.Host` changes)

### Task 1: Create the project and test project

**Files:**
- Create: `src/FreeX.Ribbon/FreeX.Ribbon.csproj`
- Create: `tests/FreeX.Ribbon.Tests/FreeX.Ribbon.Tests.csproj`
- Modify: `FreeX.slnx`, `FreeX.DefaultTests.slnx`

- [ ] **Step 1: Create `src/FreeX.Ribbon/FreeX.Ribbon.csproj`**

```xml
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <TargetFramework>net10.0</TargetFramework>
    <ImplicitUsings>enable</ImplicitUsings>
    <Nullable>enable</Nullable>
  </PropertyGroup>

  <ItemGroup>
    <InternalsVisibleTo Include="FreeX.Ribbon.Tests" />
  </ItemGroup>

</Project>
```

- [ ] **Step 2: Create `tests/FreeX.Ribbon.Tests/FreeX.Ribbon.Tests.csproj`**

```xml
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <TargetFramework>net10.0</TargetFramework>
    <ImplicitUsings>enable</ImplicitUsings>
    <Nullable>enable</Nullable>
    <IsPackable>false</IsPackable>
    <IsTestProject>true</IsTestProject>
  </PropertyGroup>

  <ItemGroup>
    <PackageReference Include="coverlet.collector" />
    <PackageReference Include="FluentAssertions" />
    <PackageReference Include="Microsoft.NET.Test.Sdk" />
    <PackageReference Include="xunit" />
    <PackageReference Include="xunit.runner.visualstudio" />
  </ItemGroup>

  <ItemGroup>
    <Using Include="Xunit" />
  </ItemGroup>

  <ItemGroup>
    <ProjectReference Include="..\..\src\FreeX.Ribbon\FreeX.Ribbon.csproj" />
  </ItemGroup>

</Project>
```

- [ ] **Step 3: Add a placeholder type so the project compiles**

Create `src/FreeX.Ribbon/Model/RibbonCommandId.cs`:

```csharp
namespace FreeX.Ribbon;

/// <summary>Strongly-typed identifier binding a ribbon control to a command handler.</summary>
public readonly record struct RibbonCommandId(string Value)
{
    public override string ToString() => Value;

    public static implicit operator RibbonCommandId(string value) => new(value);
}
```

- [ ] **Step 4: Register both projects in the solutions**

In `FreeX.slnx`, add under `/src/`:
`<Project Path="src/FreeX.Ribbon/FreeX.Ribbon.csproj" />`
and under `/tests/`:
`<Project Path="tests/FreeX.Ribbon.Tests/FreeX.Ribbon.Tests.csproj" />`.
Mirror the same two `<Project>` lines into `FreeX.DefaultTests.slnx`.

- [ ] **Step 5: Build to verify**

Run: `dotnet build src/FreeX.Ribbon/FreeX.Ribbon.csproj -c Release`
Expected: Build succeeded.

- [ ] **Step 6: Commit**

```bash
git add src/FreeX.Ribbon tests/FreeX.Ribbon.Tests FreeX.slnx FreeX.DefaultTests.slnx
git commit -m "Scaffold FreeX.Ribbon core library and test project"
```

---

### Task 2: Relocate platform-neutral enums into the core

These enums are already BCL-only. Move them so the core owns them; `FreeX.App.Host` will reference the core in Phase 2. For Phase 1 the core keeps its **own** copies in namespace `FreeX.Ribbon`; the App.Host originals stay untouched until Phase 2 reconciliation (Task 9 removes the duplication).

**Files:**
- Create: `src/FreeX.Ribbon/Model/RibbonCommandLayoutKind.cs`
- Create: `src/FreeX.Ribbon/Model/RibbonCommandIcon.cs`

- [ ] **Step 1: Create `RibbonCommandLayoutKind.cs`**

```csharp
namespace FreeX.Ribbon;

public enum RibbonCommandLayoutKind
{
    Small,
    Medium,
    Large
}
```

- [ ] **Step 2: Create `RibbonCommandIcon.cs`** — copy the full `RibbonCommandIcon` record, `RibbonCommandIconKind` enum, and `RibbonCommandIconAccent` enum verbatim from `src/FreeX.App.Host/RibbonCommandPresentationTypes.cs` (lines 10–171), changing only `namespace FreeX.App.Host;` to `namespace FreeX.Ribbon;`.

- [ ] **Step 3: Build**

Run: `dotnet build src/FreeX.Ribbon/FreeX.Ribbon.csproj -c Release`
Expected: Build succeeded.

- [ ] **Step 4: Commit**

```bash
git add src/FreeX.Ribbon/Model
git commit -m "Relocate ribbon icon and layout enums into FreeX.Ribbon"
```

---

### Task 3: Definition model records

**Files:**
- Create: `src/FreeX.Ribbon/Model/RibbonMenu.cs`
- Create: `src/FreeX.Ribbon/Model/RibbonControl.cs`
- Create: `src/FreeX.Ribbon/Model/RibbonGroup.cs`
- Create: `src/FreeX.Ribbon/Model/RibbonDefinition.cs`
- Test: `tests/FreeX.Ribbon.Tests/RibbonDefinitionTests.cs`

- [ ] **Step 1: Write the failing test**

`tests/FreeX.Ribbon.Tests/RibbonDefinitionTests.cs`:

```csharp
namespace FreeX.Ribbon.Tests;

public class RibbonDefinitionTests
{
    [Fact]
    public void FindTab_ReturnsTabById()
    {
        var definition = new RibbonDefinition(new[]
        {
            new RibbonTab("home", "Home", "H", Context: null, new[]
            {
                new RibbonGroup("clipboard", "Clipboard", "C", Priority: 100,
                    new RibbonControl[] { new RibbonButton("paste", "Paste") },
                    RibbonGroupSizing.Default)
            })
        });

        definition.FindTab("home")!.Header.Should().Be("Home");
        definition.VisibleTabs.Should().ContainSingle();
    }

    [Fact]
    public void ContextualTab_IsExcludedFromVisibleTabs()
    {
        var definition = new RibbonDefinition(new[]
        {
            new RibbonTab("home", "Home", "H", Context: null, Array.Empty<RibbonGroup>()),
            new RibbonTab("chart", "Chart", null,
                new RibbonTabContext("chart.selected", "Chart Tools", RibbonContextColor.Green),
                Array.Empty<RibbonGroup>())
        });

        definition.VisibleTabs.Should().ContainSingle(t => t.Id == "home");
        definition.ContextualTabs.Should().ContainSingle(t => t.Id == "chart");
    }
}
```

- [ ] **Step 2: Run to verify it fails**

Run: `dotnet test tests/FreeX.Ribbon.Tests -c Release`
Expected: FAIL — types not defined.

- [ ] **Step 3: Create `RibbonMenu.cs`**

```csharp
namespace FreeX.Ribbon;

public enum RibbonMenuItemKind { Command, Separator }

public sealed record RibbonMenu(IReadOnlyList<RibbonMenuItem> Items)
{
    public static readonly RibbonMenu Empty = new(Array.Empty<RibbonMenuItem>());
}

public sealed record RibbonMenuItem(
    string Header,
    RibbonCommandId? CommandId = null,
    string? KeyTip = null,
    string? InputGesture = null,
    RibbonMenuItemKind Kind = RibbonMenuItemKind.Command,
    IReadOnlyList<RibbonMenuItem>? Children = null)
{
    public IReadOnlyList<RibbonMenuItem> Children { get; init; } =
        Children ?? Array.Empty<RibbonMenuItem>();

    public static RibbonMenuItem Separator() =>
        new("", Kind: RibbonMenuItemKind.Separator);
}
```

- [ ] **Step 4: Create `RibbonControl.cs`**

```csharp
namespace FreeX.Ribbon;

public abstract record RibbonControl(
    RibbonCommandId CommandId,
    string Label)
{
    public string? KeyTip { get; init; }
    public RibbonCommandIcon? Icon { get; init; }
    public RibbonCommandLayoutKind PreferredLayout { get; init; } = RibbonCommandLayoutKind.Medium;
    public string? TooltipTitle { get; init; }
    public string? TooltipDescription { get; init; }
}

public sealed record RibbonButton(RibbonCommandId CommandId, string Label)
    : RibbonControl(CommandId, Label);

public sealed record RibbonToggleButton(RibbonCommandId CommandId, string Label)
    : RibbonControl(CommandId, Label);

public sealed record RibbonCheckBox(RibbonCommandId CommandId, string Label)
    : RibbonControl(CommandId, Label);

public sealed record RibbonLabel(RibbonCommandId CommandId, string Label)
    : RibbonControl(CommandId, Label);

public sealed record RibbonComboBox(RibbonCommandId CommandId, string Label)
    : RibbonControl(CommandId, Label)
{
    public IReadOnlyList<string> Items { get; init; } = Array.Empty<string>();
}

public sealed record RibbonSplitButton(RibbonCommandId CommandId, string Label, RibbonMenu Menu)
    : RibbonControl(CommandId, Label);

public sealed record RibbonDropdown(RibbonCommandId CommandId, string Label, RibbonMenu Menu)
    : RibbonControl(CommandId, Label);

public sealed record RibbonGallery(RibbonCommandId CommandId, string Label)
    : RibbonControl(CommandId, Label);

public sealed record RibbonSeparator()
    : RibbonControl(new RibbonCommandId(""), "");
```

- [ ] **Step 5: Create `RibbonGroup.cs`**

```csharp
namespace FreeX.Ribbon;

public sealed record RibbonWidthHints(
    double FullWidth,
    double SmallWithLabelsWidth,
    double IconOnlyWidth,
    double CollapsedWidth);

public sealed record RibbonGroupSizing(
    IReadOnlyList<RibbonAdaptiveGroupState> SupportedVariants,
    RibbonWidthHints? Hints = null)
{
    public static readonly RibbonGroupSizing Default = new(new[]
    {
        RibbonAdaptiveGroupState.Full,
        RibbonAdaptiveGroupState.SmallWithLabels,
        RibbonAdaptiveGroupState.IconOnly,
        RibbonAdaptiveGroupState.Collapsed
    });
}

public sealed record RibbonGroup(
    string Id,
    string Header,
    string? KeyTip,
    int Priority,
    IReadOnlyList<RibbonControl> Controls,
    RibbonGroupSizing Sizing);
```

> Note: `RibbonAdaptiveGroupState` is created in Task 9 (relocation). To keep Phase 1 self-contained, add a temporary copy of the enum in `Layout/RibbonAdaptiveGroup.cs` now (Task 9 reconciles it). Create `src/FreeX.Ribbon/Layout/RibbonAdaptiveGroup.cs` with the enum only:
> ```csharp
> namespace FreeX.Ribbon;
> public enum RibbonAdaptiveGroupState { Full, SmallWithLabels, IconOnly, Collapsed }
> ```

- [ ] **Step 6: Create `RibbonDefinition.cs`**

```csharp
namespace FreeX.Ribbon;

public enum RibbonContextColor { None, Green, Orange, Purple, Blue, Red, Teal }

public sealed record RibbonTabContext(
    string ActivationKey,
    string Label,
    RibbonContextColor Color);

public sealed record RibbonTab(
    string Id,
    string Header,
    string? KeyTip,
    RibbonTabContext? Context,
    IReadOnlyList<RibbonGroup> Groups)
{
    public bool IsContextual => Context is not null;

    public RibbonGroup? FindGroup(string id)
    {
        foreach (var group in Groups)
            if (string.Equals(group.Id, id, StringComparison.Ordinal))
                return group;
        return null;
    }
}

public sealed record RibbonDefinition(IReadOnlyList<RibbonTab> Tabs)
{
    public IEnumerable<RibbonTab> VisibleTabs => Tabs.Where(t => !t.IsContextual);
    public IEnumerable<RibbonTab> ContextualTabs => Tabs.Where(t => t.IsContextual);

    public RibbonTab? FindTab(string id)
    {
        foreach (var tab in Tabs)
            if (string.Equals(tab.Id, id, StringComparison.Ordinal))
                return tab;
        return null;
    }
}
```

- [ ] **Step 7: Run tests to verify pass**

Run: `dotnet test tests/FreeX.Ribbon.Tests -c Release`
Expected: PASS.

- [ ] **Step 8: Commit**

```bash
git add src/FreeX.Ribbon/Model src/FreeX.Ribbon/Layout/RibbonAdaptiveGroup.cs tests/FreeX.Ribbon.Tests/RibbonDefinitionTests.cs
git commit -m "Add declarative ribbon definition model records"
```

---

### Task 4: Fluent definition builder

**Files:**
- Create: `src/FreeX.Ribbon/Building/RibbonDefinitionBuilder.cs`
- Test: `tests/FreeX.Ribbon.Tests/RibbonDefinitionBuilderTests.cs`

- [ ] **Step 1: Write the failing test**

```csharp
namespace FreeX.Ribbon.Tests;

public class RibbonDefinitionBuilderTests
{
    [Fact]
    public void Builds_TabGroupControl_Hierarchy()
    {
        var definition = new RibbonDefinitionBuilder()
            .Tab("home", "Home", "H", tab => tab
                .Group("clipboard", "Clipboard", "C", priority: 100, g => g
                    .Button("paste", "Paste", b => b with { KeyTip = "V" })))
            .Build();

        var control = definition.FindTab("home")!.FindGroup("clipboard")!.Controls.Single();
        control.Should().BeOfType<RibbonButton>();
        control.KeyTip.Should().Be("V");
    }
}
```

- [ ] **Step 2: Run to verify it fails**

Run: `dotnet test tests/FreeX.Ribbon.Tests -c Release`
Expected: FAIL — `RibbonDefinitionBuilder` not defined.

- [ ] **Step 3: Implement `RibbonDefinitionBuilder.cs`**

```csharp
namespace FreeX.Ribbon;

public sealed class RibbonDefinitionBuilder
{
    private readonly List<RibbonTab> _tabs = new();

    public RibbonDefinitionBuilder Tab(string id, string header, string? keyTip, Action<RibbonTabBuilder> configure)
        => AddTab(id, header, keyTip, context: null, configure);

    public RibbonDefinitionBuilder ContextualTab(string id, string header, RibbonTabContext context, Action<RibbonTabBuilder> configure)
        => AddTab(id, header, keyTip: null, context, configure);

    private RibbonDefinitionBuilder AddTab(string id, string header, string? keyTip, RibbonTabContext? context, Action<RibbonTabBuilder> configure)
    {
        var builder = new RibbonTabBuilder(id, header, keyTip, context);
        configure(builder);
        _tabs.Add(builder.Build());
        return this;
    }

    public RibbonDefinition Build() => new(_tabs.ToArray());
}

public sealed class RibbonTabBuilder
{
    private readonly string _id;
    private readonly string _header;
    private readonly string? _keyTip;
    private readonly RibbonTabContext? _context;
    private readonly List<RibbonGroup> _groups = new();

    internal RibbonTabBuilder(string id, string header, string? keyTip, RibbonTabContext? context)
    {
        _id = id; _header = header; _keyTip = keyTip; _context = context;
    }

    public RibbonTabBuilder Group(string id, string header, string? keyTip, int priority, Action<RibbonGroupBuilder> configure)
    {
        var builder = new RibbonGroupBuilder(id, header, keyTip, priority);
        configure(builder);
        _groups.Add(builder.Build());
        return this;
    }

    internal RibbonTab Build() => new(_id, _header, _keyTip, _context, _groups.ToArray());
}

public sealed class RibbonGroupBuilder
{
    private readonly string _id;
    private readonly string _header;
    private readonly string? _keyTip;
    private readonly int _priority;
    private readonly List<RibbonControl> _controls = new();
    private RibbonGroupSizing _sizing = RibbonGroupSizing.Default;

    internal RibbonGroupBuilder(string id, string header, string? keyTip, int priority)
    {
        _id = id; _header = header; _keyTip = keyTip; _priority = priority;
    }

    public RibbonGroupBuilder Button(string commandId, string label, Func<RibbonButton, RibbonButton>? configure = null)
        => Add(new RibbonButton(commandId, label), configure);

    public RibbonGroupBuilder Toggle(string commandId, string label, Func<RibbonToggleButton, RibbonToggleButton>? configure = null)
        => Add(new RibbonToggleButton(commandId, label), configure);

    public RibbonGroupBuilder Separator() { _controls.Add(new RibbonSeparator()); return this; }

    public RibbonGroupBuilder Sizing(RibbonGroupSizing sizing) { _sizing = sizing; return this; }

    private RibbonGroupBuilder Add<T>(T control, Func<T, T>? configure) where T : RibbonControl
    {
        _controls.Add(configure is null ? control : configure(control));
        return this;
    }

    internal RibbonGroup Build() => new(_id, _header, _keyTip, _priority, _controls.ToArray(), _sizing);
}
```

- [ ] **Step 4: Run tests to verify pass**

Run: `dotnet test tests/FreeX.Ribbon.Tests -c Release`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add src/FreeX.Ribbon/Building tests/FreeX.Ribbon.Tests/RibbonDefinitionBuilderTests.cs
git commit -m "Add fluent RibbonDefinitionBuilder"
```

---

### Task 5: Validator + diagnostics

**Files:**
- Create: `src/FreeX.Ribbon/Validation/RibbonDiagnostics.cs`
- Create: `src/FreeX.Ribbon/Validation/RibbonDefinitionValidator.cs`
- Test: `tests/FreeX.Ribbon.Tests/RibbonDefinitionValidatorTests.cs`

- [ ] **Step 1: Write the failing test**

```csharp
namespace FreeX.Ribbon.Tests;

public class RibbonDefinitionValidatorTests
{
    [Fact]
    public void Flags_DuplicateTabIds()
    {
        var def = new RibbonDefinition(new[]
        {
            new RibbonTab("home", "Home", "H", null, Array.Empty<RibbonGroup>()),
            new RibbonTab("home", "Home2", "J", null, Array.Empty<RibbonGroup>())
        });

        var diagnostics = RibbonDefinitionValidator.Validate(def);

        diagnostics.HasErrors.Should().BeTrue();
        diagnostics.Items.Should().Contain(d => d.Code == "RBN001");
    }

    [Fact]
    public void Clean_Definition_HasNoErrors()
    {
        var def = new RibbonDefinitionBuilder()
            .Tab("home", "Home", "H", t => t
                .Group("g", "G", "G", 1, g => g.Button("paste", "Paste")))
            .Build();

        RibbonDefinitionValidator.Validate(def).HasErrors.Should().BeFalse();
    }
}
```

- [ ] **Step 2: Run to verify it fails**

Run: `dotnet test tests/FreeX.Ribbon.Tests -c Release`
Expected: FAIL — validator not defined.

- [ ] **Step 3: Implement `RibbonDiagnostics.cs`**

```csharp
namespace FreeX.Ribbon;

public enum RibbonDiagnosticSeverity { Info, Warning, Error }

public sealed record RibbonDiagnostic(
    string Code,
    RibbonDiagnosticSeverity Severity,
    string Message);

public sealed class RibbonDiagnostics
{
    public IReadOnlyList<RibbonDiagnostic> Items { get; }
    public RibbonDiagnostics(IReadOnlyList<RibbonDiagnostic> items) => Items = items;
    public bool HasErrors => Items.Any(i => i.Severity == RibbonDiagnosticSeverity.Error);
    public static readonly RibbonDiagnostics Empty = new(Array.Empty<RibbonDiagnostic>());
}
```

- [ ] **Step 4: Implement `RibbonDefinitionValidator.cs`**

```csharp
namespace FreeX.Ribbon;

public static class RibbonDefinitionValidator
{
    public static RibbonDiagnostics Validate(RibbonDefinition definition)
    {
        var items = new List<RibbonDiagnostic>();

        foreach (var dup in Duplicates(definition.Tabs.Select(t => t.Id)))
            items.Add(new RibbonDiagnostic("RBN001", RibbonDiagnosticSeverity.Error,
                $"Duplicate tab id '{dup}'."));

        foreach (var tab in definition.Tabs)
        {
            foreach (var dup in Duplicates(tab.Groups.Select(g => g.Id)))
                items.Add(new RibbonDiagnostic("RBN002", RibbonDiagnosticSeverity.Error,
                    $"Duplicate group id '{dup}' in tab '{tab.Id}'."));

            foreach (var group in tab.Groups)
            {
                if (!group.Sizing.SupportedVariants.Contains(RibbonAdaptiveGroupState.Full))
                    items.Add(new RibbonDiagnostic("RBN003", RibbonDiagnosticSeverity.Error,
                        $"Group '{group.Id}' must support the Full variant."));

                foreach (var dup in Duplicates(group.Controls
                             .Where(c => c is not RibbonSeparator)
                             .Select(c => c.KeyTip)
                             .Where(k => !string.IsNullOrEmpty(k))!))
                    items.Add(new RibbonDiagnostic("RBN004", RibbonDiagnosticSeverity.Warning,
                        $"Duplicate keytip '{dup}' in group '{group.Id}'."));
            }
        }

        return new RibbonDiagnostics(items);
    }

    private static IEnumerable<string> Duplicates(IEnumerable<string> values) =>
        values.GroupBy(v => v, StringComparer.Ordinal)
              .Where(g => g.Count() > 1)
              .Select(g => g.Key);
}
```

- [ ] **Step 5: Run tests to verify pass**

Run: `dotnet test tests/FreeX.Ribbon.Tests -c Release`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add src/FreeX.Ribbon/Validation tests/FreeX.Ribbon.Tests/RibbonDefinitionValidatorTests.cs
git commit -m "Add ribbon definition validator and diagnostics"
```

---

### Task 6: Command registry

**Files:**
- Create: `src/FreeX.Ribbon/Commands/RibbonCommandContracts.cs`
- Create: `src/FreeX.Ribbon/Commands/RibbonCommandRegistry.cs`
- Test: `tests/FreeX.Ribbon.Tests/RibbonCommandRegistryTests.cs`

- [ ] **Step 1: Write the failing test**

```csharp
namespace FreeX.Ribbon.Tests;

public class RibbonCommandRegistryTests
{
    private sealed class CountingCommand : IRibbonCommand
    {
        public int Invocations { get; private set; }
        public void Execute(RibbonCommandContext context) => Invocations++;
    }

    [Fact]
    public void Resolves_RegisteredCommand()
    {
        var registry = new RibbonCommandRegistry();
        var command = new CountingCommand();
        registry.Register("paste", command);

        registry.TryGet("paste", out var resolved).Should().BeTrue();
        resolved!.Execute(RibbonCommandContext.Empty);
        command.Invocations.Should().Be(1);
    }

    [Fact]
    public void Missing_Command_ResolvesFalse()
    {
        new RibbonCommandRegistry().TryGet("nope", out _).Should().BeFalse();
    }
}
```

- [ ] **Step 2: Run to verify it fails**

Run: `dotnet test tests/FreeX.Ribbon.Tests -c Release`
Expected: FAIL.

- [ ] **Step 3: Implement `RibbonCommandContracts.cs`**

```csharp
namespace FreeX.Ribbon;

public sealed record RibbonCommandContext(IReadOnlyDictionary<string, object?> Parameters)
{
    public static readonly RibbonCommandContext Empty =
        new(new Dictionary<string, object?>());
}

public sealed record RibbonCommandState(
    bool IsEnabled = true,
    bool IsChecked = false,
    string? Value = null,
    object? DynamicContent = null)
{
    public static readonly RibbonCommandState Default = new();
}

public interface IRibbonCommand
{
    void Execute(RibbonCommandContext context);
}

public interface IRibbonStatefulCommand : IRibbonCommand
{
    RibbonCommandState GetState();
}
```

- [ ] **Step 4: Implement `RibbonCommandRegistry.cs`**

```csharp
namespace FreeX.Ribbon;

public interface IRibbonCommandRegistry
{
    void Register(RibbonCommandId id, IRibbonCommand command);
    bool TryGet(RibbonCommandId id, out IRibbonCommand? command);
}

public sealed class RibbonCommandRegistry : IRibbonCommandRegistry
{
    private readonly Dictionary<RibbonCommandId, IRibbonCommand> _commands = new();

    public void Register(RibbonCommandId id, IRibbonCommand command)
        => _commands[id] = command;

    public bool TryGet(RibbonCommandId id, out IRibbonCommand? command)
        => _commands.TryGetValue(id, out command);
}
```

- [ ] **Step 5: Run tests to verify pass**

Run: `dotnet test tests/FreeX.Ribbon.Tests -c Release`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add src/FreeX.Ribbon/Commands tests/FreeX.Ribbon.Tests/RibbonCommandRegistryTests.cs
git commit -m "Add ribbon command registry and command contracts"
```

---

### Task 7: Selection-context manager

**Files:**
- Create: `src/FreeX.Ribbon/Context/RibbonContextState.cs`
- Create: `src/FreeX.Ribbon/Context/IRibbonContextSource.cs`
- Create: `src/FreeX.Ribbon/Context/RibbonContextResolver.cs`
- Test: `tests/FreeX.Ribbon.Tests/RibbonContextResolverTests.cs`

- [ ] **Step 1: Write the failing test**

```csharp
namespace FreeX.Ribbon.Tests;

public class RibbonContextResolverTests
{
    private static RibbonDefinition Definition() => new RibbonDefinitionBuilder()
        .Tab("home", "Home", "H", t => { })
        .ContextualTab("chart", "Chart",
            new RibbonTabContext("chart.selected", "Chart Tools", RibbonContextColor.Green),
            t => { })
        .Build();

    [Fact]
    public void Hides_ContextualTab_WhenKeyInactive()
    {
        var visible = RibbonContextResolver.Resolve(Definition(), RibbonContextState.None);
        visible.Select(t => t.Id).Should().ContainSingle().Which.Should().Be("home");
    }

    [Fact]
    public void Shows_ContextualTab_WhenKeyActive()
    {
        var state = RibbonContextState.None.With("chart.selected");
        var visible = RibbonContextResolver.Resolve(Definition(), state);
        visible.Select(t => t.Id).Should().Equal("home", "chart");
    }
}
```

- [ ] **Step 2: Run to verify it fails**

Run: `dotnet test tests/FreeX.Ribbon.Tests -c Release`
Expected: FAIL.

- [ ] **Step 3: Implement `RibbonContextState.cs`**

```csharp
using System.Collections.Immutable;

namespace FreeX.Ribbon;

public sealed class RibbonContextState
{
    private readonly ImmutableHashSet<string> _keys;
    private RibbonContextState(ImmutableHashSet<string> keys) => _keys = keys;

    public static readonly RibbonContextState None =
        new(ImmutableHashSet<string>.Empty.WithComparer(StringComparer.Ordinal));

    public bool IsActive(string key) => _keys.Contains(key);
    public RibbonContextState With(string key) => new(_keys.Add(key));
    public RibbonContextState Without(string key) => new(_keys.Remove(key));
}
```

- [ ] **Step 4: Implement `IRibbonContextSource.cs`**

```csharp
namespace FreeX.Ribbon;

public interface IRibbonContextSource
{
    RibbonContextState Current { get; }
    event EventHandler? ContextChanged;
}
```

- [ ] **Step 5: Implement `RibbonContextResolver.cs`**

```csharp
namespace FreeX.Ribbon;

public static class RibbonContextResolver
{
    public static IReadOnlyList<RibbonTab> Resolve(RibbonDefinition definition, RibbonContextState state)
    {
        var result = new List<RibbonTab>();
        foreach (var tab in definition.Tabs)
        {
            if (tab.Context is null)
                result.Add(tab);
            else if (state.IsActive(tab.Context.ActivationKey))
                result.Add(tab);
        }
        return result;
    }
}
```

- [ ] **Step 6: Run tests to verify pass**

Run: `dotnet test tests/FreeX.Ribbon.Tests -c Release`
Expected: PASS.

- [ ] **Step 7: Commit**

```bash
git add src/FreeX.Ribbon/Context tests/FreeX.Ribbon.Tests/RibbonContextResolverTests.cs
git commit -m "Add ribbon selection-context state and resolver"
```

---

### Task 8: Renderer abstraction, layout plan, measurer interface

**Files:**
- Create: `src/FreeX.Ribbon/Layout/RibbonLayoutPlan.cs`
- Create: `src/FreeX.Ribbon/Layout/IRibbonMeasurer.cs`
- Create: `src/FreeX.Ribbon/Rendering/IRibbonRenderer.cs`

- [ ] **Step 1: Create `RibbonLayoutPlan.cs`**

```csharp
namespace FreeX.Ribbon;

public sealed record RibbonResolvedGroup(
    string GroupId,
    RibbonAdaptiveGroupState State);

public sealed record RibbonLayoutPlan(
    string TabId,
    IReadOnlyList<RibbonResolvedGroup> Groups,
    IReadOnlyList<double> Thresholds);
```

- [ ] **Step 2: Create `IRibbonMeasurer.cs`**

```csharp
namespace FreeX.Ribbon;

public interface IRibbonMeasurer
{
    RibbonAdaptiveGroup Measure(string groupId, IReadOnlyList<RibbonAdaptiveGroupState> supportedVariants);
}
```

> Note: `RibbonAdaptiveGroup` (the record carrying measured widths) is introduced in Task 9. This interface compiles once Task 9 adds that record. Sequence Task 8 immediately before Task 9 or fold the `RibbonAdaptiveGroup` record creation forward.

- [ ] **Step 3: Create `IRibbonRenderer.cs`**

```csharp
namespace FreeX.Ribbon;

public interface IRibbonRenderer
{
    /// <summary>Build the native control tree for a tab once.</summary>
    void Realize(RibbonLayoutPlan plan);

    /// <summary>Diff-apply state changes without rebuilding the tree (realtime reflow).</summary>
    void Apply(RibbonLayoutPlan plan);
}
```

- [ ] **Step 4: Build + commit**

Run: `dotnet build src/FreeX.Ribbon/FreeX.Ribbon.csproj -c Release` (after Task 9 if `RibbonAdaptiveGroup` not yet present).

```bash
git add src/FreeX.Ribbon/Layout src/FreeX.Ribbon/Rendering
git commit -m "Add renderer abstraction, layout plan, and measurer interface"
```

---

## Phase 2 — Relocate the layout engine (test-guarded; touches `FreeX.App.Host`)

### Task 9: Relocate `RibbonAdaptiveGroup` + reconcile the temporary enum

**Files:**
- Create: `src/FreeX.Ribbon/Layout/RibbonAdaptiveGroup.cs` (replace the temporary enum-only file)
- Modify: `src/FreeX.App.Host/FreeX.App.Host.csproj` (add ProjectReference + global using)
- Modify: `src/FreeX.App.Host/RibbonAdaptiveLayoutPlanner.cs` (delete the relocated record/enum)

- [ ] **Step 1: Replace `Layout/RibbonAdaptiveGroup.cs`** with the full record + enum, copied verbatim from `RibbonAdaptiveLayoutPlanner.cs` lines 80–94, re-namespaced to `FreeX.Ribbon`:

```csharp
namespace FreeX.Ribbon;

public sealed record RibbonAdaptiveGroup(
    string Name,
    double FullWidth,
    double SmallWithLabelsWidth,
    double IconOnlyWidth,
    double CollapsedWidth,
    string? CatalogId = null);

public enum RibbonAdaptiveGroupState
{
    Full,
    SmallWithLabels,
    IconOnly,
    Collapsed
}
```

- [ ] **Step 2: Add reference + global using in `FreeX.App.Host.csproj`**

Add a `<ProjectReference Include="..\FreeX.Ribbon\FreeX.Ribbon.csproj" />` and, in an `<ItemGroup>`, `<Using Include="FreeX.Ribbon" />` so every `FreeX.App.Host` file sees the relocated types without per-file edits.

- [ ] **Step 3: Delete the now-duplicated `RibbonAdaptiveGroup` record + `RibbonAdaptiveGroupState` enum** from `src/FreeX.App.Host/RibbonAdaptiveLayoutPlanner.cs` (lines 80–94) and the duplicate enums from `RibbonCommandPresentationTypes.cs` (`RibbonCommandLayoutKind`, `RibbonCommandIcon`, `RibbonCommandIconKind`, `RibbonCommandIconAccent`) — they now live in `FreeX.Ribbon`.

- [ ] **Step 4: Build the whole solution**

Run: `dotnet build FreeX.slnx -c Release`
Expected: Build succeeded (global using resolves the moved types).

- [ ] **Step 5: Commit**

```bash
git add -A
git commit -m "Relocate RibbonAdaptiveGroup and shared enums to FreeX.Ribbon; reference from App.Host"
```

---

### Task 10: Relocate the pure-logic planners

Move these files from `src/FreeX.App.Host/` to `src/FreeX.Ribbon/Layout/`, re-namespacing each from `FreeX.App.Host` to `FreeX.Ribbon`: `RibbonAdaptiveLayoutPlanner.cs`, `RibbonAdaptivePriorityPlanner.cs`, `RibbonAdaptiveLayoutEngine.cs`, `RibbonResizeThresholdGate.cs`, `RibbonCommandPresentationPlanner.cs`, `RibbonCommandPresentationPlanner.Icons.cs`, `RibbonAdaptiveTabProfiles.cs`. Any of these that reference WPF types must NOT move (verify with grep first); from the earlier audit all seven are pure.

**Files:**
- Move (git mv): the seven files above into `src/FreeX.Ribbon/Layout/`
- Modify: `tests/FreeX.App.Host.Logic.Tests/FreeX.App.Host.Logic.Tests.csproj` (add `<Using Include="FreeX.Ribbon" />` or `ProjectReference` to `FreeX.Ribbon`)

- [ ] **Step 1: Verify purity before moving**

Run: `cd src/FreeX.App.Host && for f in RibbonAdaptiveLayoutPlanner RibbonAdaptivePriorityPlanner RibbonAdaptiveLayoutEngine RibbonResizeThresholdGate RibbonCommandPresentationPlanner RibbonCommandPresentationPlanner.Icons RibbonAdaptiveTabProfiles; do grep -l "System.Windows" "$f.cs" && echo "WPF: $f"; done`
Expected: no output (all pure).

- [ ] **Step 2: Move the files**

```bash
git mv src/FreeX.App.Host/RibbonAdaptiveLayoutPlanner.cs src/FreeX.Ribbon/Layout/
git mv src/FreeX.App.Host/RibbonAdaptivePriorityPlanner.cs src/FreeX.Ribbon/Layout/
git mv src/FreeX.App.Host/RibbonAdaptiveLayoutEngine.cs src/FreeX.Ribbon/Layout/
git mv src/FreeX.App.Host/RibbonResizeThresholdGate.cs src/FreeX.Ribbon/Layout/
git mv src/FreeX.App.Host/RibbonCommandPresentationPlanner.cs src/FreeX.Ribbon/Layout/
git mv src/FreeX.App.Host/RibbonCommandPresentationPlanner.Icons.cs src/FreeX.Ribbon/Layout/
git mv src/FreeX.App.Host/RibbonAdaptiveTabProfiles.cs src/FreeX.Ribbon/Layout/
```

- [ ] **Step 3: Re-namespace each moved file**

In each moved file change `namespace FreeX.App.Host;` to `namespace FreeX.Ribbon;`. Remove the now-duplicate `RibbonAdaptiveGroup`/`RibbonAdaptiveGroupState` definitions from `RibbonAdaptiveLayoutPlanner.cs` (already created in Task 9) and the icon/layout enums from the presentation planner types if any remain.

- [ ] **Step 4: Add `FreeX.Ribbon` visibility to the logic test project**

Add `<Using Include="FreeX.Ribbon" />` to `tests/FreeX.App.Host.Logic.Tests/FreeX.App.Host.Logic.Tests.csproj` (it already transitively references `FreeX.Ribbon` through `FreeX.App.Host`).

- [ ] **Step 5: Build + run the relocated engine tests**

Run: `dotnet build FreeX.slnx -c Release`
Then: `dotnet test tests/FreeX.App.Host.Logic.Tests -c Release`
Expected: the existing `RibbonResizeThresholdGateTests`, `RibbonAdaptiveLayoutPlannerTests`, `RibbonAdaptivePriorityPlannerTests`, `RibbonCommandPresentationPlannerTests` all pass unchanged — proving the relocation is behavior-preserving.

- [ ] **Step 6: Commit**

```bash
git add -A
git commit -m "Relocate pure-logic ribbon layout planners into FreeX.Ribbon"
```

---

### Task 11: Mirror relocated-engine tests into `FreeX.Ribbon.Tests`

So the core has standalone coverage independent of `FreeX.App.Host`, link (not copy) the four relocated test files into the new test project.

**Files:**
- Modify: `tests/FreeX.Ribbon.Tests/FreeX.Ribbon.Tests.csproj`

- [ ] **Step 1: Add linked compile items**

In `FreeX.Ribbon.Tests.csproj` add:

```xml
<ItemGroup>
  <Compile Include="..\FreeX.App.Host.Logic.Tests\RibbonResizeThresholdGateTests.cs" Link="RibbonResizeThresholdGateTests.cs" />
  <Compile Include="..\FreeX.App.Host.Logic.Tests\RibbonAdaptiveLayoutPlannerTests.cs" Link="RibbonAdaptiveLayoutPlannerTests.cs" />
  <Compile Include="..\FreeX.App.Host.Logic.Tests\RibbonAdaptivePriorityPlannerTests.cs" Link="RibbonAdaptivePriorityPlannerTests.cs" />
  <Compile Include="..\FreeX.App.Host.Logic.Tests\RibbonCommandPresentationPlannerTests.cs" Link="RibbonCommandPresentationPlannerTests.cs" />
</ItemGroup>
```

If any linked test references a `FreeX.App.Host` namespace, add `<Using Include="FreeX.App.Host" />` is NOT possible (no ref); instead confirm these four tests only use `FreeX.Ribbon` types (they should after relocation). If a test still needs an App.Host helper, leave it only in the Logic.Tests project and do not link it.

- [ ] **Step 2: Run**

Run: `dotnet test tests/FreeX.Ribbon.Tests -c Release`
Expected: PASS (engine tests now run against the core directly).

- [ ] **Step 3: Commit**

```bash
git add tests/FreeX.Ribbon.Tests
git commit -m "Run relocated engine tests against FreeX.Ribbon directly"
```

---

## Phase 3 — Golden snapshot parity gate (big-bang safety net)

### Task 12: Capture today's catalog as a golden snapshot

The existing `RibbonXamlCatalogSnapshotReader` (in `FreeX.App.Host.Tests`) parses `MainWindow.xaml` into the old `RibbonCatalog`. Capture its output to a committed JSON file and add a test asserting it is stable. This freezes the contract the new `RibbonDefinition` (authored in SP2) must reproduce.

**Files:**
- Create: `tests/FreeX.App.Host.Tests/__snapshots__/ribbon-catalog.golden.json`
- Create: `tests/FreeX.App.Host.Tests/RibbonCatalogGoldenSnapshotTests.cs`

- [ ] **Step 1: Write the snapshot test (generates on first run, asserts thereafter)**

```csharp
using System.IO;
using System.Text.Json;

namespace FreeX.App.Host.Tests;

public class RibbonCatalogGoldenSnapshotTests
{
    [Fact]
    public void CatalogMatchesGoldenSnapshot()
    {
        var catalog = RibbonXamlCatalogSnapshotReader.ReadMainWindow();
        var actual = JsonSerializer.Serialize(catalog, new JsonSerializerOptions { WriteIndented = true });

        var path = Path.Combine(
            WorkspaceFileLocator.FindRepositoryRoot(),
            "tests", "FreeX.App.Host.Tests", "__snapshots__", "ribbon-catalog.golden.json");

        if (!File.Exists(path))
        {
            Directory.CreateDirectory(Path.GetDirectoryName(path)!);
            File.WriteAllText(path, actual);
        }

        var expected = File.ReadAllText(path);
        actual.Should().Be(expected,
            "the ribbon catalog changed; if intentional, delete the golden file to regenerate");
    }
}
```

> `WorkspaceFileLocator` already exists in `FreeX.App.Host.Tests` (it is linked into the logic-tests project). If its API differs, use `DialogSourceTestSupport.FindHostSourceFile("MainWindow.xaml")` to derive the repo root.

- [ ] **Step 2: Run twice (generate, then verify)**

Run: `dotnet test tests/FreeX.App.Host.Tests -c Release --filter FullyQualifiedName~RibbonCatalogGoldenSnapshot`
Expected: first run generates the file and passes; a second run passes against the committed file.

- [ ] **Step 3: Commit**

```bash
git add tests/FreeX.App.Host.Tests/__snapshots__/ribbon-catalog.golden.json tests/FreeX.App.Host.Tests/RibbonCatalogGoldenSnapshotTests.cs
git commit -m "Capture ribbon catalog golden snapshot as SP2 big-bang parity gate"
```

---

### Task 13: Full-suite verification

- [ ] **Step 1: Build everything**

Run: `dotnet build FreeX.slnx -c Release`
Expected: Build succeeded.

- [ ] **Step 2: Run the default test suite**

Run: `dotnet test FreeX.DefaultTests.slnx -c Release --no-build`
Expected: all green, including the relocated engine tests and the new `FreeX.Ribbon.Tests`.

- [ ] **Step 3: Final commit if any fixups were needed**

```bash
git add -A
git commit -m "Fix up SP1 ribbon core integration"
```

---

## Self-Review

**Spec coverage:**
- Definition model → Tasks 2, 3. Builder → Task 4. JSON loader: the spec lists `FreeX.Ribbon.Serialization` as optional; deferred — see note below. Command registry → Task 6. Context manager → Task 7. Layout engine relocation + measurement contract → Tasks 8–11. Renderer abstraction → Task 8. Validation → Task 5. Golden snapshot → Task 12. Out-of-scope items (rendering, XAML deletion, contextual content) correctly excluded.
- **Deferred from this plan:** the optional `FreeX.Ribbon.Serialization` JSON (de)serializer and its round-trip test. The typed model is the canonical source (per spec); JSON load is explicitly "optional." It adds no value until a consumer needs runtime-loaded definitions (SP4 customization). Pulled out to keep SP1 focused; tracked as a follow-up task in SP4. The validator already accepts any `RibbonDefinition` regardless of origin, so adding the loader later requires no core change.
- **Profile generalization (spec §Layout "profiles become data-driven"):** Task 10 relocates `RibbonAdaptiveTabProfiles` verbatim (behavior-preserving). Converting it from hardcoded-Home to definition-driven is the genuinely new layout work; it is staged as the first task of SP2 (where a real `RibbonDefinition` exists to drive it) rather than SP1, because SP1 authors no full definition. Noted here so it is not lost.

**Placeholder scan:** no TBD/TODO; every code step contains complete code.

**Type consistency:** `RibbonCommandId` (struct, implicit from string) used consistently; `RibbonAdaptiveGroupState` introduced temporarily in Task 3 and reconciled in Task 9; `RibbonAdaptiveGroup` introduced in Task 9 before its first use in `IRibbonMeasurer` (Task 8 note flags the ordering); registry signature `TryGet(id, out IRibbonCommand?)` matches its test usage.
