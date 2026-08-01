# WPF UI Gate Wave 94 STA Slice

Base: `334d8f69c38bc0eec4ee75a5cb465576e90a088f` (`origin/main`)

## Scope

This slice makes the two observed WPF-control test groups execute through the
existing `StaTestRunner`. It changes test execution authority only; no product
behavior, assertions, skips, filters, or failure suppression were added.

Owned subset:

- `NameBoxSheetScopedNavigationTests`: 8 tests, 7 previously plain `[Fact]`
  methods and 1 already using `StaTestRunner`.
- `MultiWindowAutosaveOwnershipTests`: 2 tests that construct and show
  `MainWindow` under plain `[Fact]` methods.

## Counts

Before the change, from the clean base:

| Test group | Total | Passed | Failed | Failure cause |
| --- | ---: | ---: | ---: | --- |
| Name Box | 8 | 1 | 7 | WPF `InvalidOperationException`: calling thread must be STA |
| Multi-window autosave | 2 | 0 | 2 | WPF `InvalidOperationException`: calling thread must be STA |
| **Owned subset** | **10** | **1** | **9** | **9 STA execution failures** |

After the change:

| Test group | Total | Passed | Failed |
| --- | ---: | ---: | ---: |
| Name Box | 8 | 8 | 0 |
| Multi-window autosave | 2 | 2 | 0 |
| **Owned subset** | **10** | **10** | **0** |

## Verification

Focused commands used for the authoritative counts:

```text
dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~NameBoxSheetScopedNavigationTests" --logger "console;verbosity=normal" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj --configuration Release --no-restore --no-build --filter "FullyQualifiedName~MultiWindowAutosaveOwnershipTests" --logger "console;verbosity=normal" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
```

The first post-change command rebuilt the focused host project successfully.
Both commands completed successfully with the after counts above. An initial
solution-level baseline attempt timed out during the first WPF compilation;
the project-scoped baseline completed and produced the before counts recorded
here.

## Residuals

The Wave 93 clean integration report of 212 failures remains broader than this
10-test slice: 208 Host failures and 4 UI failures also include stale source
guards/snapshots and real expectation drift. This change deliberately does not
reclassify or suppress those remaining failures. A full `FreeX.UiTests.slnx`
run was not used as post-change proof for this bounded slice.
