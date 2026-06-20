# Ribbon Core (`FreeX.Ribbon`) — Design

Date: 2026-06-15
Status: Approved for planning
Sub-project: **SP1** of the modular ribbon program

## Goal

Make the FreeX ribbon **modular, customizable (declarative-definition-driven), responsive,
fast (realtime), reusable across apps, and portable across UI frameworks** — including a
working Avalonia renderer for macOS/Linux. This document specifies **SP1: the
platform-neutral ribbon core** — the foundation every renderer and later sub-project plugs into.

## Program context (the whole effort)

The work is decomposed into four sub-projects, each with its own spec → plan → implementation cycle:

| SP | Title | Outcome |
|----|-------|---------|
| **SP1** | `FreeX.Ribbon` core (this spec) | Platform-neutral definition model, command registry, context manager, layout engine, renderer abstraction. No rendering. |
| SP2 | WPF renderer + big-bang cutover | `IRibbonRenderer` for WPF; register existing handlers by `CommandId`; delete ~3,775 lines of ribbon XAML; realtime reflow. |
| SP3 | Avalonia renderer | Same core + same definition rendered on macOS/Linux; closes Avalonia gaps (icons, keytips, popups). |
| SP4 | Contextual tabs + non-Home polish | Wire chart/table/pivot/picture/header-footer contextual tabs; retune non-Home tabs for best space use. |

Two decisions fixed at brainstorming:

1. **Cross-platform scope:** portable core **and** a working Avalonia renderer (SP3), not just a portable seam.
2. **Migration strategy:** **big-bang rewrite** — the declarative definition becomes the single source of truth and the hand-authored ribbon XAML is deleted (in SP2), guarded by a golden snapshot (below).

### Decisions locked in

- **Definition is typed-C#-canonical with optional JSON load**, not JSON-only. Structure lives in
  the definition; behavior lives in the command registry. Galleries, split buttons, live preview,
  and dynamic combobox content cannot be expressed as pure data, so a data-only model is rejected.
- **Office layout model, no row-wrapping.** "Best use of space" = pick the richest per-group size
  variant set that fits the available width, collapsing lowest-priority groups to popups first, and
  promoting to larger variants when there is surplus. Ribbon rows never wrap.

## Current state (what SP1 builds on)

- The ribbon today is **XAML-first**: ~3,775 lines of hand-authored markup in
  `src/FreeX.App.Host/MainWindow.xaml` (a 6,017-line file). Each command is hand-coded with
  `Click=` handlers, `Style` refs, and attached properties.
- A declarative model already exists — `RibbonCatalog` (Tab → Group → Command → MenuItem records) —
  but it is **derived from** the XAML by a test-side parser (`RibbonXamlCatalogSnapshotReader`) and
  used only for analysis (adaptive planning, keytip routing, screenshot tours). SP1 promotes this
  model to the **source of truth**.
- The responsive engine is already **pure logic** (no WPF): `RibbonAdaptiveLayoutEngine`,
  `RibbonAdaptiveLayoutPlanner`, `RibbonAdaptivePriorityPlanner`, `RibbonAdaptiveTabProfiles`,
  `RibbonResizeThresholdGate`, `RibbonCommandPresentationPlanner`. These relocate into the core.
- Variant widths (`FullWidth`, `SmallWithLabelsWidth`, `IconOnlyWidth`, `CollapsedWidth` on
  `RibbonAdaptiveGroup`) are **measured from rendered XAML** today. The core must therefore take
  widths as an *input* from the renderer rather than computing them — formalized as `IRibbonMeasurer`.
- "Only redraws after resize" is a **deliberate defer-to-exit** (`_ribbonResizeCompactionPendingOnExit`
  in `MainWindow.Ribbon.cs`), not a cost problem. SP1 keeps the threshold gate (which makes reflow
  cheap); SP2 removes the deferral to make reflow realtime.

## Architecture

### Projects

- **`FreeX.Ribbon`** — `net10.0` (no `-windows`, no `UseWPF`/`UseWindowsForms`), BCL only.
  References nothing in `FreeX.App.*`. NuGet-extractable.
- **`FreeX.Ribbon.Serialization`** — optional JSON loader; isolates `System.Text.Json` from the pure core.
- Renderers (`FreeX.Ribbon.Wpf`, `Free.Shared.Ribbon.Avalonia`) are out of scope for SP1 (SP2/SP3).
- **`FreeX.Ribbon.Tests`** — pure-logic xUnit tests (mirrors the existing `*.Logic.Tests` style).

### 1. Definition model (source of truth)

Immutable records, the enriched successor to `RibbonCatalog`:

- `RibbonDefinition(IReadOnlyList<RibbonTab> Tabs)`
- `RibbonTab(string Id, string Header, string? KeyTip, RibbonTabContext? Context, IReadOnlyList<RibbonGroup> Groups)`
  — `Context == null` ⇒ normal tab; non-null ⇒ contextual.
- `RibbonTabContext(string ActivationKey, string Label, RibbonContextColor Color)` — Office-style
  "Chart Tools" grouping/coloring; `ActivationKey` matched against the context state.
- `RibbonGroup(string Id, string Header, string? KeyTip, int Priority, IReadOnlyList<RibbonControl> Controls, RibbonGroupSizing Sizing)`
  — `Priority` drives collapse order (lowest priority collapses first), replacing today's right-to-left heuristic.
- `RibbonControl` — discriminated hierarchy (abstract base + sealed subtypes):
  `RibbonButton`, `RibbonToggleButton`, `RibbonSplitButton`, `RibbonDropdown`, `RibbonGallery`,
  `RibbonComboBox`, `RibbonCheckBox`, `RibbonLabel`, `RibbonSeparator`.
  Common members: `RibbonCommandId CommandId`, `string Label`, `string? KeyTip`,
  `RibbonCommandIcon Icon` (reuse existing enum), `RibbonCommandLayoutKind PreferredLayout`
  (Small/Medium/Large — reuse existing), tooltip `Title`/`Description`. Split/dropdown carry `RibbonMenu Menu`.
- `RibbonMenu(IReadOnlyList<RibbonMenuItem> Items)` and
  `RibbonMenuItem(string Header, RibbonCommandId? CommandId, string? KeyTip, string? InputGesture, RibbonMenuItemKind Kind, IReadOnlyList<RibbonMenuItem> Children)`.
- `RibbonGroupSizing(IReadOnlyList<RibbonAdaptiveGroupState> SupportedVariants, RibbonWidthHints? Hints)`
  — declares which size variants a group supports plus optional first-frame width hints.

Construction: a fluent **`RibbonDefinitionBuilder`** (type-safe). JSON mirrors the records 1:1 and is
validated on load (see Validation). Reuse the existing `RibbonCommandIcon`, `RibbonCommandIconKind`,
`RibbonCommandIconAccent`, `RibbonCommandLayoutKind`, and `RibbonAdaptiveGroupState` enums (moved into the core).

### 2. Command registry & host contracts

- `readonly record struct RibbonCommandId(string Value)` — strongly typed; prevents string typos.
- `interface IRibbonCommand { void Execute(RibbonCommandContext context); }`
- `interface IRibbonStatefulCommand : IRibbonCommand { RibbonCommandState GetState(); }`
  where `RibbonCommandState(bool IsEnabled, bool IsChecked, string? Value, object? DynamicContent)`.
  `DynamicContent` powers gallery items / combobox option lists.
- `interface IRibbonCommandRegistry { void Register(RibbonCommandId id, IRibbonCommand command); bool TryGet(RibbonCommandId id, out IRibbonCommand command); }`
- The host (MainWindow today) registers each existing handler under its `CommandId` at startup,
  replacing `Click=` wiring. A control whose `CommandId` is **unregistered renders disabled and emits
  a diagnostic — never throws.**

### 3. Selection-context manager

- `RibbonContextState` — immutable set of active context keys (e.g. `"chart.selected"`, `"table.active"`).
- `interface IRibbonContextSource { RibbonContextState Current { get; } event EventHandler ContextChanged; }`
  — the host owns *what* qualifies as each context; the core only consumes keys.
- `static RibbonContextResolver.Resolve(RibbonDefinition definition, RibbonContextState state)`
  → ordered list of currently-visible tabs (normal tabs + activated contextual tabs), each carrying its
  `RibbonTabContext` for coloring/labels. Pure function, fully unit-testable.

### 4. Layout engine (relocate + generalize)

Relocate the pure-logic planners into the core, with two generalizations:

- **Profiles become data-driven.** `RibbonAdaptiveTabProfiles` currently hardcodes Home. Replace the
  hardcoded per-tab tuning with per-group `Priority` + `Sizing` read from the definition, so every tab
  (including contextual tabs) gets adaptive behavior. The existing Home behavior becomes the default
  derivation and is locked by the golden snapshot.
- **Measurement is an explicit input.** `interface IRibbonMeasurer { RibbonAdaptiveGroup Measure(string groupId, IReadOnlyList<RibbonAdaptiveGroupState> supportedVariants); }`.
  The renderer supplies measured variant widths; declared `Sizing.Hints` seed the first frame before
  measurement is available. This is the existing measured-correction loop, formalized as the single
  contract the engine needs from a platform.

Engine inputs/outputs are otherwise unchanged: `Plan(availableWidth, groups, fixedChromeWidth, selectedTabHeader)`
→ `RibbonAdaptiveGroupState[]` + breakpoint thresholds; the `RibbonResizeThresholdGate` is retained verbatim.

### 5. Renderer abstraction & the realtime loop

- `interface IRibbonRenderer { void Realize(RibbonLayoutPlan plan); void Apply(RibbonLayoutPlan plan); }`
  — `Realize` builds the native tree once per tab/context change; `Apply` **diff-applies** state changes
  (generalizing today's `RibbonAdaptiveStateApplicator` so reflow never rebuilds the tree).
- `RibbonLayoutPlan(IReadOnlyList<RibbonResolvedGroup> Groups, IReadOnlyList<double> Thresholds, ...)`
  — ordered groups, per-group `RibbonAdaptiveGroupState`, collapsed-to-popup set, keytip scopes.
- **Realtime loop (consumed by SP2/SP3, defined here):** on width change the host calls
  `engine.Plan(width)`; `RibbonResizeThresholdGate` short-circuits unless a breakpoint is crossed; on a
  crossing the host calls `renderer.Apply(plan)`. Cheap because crossings are rare and diffs are minimal.

### 6. Validation & error handling

- `static RibbonDefinitionValidator.Validate(RibbonDefinition definition) → RibbonDiagnostics` — detects
  duplicate ids, duplicate/missing keytips within a scope, unknown command refs (when a registry is
  supplied), and invalid sizing (e.g. a supported-variant list that omits `Full`).
- JSON load runs the validator and surfaces diagnostics; the in-code definition is checked by a
  build-time test. Failures **degrade gracefully** (disabled control + diagnostic), never crash.

## Data flow

```
RibbonDefinition (typed or JSON)
   │  validate
   ▼
RibbonContextResolver.Resolve(definition, contextState) ──▶ visible tabs (incl. contextual)
   │
   ▼  on tab change / resize
IRibbonMeasurer.Measure(...) ──▶ RibbonAdaptiveGroup widths
   │
   ▼
RibbonAdaptiveLayoutEngine.Plan(width, groups, ...) ──▶ RibbonLayoutPlan (+ thresholds, via gate)
   │
   ▼
IRibbonRenderer.Realize / Apply ──▶ native controls
   │  user invokes control (CommandId)
   ▼
IRibbonCommandRegistry.TryGet(id) ──▶ IRibbonCommand.Execute(context) ──▶ host
```

## Testing strategy

- **Port existing pure-logic tests** onto the relocated engine — `RibbonResizeThresholdGateTests`,
  `RibbonAdaptiveLayoutPlannerTests`, `RibbonAdaptivePriorityPlannerTests`,
  `RibbonCommandPresentationPlannerTests`. They should pass with namespace-only changes, proving the
  relocation is behavior-preserving.
- **New tests:** `RibbonDefinitionBuilder` construction, JSON round-trip (serialize → deserialize →
  equal), `RibbonDefinitionValidator` diagnostics, `RibbonContextResolver` activation, command registry
  register/resolve/missing-id-disabled.
- **Golden snapshot (big-bang safety net):** capture today's XAML-derived `RibbonCatalog` (via the
  existing `RibbonXamlCatalogSnapshotReader`) to a committed JSON file under
  `tests/.../__snapshots__/ribbon-catalog.golden.json`. A core test asserts the new `RibbonDefinition`
  reproduces it — same tabs, groups, commands, keytips, and handler/command ids. **SP2 must satisfy this
  snapshot before any XAML is deleted.**

## Out of scope for SP1 (YAGNI / deferred)

- No WPF or Avalonia rendering (SP2/SP3).
- No deletion of ribbon XAML (SP2).
- No new contextual-tab *content* or non-Home retuning (SP4) — SP1 builds only the *mechanism*.
- No live-preview/gallery hover behavior beyond the `DynamicContent` hook on `RibbonCommandState`.

## Risks & mitigations

| Risk | Mitigation |
|------|------------|
| Relocating planners changes behavior subtly | Port the existing tests verbatim; they are the behavior oracle. |
| New definition omits commands present in XAML | Golden snapshot test fails the build until parity is reached. |
| Data-driven profiles regress Home's tuned layout | Home's current profile is the default derivation, locked by the snapshot + ported planner tests. |
| Measurement contract leaks platform types into core | `IRibbonMeasurer` returns the existing platform-neutral `RibbonAdaptiveGroup` (doubles only). |

## Success criteria

- `FreeX.Ribbon` compiles as `net10.0` with no UI-framework dependency.
- All ported planner tests pass unchanged in spirit.
- New definition/validator/context/registry tests pass.
- The golden-snapshot test passes: the new `RibbonDefinition` reproduces today's ribbon catalog.
- No change to `MainWindow.xaml` or runtime behavior yet (SP1 is additive; cutover is SP2).
