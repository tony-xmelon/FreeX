# WPF UI Gate Wave 94 STA Slice 2

Date: 2026-08-01

## Audit scope

This isolated branch was based on the Wave 94 integration tip `2c0af6f226` and
audited `tests/FreeX.App.Host.Tests` plus `tests/FreeX.App.UI.Tests` without
touching the integration or primary worktrees.

The method-level scan covered 626 Host C# files and 152 UI C# files. It tracked
`[Fact]`, `[Theory]`, and `[BenchmarkFact]` bodies, then looked for live WPF
construction or presentation calls (`MainWindow`, `Window`, controls, and
`Show`) while excluding source-text assertions and helper methods.

## Result

No qualifying slice-2 tests remain. Every live WPF test body found by the scan
already executes through one of the repository's STA authorities:

- `StaTestRunner.Run`
- `RunAsyncOnSta` (which delegates to `StaTestRunner`)
- `RunClipboardIsolated` (the fresh STA runner for clipboard-sensitive tests)

The five apparent candidates from the coarse scan were false positives caused
by helper methods declared after a test body or source assertions containing
strings such as `window.Show();`. The first Wave 94 gate covered the only
confirmed plain-xUnit group in this area: 8 Name Box tests plus 2 multi-window
autosave tests. One Name Box test already used `StaTestRunner`, so the gate
converted 7 Name Box tests plus 2 autosave tests, reducing the 9 STA failures
to 0.

## Verification

The focused command below was attempted from this clean linked worktree:

```text
dotnet test tests/FreeX.App.Host.Tests/FreeX.App.Host.Tests.csproj --configuration Release --no-restore --filter "FullyQualifiedName~MainWindowXamlKeyTipTests.Backstage" --logger "console;verbosity=normal" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1
```

This fresh worktree had no restored `obj` or built `bin` output, and the command
completed only the MSBuild target without producing VSTest/testhost output.
No broad solution build, Docker run, process termination, or build-server
shutdown was performed.

## Residuals

The broad Wave 93 UI-lane failures remain a mixed debt set, not an unbounded
STA backlog. The remaining work requires a fresh failure inventory to separate
source-guard drift, localization snapshots, page-layout expectations, and
other product/test mismatches from the STA gate. This slice intentionally made
no assertion, skip, filter, or product-code changes because no qualifying plain
xUnit STA group was found.
