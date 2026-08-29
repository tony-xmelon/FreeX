# Wave 197 Legal Notices Evidence

This tracked bundle records the rejected FreeW Avalonia Legal Notices template
candidates from 2026-08-29. It keeps metrics, source mutations, capture
provenance, and checksums without adding the ignored PNG corpus to Git.

`wave197-freew-legal-notices-template-candidates.json` is the machine-readable
record. `wave197-freew-legal-notices-raw-evidence.json` is a tracked,
route-local lossless extract of the inventory, capture manifests, and
comparison reports. `SHA256SUMS.txt` checks every tracked file in this
directory from this directory's root; it does not refer to ignored
`artifacts/` paths.

The raw extract records each ignored source path and its original SHA-256. Its
extraction schema preserves every route-local inventory, capture, and
comparison field while omitting only absolute capture roots, PNG paths, and
inventory scenarios outside `legal-notices`. The bundle's provenance links to
the tracked extract and retains the original disposable-content hashes; they
are not hashes of tracked PNGs or claims that those disposable files are
committed.
Candidate source hashes are hashes of the exact one-line source mutations
recorded in the bundle.

The WPF authority and all three Avalonia capture sets contain six captured
scenarios at 620 x 600 logical pixels, and every target capture passed its
pixel-content gate. The comparison command returns exit code 2 by design when
it reports genuine visual mismatches; capture commands return 0.

Focused validation:

```powershell
dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj -c Release --filter FullyQualifiedName~Wave197LegalNoticesEvidenceTests
```
