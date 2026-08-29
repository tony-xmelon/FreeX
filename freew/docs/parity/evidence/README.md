# Wave 197 Legal Notices Evidence

This tracked bundle records the rejected FreeW Avalonia Legal Notices template
candidates from 2026-08-29. It keeps metrics, source mutations, capture
provenance, and checksums without adding the ignored PNG corpus to Git.

`wave197-freew-legal-notices-template-candidates.json` is the machine-readable
record. `SHA256SUMS.txt` checks this README and bundle, plus the retained local
inventory, capture manifests, and comparison reports when the ignored
`artifacts/wave197-freew-legal-template-*` directories are available.

The provenance hashes in the bundle are explicitly hashes of ignored,
disposable JSON content: capture-manifest content or comparison-report content.
They identify the local evidence that produced the recorded metrics; they are
not hashes of tracked PNGs or claims that those disposable files are committed.
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
