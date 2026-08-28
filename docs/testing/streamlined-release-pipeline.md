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

Use proportional validation while developing:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Test-RepositoryPreflight.ps1
dotnet build FreeX.slnx --configuration Release
pwsh -NoProfile -File tools/Invoke-TestGate.ps1 -Gate commit -App FreeW -Platform windows
```

Run only the affected app gate during iteration. Use the repository default and UI solution lanes
once for a tester candidate or when the changed area requires them. Do not run default, UI, CI, and
release gates serially as four equivalent confirmations; CI is the hosted source-test attestation
and the release workflow consumes it.
