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

The six declared route scenario IDs are `legal-notices.initial`,
`legal-notices.tab-project-license`, `legal-notices.tab-legal-notices`,
`legal-notices.tab-privacy-notice`,
`legal-notices.tab-third-party-license-texts`, and
`legal-notices.tab-third-party-notices`. The raw inventory contains each ID
once for WPF and once for Avalonia, and every capture manifest contains the
host-qualified form of exactly its host's six IDs. The evidence test validates
the complete unique sets, not only their counts or route values.

Candidate, baseline, and restored source hashes use
`sha256-normalized-lf-utf8-source-text`: SHA-256 over UTF-8 source text after
normalizing CRLF and CR line endings to LF. This keeps source mutation hashes
portable across clean checkouts with different working-tree line endings.

The WPF authority and all three Avalonia capture sets contain six captured
scenarios at 620 x 600 logical pixels, and every target capture passed its
pixel-content gate. The comparison command returns exit code 2 by design when
it reports genuine visual mismatches; capture commands return 0.

Focused validation:

```powershell
dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj -c Release --filter FullyQualifiedName~Wave197LegalNoticesEvidenceTests
```
