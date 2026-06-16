# Release Prep: File Associations & Self-Update — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship FreeX as a Velopack-managed app that installs (or runs portable), registers native+neutral file associations without stealing Office's defaults, and quietly self-updates from GitHub Releases via a discreet status-bar indicator.

**Architecture:** A cross-platform service layer (`FreeX.App.Services`) defines `IUpdateService` and `IFileAssociationService` plus a Velopack-backed update service. The WPF host (`FreeX.App.Host`) bootstraps Velopack, registers Windows registry associations in install/uninstall hooks, and shows a status-bar indicator. The Avalonia host (`FreeX.App.Avalonia`) declares associations in `Info.plist` and shows an equivalent indicator. Packaging is driven by `vpk pack` wired into the existing publish script and CI workflows. Both an installer and a portable build come from one pack step; both auto-update.

**Tech Stack:** .NET 10, WPF, Avalonia, [Velopack](https://docs.velopack.io) (MIT, cross-platform), Windows registry (HKCU), macOS Launch Services / `Info.plist`, PowerShell publish scripts, GitHub Actions.

**Spec:** [docs/superpowers/specs/2026-06-16-release-prep-associations-selfupdate-design.md](../specs/2026-06-16-release-prep-associations-selfupdate-design.md)

---

## File Structure

### Phase A — shared core (`FreeX.App.Services`, `net10.0`)
- Create: `src/FreeX.App.Services/Updates/IUpdateService.cs` — abstraction + result types.
- Create: `src/FreeX.App.Services/Updates/UpdateStatus.cs` — enum/record describing check outcome.
- Create: `src/FreeX.App.Services/Updates/VelopackUpdateService.cs` — Velopack-backed impl + graceful no-manager fallback.
- Create: `src/FreeX.App.Services/Updates/UpdateFeed.cs` — feed URL + channel resolution (pure, testable).
- Create: `src/FreeX.App.Services/FileAssociations/IFileAssociationService.cs` — abstraction.
- Create: `src/FreeX.App.Services/FileAssociations/FileAssociationDefinition.cs` — the static catalog of which extensions FreeX owns vs offers (pure data, testable).
- Test: `tests/FreeX.App.Services.Tests/Updates/UpdateFeedTests.cs`
- Test: `tests/FreeX.App.Services.Tests/Updates/UpdateServiceDecisionTests.cs`
- Test: `tests/FreeX.App.Services.Tests/FileAssociations/FileAssociationDefinitionTests.cs`
- Modify: `Directory.Packages.props` — add `Velopack` version.

### Phase B — Windows (`FreeX.App.Host`, `net10.0-windows`)
- Create: `src/FreeX.App.Host/Updates/UpdateIndicator.xaml(.cs)` — discreet status-bar control (or inline XAML in `MainWindow.xaml`).
- Create: `src/FreeX.App.Host/FileAssociations/WindowsFileAssociationService.cs` — HKCU ProgId + OpenWith registry, `SHChangeNotify`.
- Create: `src/FreeX.App.Host/VelopackBootstrap.cs` — `VelopackApp.Build()...Run()` + install/uninstall hooks.
- Modify: `src/FreeX.App.Host/App.xaml.cs` — call bootstrap first; register `IUpdateService`/`IFileAssociationService` in DI; start background update check.
- Modify: `src/FreeX.App.Host/MainWindow.xaml:1189` (`StatusBarRoot`) — host the indicator at the right edge.
- Modify: `src/FreeX.App.Host/MainWindow.ReviewCommands.cs` — rewire `CheckForUpdatesBtn_Click` to `IUpdateService`.
- Modify: `src/FreeX.App.Host/AppInfo.cs` / delete `AppUpdateSource.cs` usage — keep release URL constant for fallback only.
- Modify: `src/FreeX.App.Host/FreeX.App.Host.csproj` — `PackageReference Include="Velopack"`.
- Modify: `tools/Publish-UserTestBuild.ps1` — add `Velopack` publish mode (calls `vpk pack`).
- Modify: `.github/workflows/tester-release.yml` — add a Velopack pack/upload step.
- Test: `tests/FreeX.App.Host.Tests/FileAssociations/WindowsFileAssociationServiceTests.cs` (redirected test hive).

### Phase C — macOS (`FreeX.App.Avalonia`)
- Create: `src/FreeX.App.Avalonia/MacOs/MacFileAssociationService.cs` (compiled on `net10.0-macos`) — Launch Services status/query; registration is declarative.
- Create: `src/FreeX.App.Avalonia/MacOs/NoOpFileAssociationService.cs` — `net10.0` non-mac fallback so DI always resolves.
- Modify: `src/FreeX.App.Avalonia/Packaging/macos/Info.plist` (create if absent) — `CFBundleDocumentTypes` + `UTExportedTypeDeclarations`.
- Create/Modify: Avalonia main window chrome — discreet update indicator bound to `IUpdateService`.
- Modify: Avalonia startup — `VelopackApp.Build().Run()` first; DI registration; background check.
- Modify: `.github/workflows/macos-app.yml` — `vpk pack` for the `.app` bundle.

---

## PHASE A — Shared Core

> Land and verify this phase first. Phases B and C code against these signatures. If running all three phases in parallel, freeze the signatures in Task A1–A3 before B/C start.

### Task A1: Add Velopack package reference

**Files:**
- Modify: `Directory.Packages.props`

- [ ] **Step 1: Find the latest stable Velopack version**

Run: `dotnet package search Velopack --exact-match --format json` (or check https://www.nuget.org/packages/Velopack). Use the latest stable (expected `0.0.x`/`0.4.x` line — pin whatever is current).

- [ ] **Step 2: Add the version to central package management**

In `Directory.Packages.props`, inside the `<ItemGroup>` of `<PackageVersion>` entries, add (use the resolved version):

```xml
<PackageVersion Include="Velopack" Version="X.Y.Z" />
```

- [ ] **Step 3: Reference it from the shared services project**

In `src/FreeX.App.Services/FreeX.App.Services.csproj`, add an `<ItemGroup>`:

```xml
<ItemGroup>
  <PackageReference Include="Velopack" />
</ItemGroup>
```

- [ ] **Step 4: Restore and confirm it resolves**

Run: `dotnet restore FreeX.slnx`
Expected: completes with no NU1xxx errors; Velopack restored.

- [ ] **Step 5: Commit**

```bash
git add Directory.Packages.props src/FreeX.App.Services/FreeX.App.Services.csproj
git commit -m "build: add Velopack package for self-update"
```

---

### Task A2: File association catalog (pure data) + tests

**Files:**
- Create: `src/FreeX.App.Services/FileAssociations/FileAssociationDefinition.cs`
- Create: `src/FreeX.App.Services/FileAssociations/IFileAssociationService.cs`
- Test: `tests/FreeX.App.Services.Tests/FileAssociations/FileAssociationDefinitionTests.cs`

- [ ] **Step 1: Write the failing test**

```csharp
using FluentAssertions;
using FreeX.App.Services.FileAssociations;
using Xunit;

namespace FreeX.App.Services.Tests.FileAssociations;

public class FileAssociationDefinitionTests
{
    [Fact]
    public void Catalog_OwnsOnlyFxl()
    {
        var owned = FileAssociationDefinition.All
            .Where(d => d.Ownership == AssociationOwnership.Default)
            .Select(d => d.Extension)
            .ToArray();

        owned.Should().BeEquivalentTo(new[] { ".fxl" });
    }

    [Fact]
    public void Catalog_OffersNeutralTypesWithoutStealingDefault()
    {
        foreach (var ext in new[] { ".csv", ".tsv", ".tab", ".txt", ".xml", ".xlsx", ".xls" })
        {
            var def = FileAssociationDefinition.All.Single(d => d.Extension == ext);
            def.Ownership.Should().Be(AssociationOwnership.OpenWith,
                $"{ext} must be offered via Open With, never made the default handler");
        }
    }

    [Fact]
    public void EveryDefinition_HasProgIdAndFriendlyName()
    {
        foreach (var def in FileAssociationDefinition.All)
        {
            def.ProgId.Should().StartWith("FreeX.");
            def.FriendlyName.Should().NotBeNullOrWhiteSpace();
            def.Extension.Should().StartWith(".");
        }
    }
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `dotnet test FreeX.DefaultTests.slnx -c Release --filter FileAssociationDefinitionTests`
Expected: FAIL — `FileAssociationDefinition` does not exist.

- [ ] **Step 3: Write the catalog and interface**

`src/FreeX.App.Services/FileAssociations/FileAssociationDefinition.cs`:

```csharp
namespace FreeX.App.Services.FileAssociations;

/// <summary>How aggressively FreeX claims a file extension.</summary>
public enum AssociationOwnership
{
    /// <summary>FreeX becomes the default handler (only for types nobody else owns).</summary>
    Default,
    /// <summary>FreeX is added to the "Open with" list but the existing default handler is preserved.</summary>
    OpenWith,
}

/// <summary>One file type FreeX can handle, and how it should be registered.</summary>
public sealed record FileAssociationDefinition(
    string Extension,
    string ProgId,
    string FriendlyName,
    AssociationOwnership Ownership)
{
    /// <summary>
    /// The full association policy. Native FreeX files (.fxl) are owned outright; everything
    /// else is offered via "Open with" so we never steal Excel/Notepad defaults on install.
    /// </summary>
    public static IReadOnlyList<FileAssociationDefinition> All { get; } = new[]
    {
        new FileAssociationDefinition(".fxl",  "FreeX.Workbook.fxl",      "FreeX Workbook",          AssociationOwnership.Default),
        new FileAssociationDefinition(".csv",  "FreeX.Workbook.csv",      "CSV (FreeX)",             AssociationOwnership.OpenWith),
        new FileAssociationDefinition(".tsv",  "FreeX.Workbook.tsv",      "Tab-Separated (FreeX)",   AssociationOwnership.OpenWith),
        new FileAssociationDefinition(".tab",  "FreeX.Workbook.tab",      "Tab-Delimited (FreeX)",   AssociationOwnership.OpenWith),
        new FileAssociationDefinition(".txt",  "FreeX.Workbook.txt",      "Text (FreeX)",            AssociationOwnership.OpenWith),
        new FileAssociationDefinition(".xml",  "FreeX.Workbook.xml",      "SpreadsheetML (FreeX)",   AssociationOwnership.OpenWith),
        new FileAssociationDefinition(".xlsx", "FreeX.Workbook.xlsx",     "XLSX Workbook (FreeX)",   AssociationOwnership.OpenWith),
        new FileAssociationDefinition(".xls",  "FreeX.Workbook.xls",      "Legacy XLS (FreeX)",      AssociationOwnership.OpenWith),
    };
}
```

`src/FreeX.App.Services/FileAssociations/IFileAssociationService.cs`:

```csharp
namespace FreeX.App.Services.FileAssociations;

/// <summary>
/// Registers/unregisters FreeX as a handler for supported file types on the current OS.
/// All methods are best-effort: failures are logged by the implementation and never thrown
/// to the caller, so installation/startup is never blocked by association problems.
/// </summary>
public interface IFileAssociationService
{
    /// <summary>Register FreeX for all definitions in <see cref="FileAssociationDefinition.All"/>.</summary>
    void RegisterAll(string executablePath);

    /// <summary>Remove every FreeX association this app created. Used on uninstall.</summary>
    void UnregisterAll();

    /// <summary>True if FreeX is currently the default handler for the given extension.</summary>
    bool IsDefaultHandler(string extension);
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `dotnet test FreeX.DefaultTests.slnx -c Release --filter FileAssociationDefinitionTests`
Expected: PASS (3 tests).

- [ ] **Step 5: Commit**

```bash
git add src/FreeX.App.Services/FileAssociations tests/FreeX.App.Services.Tests/FileAssociations
git commit -m "feat: file association catalog (native+neutral policy) and interface"
```

---

### Task A3: Update feed/channel resolution (pure) + tests

**Files:**
- Create: `src/FreeX.App.Services/Updates/UpdateFeed.cs`
- Test: `tests/FreeX.App.Services.Tests/Updates/UpdateFeedTests.cs`

- [ ] **Step 1: Write the failing test**

```csharp
using FluentAssertions;
using FreeX.App.Services.Updates;
using Xunit;

namespace FreeX.App.Services.Tests.Updates;

public class UpdateFeedTests
{
    [Fact]
    public void GitHubFeedUrl_IsRepoReleasesRoot()
    {
        UpdateFeed.GitHubRepoUrl.Should().Be("https://github.com/tony-xmelon/FreeX");
    }

    [Theory]
    [InlineData("test", true)]
    [InlineData("stable", false)]
    [InlineData("", false)]
    [InlineData(null, false)]
    public void PrereleaseChannel_OnlyTesterPullsPrereleases(string? channel, bool expectedPrerelease)
    {
        UpdateFeed.AllowPrereleases(channel).Should().Be(expectedPrerelease);
    }
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `dotnet test FreeX.DefaultTests.slnx -c Release --filter UpdateFeedTests`
Expected: FAIL — `UpdateFeed` does not exist.

- [ ] **Step 3: Write the implementation**

```csharp
namespace FreeX.App.Services.Updates;

/// <summary>
/// Resolves the GitHub Releases feed and channel policy for self-update.
/// Pure/static so it is unit-testable without touching the network or Velopack.
/// </summary>
public static class UpdateFeed
{
    public const string GitHubRepoUrl = "https://github.com/tony-xmelon/FreeX";

    /// <summary>
    /// The tester channel pulls GitHub pre-releases; stable (or unknown) channels do not.
    /// Channel comes from release/progress.json's "channel" field, threaded in by the host.
    /// </summary>
    public static bool AllowPrereleases(string? channel) =>
        string.Equals(channel, "test", StringComparison.OrdinalIgnoreCase);
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `dotnet test FreeX.DefaultTests.slnx -c Release --filter UpdateFeedTests`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add src/FreeX.App.Services/Updates/UpdateFeed.cs tests/FreeX.App.Services.Tests/Updates/UpdateFeedTests.cs
git commit -m "feat: update feed channel resolution"
```

---

### Task A4: `IUpdateService` abstraction + status types

**Files:**
- Create: `src/FreeX.App.Services/Updates/UpdateStatus.cs`
- Create: `src/FreeX.App.Services/Updates/IUpdateService.cs`

- [ ] **Step 1: Write the status types**

`src/FreeX.App.Services/Updates/UpdateStatus.cs`:

```csharp
namespace FreeX.App.Services.Updates;

/// <summary>Outcome of an update check.</summary>
public enum UpdateState
{
    /// <summary>No newer release available.</summary>
    UpToDate,
    /// <summary>A newer release is available (not yet downloaded).</summary>
    UpdateAvailable,
    /// <summary>A newer release has been downloaded and is staged to apply on restart.</summary>
    ReadyToApply,
    /// <summary>The check could not complete (offline, no Velopack manager, feed error).</summary>
    Unavailable,
}

/// <summary>Immutable result of a check, safe to marshal to the UI thread.</summary>
public sealed record UpdateCheckResult(UpdateState State, string? AvailableVersion)
{
    public static UpdateCheckResult UpToDate { get; } = new(UpdateState.UpToDate, null);
    public static UpdateCheckResult Unavailable { get; } = new(UpdateState.Unavailable, null);
}
```

`src/FreeX.App.Services/Updates/IUpdateService.cs`:

```csharp
namespace FreeX.App.Services.Updates;

/// <summary>
/// Checks for, downloads, and applies application updates. Every method is best-effort:
/// network/feed failures resolve to <see cref="UpdateState.Unavailable"/> and never throw.
/// </summary>
public interface IUpdateService
{
    /// <summary>Check the feed and, if an update exists, download it. Returns the resulting state.</summary>
    Task<UpdateCheckResult> CheckAndDownloadAsync(CancellationToken cancellationToken = default);

    /// <summary>
    /// Apply a previously downloaded update and restart the app. No-op if nothing is staged.
    /// On success this does not return (the process is replaced/restarted).
    /// </summary>
    void ApplyAndRestart();

    /// <summary>The releases page URL, used as a fallback when self-update is unavailable.</summary>
    string ReleasesPageUrl { get; }
}
```

- [ ] **Step 2: Build to confirm it compiles**

Run: `dotnet build src/FreeX.App.Services/FreeX.App.Services.csproj -c Release`
Expected: success.

- [ ] **Step 3: Commit**

```bash
git add src/FreeX.App.Services/Updates/UpdateStatus.cs src/FreeX.App.Services/Updates/IUpdateService.cs
git commit -m "feat: IUpdateService abstraction and status types"
```

---

### Task A5: `VelopackUpdateService` with graceful fallback + decision tests

The Velopack `UpdateManager` is sealed and not directly mockable, so we isolate the *decision* logic behind a thin seam: the service takes a delegate that returns the "newer release" info (or null), which the test can fake. The real delegate calls Velopack.

**Files:**
- Create: `src/FreeX.App.Services/Updates/VelopackUpdateService.cs`
- Test: `tests/FreeX.App.Services.Tests/Updates/UpdateServiceDecisionTests.cs`

- [ ] **Step 1: Write the failing test**

```csharp
using FluentAssertions;
using FreeX.App.Services.Updates;
using Xunit;

namespace FreeX.App.Services.Tests.Updates;

public class UpdateServiceDecisionTests
{
    private static VelopackUpdateService Service(Func<CancellationToken, Task<DownloadedUpdate?>> probe) =>
        new(releasesPageUrl: "https://example/releases", downloadProbe: probe);

    [Fact]
    public async Task NoUpdate_ReportsUpToDate()
    {
        var svc = Service(_ => Task.FromResult<DownloadedUpdate?>(null));
        var result = await svc.CheckAndDownloadAsync();
        result.State.Should().Be(UpdateState.UpToDate);
    }

    [Fact]
    public async Task UpdateDownloaded_ReportsReadyToApplyWithVersion()
    {
        var svc = Service(_ => Task.FromResult<DownloadedUpdate?>(new DownloadedUpdate("0.6.0")));
        var result = await svc.CheckAndDownloadAsync();
        result.State.Should().Be(UpdateState.ReadyToApply);
        result.AvailableVersion.Should().Be("0.6.0");
    }

    [Fact]
    public async Task ProbeThrows_ReportsUnavailable_NeverThrows()
    {
        var svc = Service(_ => throw new InvalidOperationException("offline"));
        var result = await svc.CheckAndDownloadAsync();
        result.State.Should().Be(UpdateState.Unavailable);
    }
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `dotnet test FreeX.DefaultTests.slnx -c Release --filter UpdateServiceDecisionTests`
Expected: FAIL — `VelopackUpdateService` / `DownloadedUpdate` do not exist.

- [ ] **Step 3: Write the implementation**

`src/FreeX.App.Services/Updates/VelopackUpdateService.cs`:

```csharp
using Microsoft.Extensions.Logging;
using Velopack;
using Velopack.Sources;

namespace FreeX.App.Services.Updates;

/// <summary>A downloaded, staged update awaiting restart.</summary>
public sealed record DownloadedUpdate(string Version);

/// <summary>
/// Velopack-backed <see cref="IUpdateService"/>. The check/download work is injected as a
/// delegate (<paramref name="downloadProbe"/>) so the decision logic is unit-testable; the
/// production factory wires the delegate to a real <see cref="UpdateManager"/>.
/// When no manager is available (e.g. unpacked dev build) the service degrades to Unavailable
/// and callers fall back to opening <see cref="ReleasesPageUrl"/>.
/// </summary>
public sealed class VelopackUpdateService : IUpdateService
{
    private readonly Func<CancellationToken, Task<DownloadedUpdate?>> _downloadProbe;
    private readonly Action? _applyAndRestart;
    private readonly ILogger? _logger;

    public string ReleasesPageUrl { get; }

    public VelopackUpdateService(
        string releasesPageUrl,
        Func<CancellationToken, Task<DownloadedUpdate?>> downloadProbe,
        Action? applyAndRestart = null,
        ILogger? logger = null)
    {
        ReleasesPageUrl = releasesPageUrl;
        _downloadProbe = downloadProbe;
        _applyAndRestart = applyAndRestart;
        _logger = logger;
    }

    /// <summary>
    /// Production factory: builds a service backed by a real Velopack <see cref="UpdateManager"/>
    /// pointed at the GitHub repo. Returns a service whose probe yields null/Unavailable if the
    /// app is not Velopack-installed.
    /// </summary>
    public static VelopackUpdateService CreateForGitHub(string repoUrl, bool prerelease, string releasesPageUrl, ILogger? logger = null)
    {
        UpdateManager? manager;
        try
        {
            manager = new UpdateManager(new GithubSource(repoUrl, accessToken: null, prerelease: prerelease));
        }
        catch (Exception ex)
        {
            logger?.LogDebug(ex, "Velopack UpdateManager unavailable; self-update disabled.");
            manager = null;
        }

        async Task<DownloadedUpdate?> Probe(CancellationToken ct)
        {
            if (manager is null || !manager.IsInstalled)
                return null;
            var info = await manager.CheckForUpdatesAsync().ConfigureAwait(false);
            if (info is null)
                return null;
            await manager.DownloadUpdatesAsync(info).ConfigureAwait(false);
            return new DownloadedUpdate(info.TargetFullRelease.Version.ToString());
        }

        void Apply()
        {
            if (manager is null || !manager.IsInstalled)
                return;
            var info = manager.CheckForUpdates();
            if (info is not null)
                manager.ApplyUpdatesAndRestart(info.TargetFullRelease);
        }

        return new VelopackUpdateService(releasesPageUrl, Probe, Apply, logger);
    }

    public async Task<UpdateCheckResult> CheckAndDownloadAsync(CancellationToken cancellationToken = default)
    {
        try
        {
            var update = await _downloadProbe(cancellationToken).ConfigureAwait(false);
            return update is null
                ? UpdateCheckResult.UpToDate
                : new UpdateCheckResult(UpdateState.ReadyToApply, update.Version);
        }
        catch (Exception ex)
        {
            _logger?.LogDebug(ex, "Update check failed; reporting Unavailable.");
            return UpdateCheckResult.Unavailable;
        }
    }

    public void ApplyAndRestart()
    {
        try { _applyAndRestart?.Invoke(); }
        catch (Exception ex) { _logger?.LogWarning(ex, "ApplyAndRestart failed."); }
    }
}
```

> NOTE for implementer: verify the exact Velopack API surface (`UpdateManager`, `GithubSource`, `CheckForUpdatesAsync`, `DownloadUpdatesAsync`, `ApplyUpdatesAndRestart`, `IsInstalled`, `UpdateInfo.TargetFullRelease.Version`) against the installed package version via `dotnet build` and the Velopack docs; adjust member names if the package version differs. The unit-tested `CheckAndDownloadAsync`/`ApplyAndRestart` logic does not depend on those names.

- [ ] **Step 4: Run test to verify it passes**

Run: `dotnet test FreeX.DefaultTests.slnx -c Release --filter UpdateServiceDecisionTests`
Expected: PASS (3 tests).

- [ ] **Step 5: Commit**

```bash
git add src/FreeX.App.Services/Updates/VelopackUpdateService.cs tests/FreeX.App.Services.Tests/Updates/UpdateServiceDecisionTests.cs
git commit -m "feat: VelopackUpdateService with testable decision logic and graceful fallback"
```

---

### Task A6: Phase A gate — build + full test run

- [ ] **Step 1: Build the solution**

Run: `dotnet build FreeX.slnx -c Release`
Expected: success.

- [ ] **Step 2: Run default tests**

Run: `dotnet test FreeX.DefaultTests.slnx -c Release --no-build`
Expected: all pass (including the new Update* and FileAssociation* tests).

- [ ] **Step 3: Commit (if any fixups were needed)**

```bash
git commit -am "chore: phase A gate green" --allow-empty
```

---

## PHASE B — Windows (WPF)

> Depends on Phase A signatures (`IUpdateService`, `IFileAssociationService`, `FileAssociationDefinition`, `UpdateFeed`, `VelopackUpdateService.CreateForGitHub`).

### Task B1: `WindowsFileAssociationService` + tests (redirected hive)

Writes per-user associations under `HKCU\Software\Classes`. Owned types (`.fxl`) set the extension key's default to the ProgId; OpenWith types only add an `OpenWithProgids` value and never touch the default. To make this testable without polluting the real registry, the service writes under a configurable root key path (default `Software\Classes`, the test passes `Software\FreeXTest\Classes`).

**Files:**
- Create: `src/FreeX.App.Host/FileAssociations/WindowsFileAssociationService.cs`
- Test: `tests/FreeX.App.Host.Tests/FileAssociations/WindowsFileAssociationServiceTests.cs`

- [ ] **Step 1: Write the failing test**

```csharp
using FluentAssertions;
using FreeX.App.Host.FileAssociations;
using FreeX.App.Services.FileAssociations;
using Microsoft.Win32;
using Xunit;

namespace FreeX.App.Host.Tests.FileAssociations;

[Collection("registry")] // serialize: these tests mutate a shared test hive
public class WindowsFileAssociationServiceTests : IDisposable
{
    private const string TestRoot = @"Software\FreeXTest\Classes";

    private static WindowsFileAssociationService NewService() =>
        new(classesRootPath: TestRoot, logger: null);

    [Fact]
    public void RegisterAll_OwnsFxl_AsDefaultHandler()
    {
        NewService().RegisterAll(@"C:\Apps\FreeX\FreeX.App.Host.exe");

        using var ext = Registry.CurrentUser.OpenSubKey($@"{TestRoot}\.fxl");
        ext!.GetValue(null).Should().Be("FreeX.Workbook.fxl");

        using var cmd = Registry.CurrentUser.OpenSubKey($@"{TestRoot}\FreeX.Workbook.fxl\shell\open\command");
        ((string)cmd!.GetValue(null)!).Should().Contain("FreeX.App.Host.exe").And.Contain("\"%1\"");
    }

    [Fact]
    public void RegisterAll_NeutralType_AddsOpenWith_DoesNotStealDefault()
    {
        // Simulate an existing default handler for .csv.
        using (var pre = Registry.CurrentUser.CreateSubKey($@"{TestRoot}\.csv"))
            pre.SetValue(null, "Excel.CSV");

        NewService().RegisterAll(@"C:\Apps\FreeX\FreeX.App.Host.exe");

        using var ext = Registry.CurrentUser.OpenSubKey($@"{TestRoot}\.csv");
        ext!.GetValue(null).Should().Be("Excel.CSV", "the existing default must be preserved");

        using var openWith = Registry.CurrentUser.OpenSubKey($@"{TestRoot}\.csv\OpenWithProgids");
        openWith!.GetValueNames().Should().Contain("FreeX.Workbook.csv");
    }

    [Fact]
    public void UnregisterAll_RemovesEveryFreeXProgId()
    {
        var svc = NewService();
        svc.RegisterAll(@"C:\Apps\FreeX\FreeX.App.Host.exe");
        svc.UnregisterAll();

        foreach (var def in FileAssociationDefinition.All)
        {
            using var progId = Registry.CurrentUser.OpenSubKey($@"{TestRoot}\{def.ProgId}");
            progId.Should().BeNull($"{def.ProgId} should be removed on uninstall");
        }
    }

    public void Dispose() => Registry.CurrentUser.DeleteSubKeyTree(@"Software\FreeXTest", throwOnMissingSubKey: false);
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `dotnet test FreeX.DefaultTests.slnx -c Release --filter WindowsFileAssociationServiceTests`
Expected: FAIL — type does not exist.

> If `FreeX.App.Host.Tests` is not part of `FreeX.DefaultTests.slnx`, run via the host test project directly: `dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj -c Release --filter WindowsFileAssociationServiceTests`. Confirm which solution the host tests belong to before writing the run command into the loop.

- [ ] **Step 3: Write the implementation**

```csharp
using Microsoft.Extensions.Logging;
using Microsoft.Win32;
using FreeX.App.Services.FileAssociations;
using System.Runtime.InteropServices;

namespace FreeX.App.Host.FileAssociations;

/// <summary>
/// Per-user (HKCU) file-association registration for Windows. Owned types become the default
/// handler; neutral/Office types are only added to OpenWithProgids so existing defaults survive.
/// All operations are best-effort and never throw to the caller.
/// </summary>
public sealed class WindowsFileAssociationService : IFileAssociationService
{
    private readonly string _classesRootPath;
    private readonly ILogger? _logger;

    public WindowsFileAssociationService(string classesRootPath = @"Software\Classes", ILogger? logger = null)
    {
        _classesRootPath = classesRootPath;
        _logger = logger;
    }

    public void RegisterAll(string executablePath)
    {
        try
        {
            foreach (var def in FileAssociationDefinition.All)
                RegisterOne(def, executablePath);
            NotifyShell();
        }
        catch (Exception ex) { _logger?.LogWarning(ex, "RegisterAll failed."); }
    }

    public void UnregisterAll()
    {
        try
        {
            foreach (var def in FileAssociationDefinition.All)
            {
                // Remove the ProgId tree.
                Registry.CurrentUser.DeleteSubKeyTree($@"{_classesRootPath}\{def.ProgId}", throwOnMissingSubKey: false);

                // Remove our OpenWith entry; if we own the default and it still points at us, clear it.
                using var ext = Registry.CurrentUser.OpenSubKey($@"{_classesRootPath}\{def.Extension}", writable: true);
                if (ext is null) continue;
                using (var ow = ext.OpenSubKey("OpenWithProgids", writable: true))
                    ow?.DeleteValue(def.ProgId, throwOnMissingValue: false);
                if (def.Ownership == AssociationOwnership.Default &&
                    (ext.GetValue(null) as string) == def.ProgId)
                    ext.DeleteValue(null, throwOnMissingValue: false);
            }
            NotifyShell();
        }
        catch (Exception ex) { _logger?.LogWarning(ex, "UnregisterAll failed."); }
    }

    public bool IsDefaultHandler(string extension)
    {
        var def = FileAssociationDefinition.All.FirstOrDefault(d => d.Extension == extension);
        if (def is null) return false;
        using var ext = Registry.CurrentUser.OpenSubKey($@"{_classesRootPath}\{extension}");
        return (ext?.GetValue(null) as string) == def.ProgId;
    }

    private void RegisterOne(FileAssociationDefinition def, string executablePath)
    {
        // ProgId: friendly name, icon, open command.
        using (var progId = Registry.CurrentUser.CreateSubKey($@"{_classesRootPath}\{def.ProgId}"))
        {
            progId.SetValue(null, def.FriendlyName);
            using (var icon = progId.CreateSubKey("DefaultIcon"))
                icon.SetValue(null, $"\"{executablePath}\",0");
            using (var cmd = progId.CreateSubKey(@"shell\open\command"))
                cmd.SetValue(null, $"\"{executablePath}\" \"%1\"");
        }

        // Extension key.
        using var ext = Registry.CurrentUser.CreateSubKey($@"{_classesRootPath}\{def.Extension}");
        using (var ow = ext.CreateSubKey("OpenWithProgids"))
            ow.SetValue(def.ProgId, Array.Empty<byte>(), RegistryValueKind.None);

        // Only owned types take the default; neutral types must not steal an existing default.
        if (def.Ownership == AssociationOwnership.Default)
            ext.SetValue(null, def.ProgId);
    }

    private void NotifyShell()
    {
        if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
            SHChangeNotify(0x08000000 /*SHCNE_ASSOCCHANGED*/, 0x0000 /*SHCNF_IDLIST*/, IntPtr.Zero, IntPtr.Zero);
    }

    [DllImport("shell32.dll")]
    private static extern void SHChangeNotify(int eventId, uint flags, IntPtr item1, IntPtr item2);
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `dotnet test FreeX.DefaultTests.slnx -c Release --filter WindowsFileAssociationServiceTests`
Expected: PASS (3 tests).

- [ ] **Step 5: Commit**

```bash
git add src/FreeX.App.Host/FileAssociations tests/FreeX.App.Host.Tests/FileAssociations
git commit -m "feat: Windows HKCU file-association service (preserves existing defaults)"
```

---

### Task B2: Velopack bootstrap + install/uninstall hooks

**Files:**
- Create: `src/FreeX.App.Host/VelopackBootstrap.cs`
- Modify: `src/FreeX.App.Host/FreeX.App.Host.csproj` (add `<PackageReference Include="Velopack" />`)

- [ ] **Step 1: Add the package reference**

In `src/FreeX.App.Host/FreeX.App.Host.csproj`, add to an `<ItemGroup>`:

```xml
<PackageReference Include="Velopack" />
```

- [ ] **Step 2: Write the bootstrap**

`src/FreeX.App.Host/VelopackBootstrap.cs`:

```csharp
using System.Diagnostics;
using Velopack;
using FreeX.App.Host.FileAssociations;

namespace FreeX.App.Host;

/// <summary>
/// Velopack entry hook. <see cref="Run"/> MUST be called before any WPF/UI work so Velopack
/// can service install/update/uninstall invocations and exit fast. Install/uninstall callbacks
/// register/unregister Windows file associations.
/// </summary>
public static class VelopackBootstrap
{
    public static void Run()
    {
        var exePath = Process.GetCurrentProcess().MainModule?.FileName
                      ?? Environment.ProcessPath
                      ?? AppContext.BaseDirectory;
        var assoc = new WindowsFileAssociationService();

        VelopackApp.Build()
            .WithAfterInstallFastCallback(_ => assoc.RegisterAll(exePath))
            .WithAfterUpdateFastCallback(_ => assoc.RegisterAll(exePath)) // keep command path current after update
            .WithBeforeUninstallFastCallback(_ => assoc.UnregisterAll())
            .Run();
    }
}
```

> NOTE: confirm hook method names against the installed Velopack version (`WithAfterInstallFastCallback`, `WithBeforeUninstallFastCallback`, `WithAfterUpdateFastCallback`). If names differ, use the package's equivalents — the intent is: register on install/update, unregister on uninstall.

- [ ] **Step 3: Call it first in startup**

In `src/FreeX.App.Host/App.xaml.cs`, make `VelopackBootstrap.Run()` the very first statement of `App_OnStartup` (before `FreeXOptions.Load()`):

```csharp
private void App_OnStartup(object sender, StartupEventArgs e)
{
    VelopackBootstrap.Run(); // must precede all UI/init so Velopack can service hooks and exit
    var options = FreeXOptions.Load();
    // ... existing body unchanged ...
```

- [ ] **Step 4: Build**

Run: `dotnet build src/FreeX.App.Host/FreeX.App.Host.csproj -c Release`
Expected: success.

- [ ] **Step 5: Commit**

```bash
git add src/FreeX.App.Host/VelopackBootstrap.cs src/FreeX.App.Host/FreeX.App.Host.csproj src/FreeX.App.Host/App.xaml.cs
git commit -m "feat: Velopack bootstrap with file-association install hooks"
```

---

### Task B3: DI registration + background update check on startup

**Files:**
- Modify: `src/FreeX.App.Host/App.xaml.cs` (`ConfigureServices` + startup)

- [ ] **Step 1: Register the services in `ConfigureServices`**

Add near the other `AddSingleton` calls:

```csharp
// Self-update + file associations.
services.AddSingleton<FreeX.App.Services.FileAssociations.IFileAssociationService>(
    new WindowsFileAssociationService(logger: null));
services.AddSingleton<FreeX.App.Services.Updates.IUpdateService>(sp =>
{
    var channel = options.ReleaseChannel; // see Step 2 for source
    return FreeX.App.Services.Updates.VelopackUpdateService.CreateForGitHub(
        repoUrl: FreeX.App.Services.Updates.UpdateFeed.GitHubRepoUrl,
        prerelease: FreeX.App.Services.Updates.UpdateFeed.AllowPrereleases(channel),
        releasesPageUrl: AppInfo.LatestReleaseUrl,
        logger: sp.GetService<ILoggerFactory>()?.CreateLogger<FreeX.App.Services.Updates.VelopackUpdateService>());
});
```

- [ ] **Step 2: Resolve the channel value**

The channel lives in `release/progress.json` (`"channel": "test"`). For the runtime, embed it at build time or read the existing options. Simplest: add a `const string ReleaseChannel = "test";` to `AppInfo.cs` and pass `AppInfo.ReleaseChannel` instead of `options.ReleaseChannel`. Use that const in Step 1.

```csharp
// in AppInfo.cs
public const string ReleaseChannel = "test";
```

- [ ] **Step 3: Kick off a background check after the window is shown**

In `App_OnStartup`, after `diagnostics.RecordEvent("app_ready");`, add:

```csharp
_ = Task.Run(async () =>
{
    try
    {
        var updates = Services.GetRequiredService<FreeX.App.Services.Updates.IUpdateService>();
        var result = await updates.CheckAndDownloadAsync();
        if (result.State == FreeX.App.Services.Updates.UpdateState.ReadyToApply)
        {
            await mainWindow.Dispatcher.InvokeAsync(() => mainWindow.ShowUpdateReady(result.AvailableVersion));
        }
    }
    catch (Exception ex) { Log.Debug(ex, "Background update check failed."); }
});
```

(`ShowUpdateReady` is defined in Task B4.)

- [ ] **Step 4: Build**

Run: `dotnet build src/FreeX.App.Host/FreeX.App.Host.csproj -c Release`
Expected: success (will fail until B4 adds `ShowUpdateReady` — sequence B4 before final build, or stub the method now).

- [ ] **Step 5: Commit**

```bash
git add src/FreeX.App.Host/App.xaml.cs src/FreeX.App.Host/AppInfo.cs
git commit -m "feat: register update/association services and background update check"
```

---

### Task B4: Discreet status-bar update indicator

**Files:**
- Modify: `src/FreeX.App.Host/MainWindow.xaml` (inside `StatusBarRoot`, ~line 1189, right-aligned)
- Modify: a `MainWindow` partial (e.g. `MainWindow.ReviewCommands.cs` or a new `MainWindow.Update.cs`)

- [ ] **Step 1: Add the indicator XAML, normally collapsed, right-aligned in the status bar**

Inside the `StatusBarRoot` content, add (matching the muted status-bar text style; place at the right edge of the existing layout):

```xml
<Button x:Name="UpdateReadyIndicator"
        Visibility="Collapsed"
        Click="UpdateReadyIndicator_Click"
        Background="Transparent" BorderThickness="0" Padding="6,0"
        ToolTip="A new version of FreeX has been downloaded. Click to restart and update."
        AutomationProperties.AutomationId="UpdateReadyIndicator">
    <TextBlock Text="↻ Update ready" Opacity="0.75" FontSize="11"/>
</Button>
```

> Place it in the existing right-hand region of the status bar grid (find the rightmost column used by zoom/view controls and add it adjacent). Match surrounding foreground/opacity so it reads as a quiet hint, not a banner.

- [ ] **Step 2: Add the code-behind in a `MainWindow.Update.cs` partial**

```csharp
using System.Diagnostics;
using System.Windows;
using FreeX.App.Services.Updates;
using Microsoft.Extensions.DependencyInjection;

namespace FreeX.App.Host;

public partial class MainWindow
{
    private string? _stagedUpdateVersion;

    /// <summary>Reveal the discreet status-bar indicator. Safe to call only on the UI thread.</summary>
    public void ShowUpdateReady(string? version)
    {
        _stagedUpdateVersion = version;
        if (UpdateReadyIndicator is not null)
            UpdateReadyIndicator.Visibility = Visibility.Visible;
    }

    private void UpdateReadyIndicator_Click(object sender, RoutedEventArgs e)
    {
        var updates = App.Services.GetService<IUpdateService>();
        if (updates is null) return;

        var versionText = string.IsNullOrWhiteSpace(_stagedUpdateVersion) ? "" : $" {_stagedUpdateVersion}";
        var choice = MessageBox.Show(
            $"FreeX{versionText} is ready to install. Restart now to update?",
            "Update FreeX",
            MessageBoxButton.OKCancel,
            MessageBoxImage.Information);
        if (choice == MessageBoxResult.OK)
            updates.ApplyAndRestart();
    }
}
```

> The MessageBox is the minimal non-intrusive confirmation. If a lightweight flyout/popup is preferred over a modal, swap the body for a `Popup` anchored to the indicator — keep the same `ApplyAndRestart()` call.

- [ ] **Step 3: Build**

Run: `dotnet build src/FreeX.App.Host/FreeX.App.Host.csproj -c Release`
Expected: success.

- [ ] **Step 4: Commit**

```bash
git add src/FreeX.App.Host/MainWindow.xaml src/FreeX.App.Host/MainWindow.Update.cs
git commit -m "feat: discreet status-bar update-ready indicator"
```

---

### Task B5: Rewire manual "Check for Updates"

**Files:**
- Modify: `src/FreeX.App.Host/MainWindow.ReviewCommands.cs` (`CheckForUpdatesBtn_Click`)

- [ ] **Step 1: Replace the browser-open handler body**

Find `CheckForUpdatesBtn_Click` and replace its body with a real check that falls back to the browser when self-update is unavailable:

```csharp
private async void CheckForUpdatesBtn_Click(object sender, RoutedEventArgs e)
{
    var updates = App.Services.GetService<FreeX.App.Services.Updates.IUpdateService>();
    if (updates is null) return;

    var result = await updates.CheckAndDownloadAsync();
    switch (result.State)
    {
        case FreeX.App.Services.Updates.UpdateState.ReadyToApply:
            ShowUpdateReady(result.AvailableVersion);
            break;
        case FreeX.App.Services.Updates.UpdateState.UpToDate:
            MessageBox.Show("You're up to date.", "FreeX", MessageBoxButton.OK, MessageBoxImage.Information);
            break;
        default: // Unavailable — fall back to the releases page
            try { Process.Start(new ProcessStartInfo(updates.ReleasesPageUrl) { UseShellExecute = true }); }
            catch { /* best-effort */ }
            break;
    }
}
```

Ensure `using System.Diagnostics;` is present. Make the method `async` (was likely `void` sync before).

- [ ] **Step 2: Build**

Run: `dotnet build src/FreeX.App.Host/FreeX.App.Host.csproj -c Release`
Expected: success.

- [ ] **Step 3: Remove now-dead `AppUpdateSource` if unreferenced**

Run: `git grep -n AppUpdateSource` — if only the definition remains, delete `src/FreeX.App.Host/AppUpdateSource.cs`. Keep `AppInfo.LatestReleaseUrl` (still used as fallback).

- [ ] **Step 4: Commit**

```bash
git add src/FreeX.App.Host/MainWindow.ReviewCommands.cs
git rm src/FreeX.App.Host/AppUpdateSource.cs   # only if unreferenced
git commit -m "feat: manual Check for Updates now performs real update check"
```

---

### Task B6: `vpk pack` publish mode in the publish script

**Files:**
- Modify: `tools/Publish-UserTestBuild.ps1`

- [ ] **Step 1: Add `Velopack` to the `PublishMode` ValidateSet**

Change line 6:

```powershell
[ValidateSet("SingleFile", "Folder", "Msix", "Velopack")]
```

- [ ] **Step 2: Add a Velopack branch after the publish step**

After `dotnet @publishArgs` succeeds and before the `SingleFile` early-exit block, add a branch. It does a normal framework-dependent folder publish (Velopack packs a folder), then runs `vpk`:

```powershell
if ($PublishMode -eq "Velopack") {
    # Ensure the Velopack CLI is available.
    $vpk = Get-Command vpk -ErrorAction SilentlyContinue
    if ($null -eq $vpk) {
        dotnet tool install -g vpk
        if ($LASTEXITCODE -ne 0) { throw "Failed to install the Velopack CLI (vpk)." }
        $vpk = Get-Command vpk -ErrorAction SilentlyContinue
        if ($null -eq $vpk) { throw "vpk not found on PATH after install; ensure the dotnet global tools dir is on PATH." }
    }

    $vpkOut = Join-Path $artifactRoot "velopack-$RuntimeIdentifier"
    New-Item -ItemType Directory -Force -Path $vpkOut | Out-Null

    & vpk pack `
        --packId "FreeX" `
        --packVersion $assemblyVersion `
        --packDir $publishDir `
        --mainExe "FreeX.App.Host.exe" `
        --outputDir $vpkOut `
        --packTitle "FreeX" `
        --channel "win"
    if ($LASTEXITCODE -ne 0) { throw "vpk pack failed with exit code $LASTEXITCODE" }

    Write-Host "Created Velopack artifacts in $vpkOut"
    Get-ChildItem -LiteralPath $vpkOut | ForEach-Object { Write-Host "  $($_.Name)" }
    exit 0
}
```

> NOTE: the publish for Velopack should NOT use `PublishSingleFile=true` (Velopack packs the published folder). When `-PublishMode Velopack`, take the same path as `Folder` for `$publishArgs` (i.e. `-p:PublishSingleFile=false`) — adjust the `if ($PublishMode -eq "SingleFile")` guard at lines 308–319 to treat `Velopack` like `Folder`. Verify exact `vpk pack` flag names against the installed CLI (`vpk pack --help`); flag spellings have varied across versions (`--packId`/`-u`, `--packVersion`/`-v`, `--packDir`/`-p`, `--mainExe`/`-e`, `--outputDir`/`-o`).

- [ ] **Step 3: Validate locally**

Run: `pwsh tools/Publish-UserTestBuild.ps1 -PublishMode Velopack`
Expected: a `velopack-win-x64` folder containing `FreeX-win-Setup.exe`, `*-Portable.zip` (or `*-win-Portable.zip`), a full `.nupkg`, and `RELEASES`/`assets.win.json`. Inspect names and adjust the workflow upload globs in B7 to match what `vpk` actually emits.

- [ ] **Step 4: Commit**

```bash
git add tools/Publish-UserTestBuild.ps1
git commit -m "build: add Velopack publish mode to publish script"
```

---

### Task B7: Wire Velopack into the release workflow

**Files:**
- Modify: `.github/workflows/tester-release.yml`

- [ ] **Step 1: Add a build step that runs the Velopack mode**

After the existing publish step, add a step (YAML — match the file's existing indentation/runner):

```yaml
      - name: Pack Velopack (installer + portable)
        shell: pwsh
        run: ./tools/Publish-UserTestBuild.ps1 -PublishMode Velopack -RuntimeIdentifier win-x64
```

- [ ] **Step 2: Upload the Velopack artifacts to the GitHub release**

Add the produced files (Setup.exe, Portable zip, nupkg, RELEASES manifest) to whatever release-asset upload step the workflow already uses (extend its `files:`/glob list):

```
artifacts/releases/velopack-win-x64/*
```

> Match the real output names confirmed in B6 Step 3. The `RELEASES`/`assets.*.json` manifest MUST be uploaded — it is the feed Velopack reads to detect updates.

- [ ] **Step 3: Validate the workflow file**

Run: `pwsh -c "Get-Content .github/workflows/tester-release.yml | Out-Null"` and (if available) `actionlint .github/workflows/tester-release.yml`.
Expected: valid YAML; no actionlint errors.

- [ ] **Step 4: Commit**

```bash
git add .github/workflows/tester-release.yml
git commit -m "ci: publish Velopack installer + portable to tester release"
```

---

### Task B8: Phase B gate — build, test, manual smoke

- [ ] **Step 1: Build + test**

Run: `dotnet build FreeX.slnx -c Release` then `dotnet test FreeX.DefaultTests.slnx -c Release --no-build`
Expected: all pass.

- [ ] **Step 2: Manual install smoke test (documented, real machine)**

Run `pwsh tools/Publish-UserTestBuild.ps1 -PublishMode Velopack`, then run `FreeX-win-Setup.exe`. Verify:
  - App installs per-user (no UAC) and launches.
  - In Explorer, an `.fxl` file shows the FreeX icon and opens FreeX on double-click.
  - A `.csv`/`.xlsx` file's default app is UNCHANGED, but FreeX appears under "Open with".
  - Uninstall (Apps & features) removes the app and the `.fxl` association.

Record results in the PR description (this step is not automatable).

- [ ] **Step 3: Commit any fixups**

```bash
git commit -am "fix: phase B smoke-test fixups" --allow-empty
```

---

## PHASE C — macOS (Avalonia)

> Depends on Phase A signatures. Independent of Phase B (different files/platform).

### Task C1: macOS `Info.plist` document types + exported UTI

**Files:**
- Create/Modify: `src/FreeX.App.Avalonia/Packaging/macos/Info.plist`

- [ ] **Step 1: Locate or create the Info.plist used by the mac bundle**

Run: `git ls-files src/FreeX.App.Avalonia/Packaging/macos`. If an `Info.plist` exists, edit it; otherwise create one and ensure `macos-app.yml` copies it into the `.app/Contents/`.

- [ ] **Step 2: Add `CFBundleDocumentTypes` and `UTExportedTypeDeclarations`**

Add these keys (merge into the existing top-level `<dict>`):

```xml
<key>CFBundleDocumentTypes</key>
<array>
  <dict>
    <key>CFBundleTypeName</key><string>FreeX Workbook</string>
    <key>LSHandlerRank</key><string>Owner</string>
    <key>LSItemContentTypes</key><array><string>com.freex.workbook.fxl</string></array>
    <key>CFBundleTypeRole</key><string>Editor</string>
  </dict>
  <dict>
    <key>CFBundleTypeName</key><string>Comma-Separated Values</string>
    <key>LSHandlerRank</key><string>Alternate</string>
    <key>LSItemContentTypes</key><array><string>public.comma-separated-values-text</string></array>
    <key>CFBundleTypeRole</key><string>Editor</string>
  </dict>
  <dict>
    <key>CFBundleTypeName</key><string>Tab-Separated Values</string>
    <key>LSHandlerRank</key><string>Alternate</string>
    <key>LSItemContentTypes</key><array><string>public.tab-separated-values-text</string></array>
    <key>CFBundleTypeRole</key><string>Editor</string>
  </dict>
  <dict>
    <key>CFBundleTypeName</key><string>Plain Text</string>
    <key>LSHandlerRank</key><string>Alternate</string>
    <key>LSItemContentTypes</key><array><string>public.plain-text</string></array>
    <key>CFBundleTypeRole</key><string>Editor</string>
  </dict>
  <dict>
    <key>CFBundleTypeName</key><string>Excel Workbook</string>
    <key>LSHandlerRank</key><string>Alternate</string>
    <key>LSItemContentTypes</key><array><string>org.openxmlformats.spreadsheetml.sheet</string><string>com.microsoft.excel.xls</string></array>
    <key>CFBundleTypeRole</key><string>Editor</string>
  </dict>
</array>
<key>UTExportedTypeDeclarations</key>
<array>
  <dict>
    <key>UTTypeIdentifier</key><string>com.freex.workbook.fxl</string>
    <key>UTTypeDescription</key><string>FreeX Workbook</string>
    <key>UTTypeConformsTo</key><array><string>public.data</string></array>
    <key>UTTypeTagSpecification</key>
    <dict><key>public.filename-extension</key><array><string>fxl</string></array></dict>
  </dict>
</array>
```

`LSHandlerRank=Owner` only for `.fxl`; everything else is `Alternate` (parallel to the Windows "don't steal defaults" policy).

- [ ] **Step 3: Commit**

```bash
git add src/FreeX.App.Avalonia/Packaging/macos/Info.plist
git commit -m "feat(macos): declare FreeX document types and .fxl UTI"
```

---

### Task C2: macOS file-association service + non-mac no-op

**Files:**
- Create: `src/FreeX.App.Avalonia/MacOs/MacFileAssociationService.cs` (compiled only on `net10.0-macos`)
- Create: `src/FreeX.App.Avalonia/NoOpFileAssociationService.cs` (all TFMs)

- [ ] **Step 1: Write the no-op fallback (so DI resolves on every TFM)**

`src/FreeX.App.Avalonia/NoOpFileAssociationService.cs`:

```csharp
using FreeX.App.Services.FileAssociations;

namespace FreeX.App.Avalonia;

/// <summary>
/// File associations on macOS are declared statically in Info.plist (Launch Services picks
/// them up when the .app is installed), so there is nothing to register at runtime. This no-op
/// satisfies DI on non-Windows targets.
/// </summary>
public sealed class NoOpFileAssociationService : IFileAssociationService
{
    public void RegisterAll(string executablePath) { }
    public void UnregisterAll() { }
    public bool IsDefaultHandler(string extension) => false;
}
```

- [ ] **Step 2: (Optional) mac status query**

`src/FreeX.App.Avalonia/MacOs/MacFileAssociationService.cs` (only compiled on `net10.0-macos`, per the existing `MacOs/**` compile guard) may query Launch Services for default-handler status. For the first release a status query is not required; keep `NoOpFileAssociationService` as the registered implementation. Document the gap rather than half-implement.

- [ ] **Step 3: Build both TFMs**

Run: `dotnet build src/FreeX.App.Avalonia/FreeX.App.Avalonia.csproj -c Release` (net10.0) and, on a mac/CI, with `-p:EnableMacOsTargetFramework=true`.
Expected: success.

- [ ] **Step 4: Commit**

```bash
git add src/FreeX.App.Avalonia/NoOpFileAssociationService.cs src/FreeX.App.Avalonia/MacOs
git commit -m "feat(macos): no-op file-association service (associations are Info.plist-declared)"
```

---

### Task C3: Velopack bootstrap + update service + indicator in Avalonia

**Files:**
- Modify: `src/FreeX.App.Avalonia/FreeX.App.Avalonia.csproj` (add `<PackageReference Include="Velopack" />`)
- Modify: Avalonia entry point (`Program.cs`/`Main`) and main window/chrome

- [ ] **Step 1: Add the package reference**

```xml
<PackageReference Include="Velopack" />
```

- [ ] **Step 2: Bootstrap Velopack first in `Main`**

In the Avalonia `Program.Main` (find it: `git grep -n "static.*Main" src/FreeX.App.Avalonia`), make the first line:

```csharp
Velopack.VelopackApp.Build().Run();
```

(macOS associations are declarative, so no install hooks are wired here.)

- [ ] **Step 3: Register `IUpdateService` and run a background check**

Where the Avalonia app composes services / on main-window load:

```csharp
var updates = FreeX.App.Services.Updates.VelopackUpdateService.CreateForGitHub(
    repoUrl: FreeX.App.Services.Updates.UpdateFeed.GitHubRepoUrl,
    prerelease: FreeX.App.Services.Updates.UpdateFeed.AllowPrereleases("test"),
    releasesPageUrl: "https://github.com/tony-xmelon/FreeX/releases/latest");

_ = Task.Run(async () =>
{
    var result = await updates.CheckAndDownloadAsync();
    if (result.State == FreeX.App.Services.Updates.UpdateState.ReadyToApply)
        await Dispatcher.UIThread.InvokeAsync(() => ShowUpdateReady(result.AvailableVersion));
});
```

- [ ] **Step 4: Add a discreet indicator to the Avalonia window chrome**

Add a normally-collapsed `Button`/`TextBlock` ("↻ Update ready") in the bottom-right of the main window, with a click handler that confirms and calls `updates.ApplyAndRestart()`. Mirror the WPF indicator's quiet styling.

- [ ] **Step 5: Build**

Run: `dotnet build src/FreeX.App.Avalonia/FreeX.App.Avalonia.csproj -c Release`
Expected: success.

- [ ] **Step 6: Commit**

```bash
git add src/FreeX.App.Avalonia
git commit -m "feat(macos): Velopack self-update + discreet update indicator in Avalonia"
```

---

### Task C4: `vpk pack` for the macOS bundle in CI

**Files:**
- Modify: `.github/workflows/macos-app.yml`

- [ ] **Step 1: Add a `vpk pack` step for the `.app`**

After the mac `dotnet publish`/`.app` assembly step, add (match the file's runner/indent):

```yaml
      - name: Pack Velopack (macOS)
        shell: bash
        run: |
          dotnet tool install -g vpk || true
          export PATH="$PATH:$HOME/.dotnet/tools"
          vpk pack \
            --packId FreeX \
            --packVersion "$APP_VERSION" \
            --packDir "path/to/FreeX.app" \
            --mainExe FreeX \
            --outputDir artifacts/velopack-osx \
            --channel osx
```

> Set `APP_VERSION`/`packDir` to match the workflow's existing variables and the produced `.app` path. Confirm `vpk pack` mac flags against `vpk pack --help` for the installed CLI version.

- [ ] **Step 2: Upload mac Velopack artifacts**

Add `artifacts/velopack-osx/*` (Setup, portable zip, nupkg, `assets.osx.json`/RELEASES) to the workflow's release-asset upload.

- [ ] **Step 3: Validate**

(If available) `actionlint .github/workflows/macos-app.yml`. Full validation happens on the mac CI runner.

- [ ] **Step 4: Commit**

```bash
git add .github/workflows/macos-app.yml
git commit -m "ci(macos): pack and publish Velopack bundle for macOS"
```

---

## Final Gate

- [ ] **Step 1: Full build**

Run: `dotnet build FreeX.slnx -c Release`
Expected: success.

- [ ] **Step 2: Full default test suite**

Run: `dotnet test FreeX.DefaultTests.slnx -c Release --no-build`
Expected: all pass.

- [ ] **Step 3: Confirm no orphaned references**

Run: `git grep -n "AppUpdateSource"` — expect no results (or only intentional fallback usage).

- [ ] **Step 4: Use requesting-code-review skill before merge.**

---

## Self-Review (completed by plan author)

- **Spec coverage:** Distribution shift (B6/B7/C4), Velopack rationale (A1), file-association policy incl. don't-steal-defaults invariant (A2 catalog + B1 tests + C1 LSHandlerRank), self-update notify+discreet indicator (A4/A5/B3/B4/C3), bootstrap requirement (B2/C3), components & isolation (A2–A5 interfaces), testing strategy (A2/A3/A5/B1 unit tests + B8 manual smoke), error-handling best-effort principle (try/catch in every service method), phasing & parallelism (A → B∥C) — all mapped.
- **Placeholder scan:** No "TBD"/"implement later". The two deliberately-deferred items (mac status query in C2 Step 2; flyout-vs-MessageBox in B4) are explicitly scoped decisions with a chosen default, not gaps.
- **Type consistency:** `IUpdateService.CheckAndDownloadAsync`/`ApplyAndRestart`/`ReleasesPageUrl`, `UpdateState`, `UpdateCheckResult`, `DownloadedUpdate`, `IFileAssociationService.RegisterAll/UnregisterAll/IsDefaultHandler`, `FileAssociationDefinition.All`/`Ownership`/`ProgId`, `UpdateFeed.GitHubRepoUrl`/`AllowPrereleases`, `VelopackUpdateService.CreateForGitHub`, `MainWindow.ShowUpdateReady` — names are consistent across all tasks that reference them.
- **External-API caveat:** Velopack and `vpk` member/flag names are version-sensitive; tasks A5/B2/B6/C4 flag this and instruct verifying against the installed version. The unit-tested logic does not depend on those names.
