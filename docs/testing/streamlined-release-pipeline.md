# Streamlined test and release pipeline

The previous pipeline treated CI, security analysis, and publication as three independent sources
of truth. A full-suite publication repeated 110 project/platform test executions after exact-SHA CI,
ran repository preflight once per native platform again, and compiled the production suite again
inside CodeQL. The successful v0.8.184 run spent as much as 45 minutes in a single repeated verify
job before packaging began.

The pipeline now has one owner for each kind of evidence:

1. **Canonical CI** owns repository preflight and every manifest-defined source test for FreeX,
   FreeW, and FreeP on Windows, Linux, and macOS. Its matrix is generated from
   `eng/test-gates.json`; independent gates run concurrently and superseded ref runs cancel. A
   failed project receives one isolated retry while the first-attempt evidence is retained.
2. **CodeQL** owns security analysis. It uses GitHub's supported no-build C# extraction, avoiding a
   second instrumented build while retaining automatic main, pull-request, weekly, and manual scans.
3. **App Tester Release** owns native publish, package-content validation, SBOMs, manifests,
   checksums, installation transitions, and publication. It requires successful CI and CodeQL runs
   for the exact immutable SHA and does not rerun their work.

This makes retries local to the failed responsibility. A packaging defect reruns packaging, not the
entire source suite. A test defect reruns CI, not a half-completed release. A moving `main` does not
invalidate a candidate that was already dispatched at a verified commit.

## Local workflow

Use the canonical branch integration gate after committing the task branch:

```powershell
pwsh -NoProfile -File tools/Test-BranchForIntegration.ps1
```

The script compares the branch with `origin/main`, verifies that the exact base SHA has a successful
CI run, then runs repository preflight, the full Release build, and only the affected Windows commit
gates. `tools/Get-ImpactedTestGates.ps1` combines the .NET `ProjectReference` graph with each gate's
manifest-declared `impactPaths`, so ordinary dependencies and cross-layer source-contract tests are
both covered. Documentation-only and unrelated tooling changes do not acquire a test lane merely
because the repository is large.

If exact-base CI is running, missing, cancelled, or failed, ordinary integration stops. Only a task
whose purpose is to repair that failure may use `-AllowRedMainFix`; this is explicit so unrelated
work cannot keep advancing a broken `main`. `-SkipMainHealthCheck` is for offline diagnosis and is
not an integration path.

GitHub CI remains the authoritative cross-platform integration suite after the merged commit is
pushed. The App Tester Release workflow remains the only routine owner of complete UI, rendering,
installation, package-integrity, and release-only tests. Do not run default, UI, CI, and release
gates serially as equivalent confirmations.
