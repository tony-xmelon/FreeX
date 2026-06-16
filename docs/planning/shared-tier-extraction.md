# Shared Tier Extraction (FreeX + FreeW suite)

Goal: turn this repo into a **monorepo suite** so a new Word-like app, **FreeW**, can be
built on top of the domain-neutral infrastructure already proven in the spreadsheet app,
**FreeX**. Reusable code is lifted into a `shared/` tier under the `Free.Shared.*` namespace;
the spreadsheet-specific code stays in `FreeX.*`; FreeW will live under `freew/` as `FreeW.*`.

Decisions (locked):
- Monorepo suite (this repo), not a separate FreeW repo or NuGet packaging (revisit packaging
  only once the shared API stops churning).
- Full extraction up front, including the WPF app shell — sequenced easy → hard so the
  boundary is validated before the entangled shell is touched.
- Shared namespace prefix: `Free.Shared.*`. Apps stay `FreeX.*` / `FreeW.*`.

## Target layout

```
shared/
  Free.Shared.Ribbon/       # app-neutral ribbon model + builder + layout (was FreeX.Ribbon)
  Free.Shared.AppServices/  # settings/recent/autosave/diagnostics/paths/atomic-io/dirty-state
  Free.Shared.Opc/          # OPC/OOXML plumbing: package paths, content-types, _rels, secure XML,
                            #   zip-bomb guard, atomic save stream, IFileAdapter, DrawingML color/theme
  Free.Shared.Commands/     # undo/redo framework: ICommandBus, CommandBus, composite/transaction
  Free.Shared.Shell/        # WPF shell: window chrome, multi-window registry, backstage/options/print
                            #   dialog frames, theming, DI bootstrap (interface-driven, no grid types)
src/        # FreeX.* spreadsheet app (unchanged ownership)
freew/      # FreeW.* word app (Phase 6)
tests/      # test projects; shared-tier tests use Free.Shared.*.Tests names
```

## Phase plan (each phase ends on a green build + relevant test lane)

0. Establish `shared/` tier + this doc + a `/shared/` solution folder in `FreeX.slnx`.
1. **Free.Shared.Ribbon** — pilot. Single flat namespace, ~35 consumer files. Proves the
   move+rename+slnx+lane-test pipeline.
2. **Free.Shared.AppServices** — ~31 generic services. Split `AppOptions` into a neutral base
   plus a spreadsheet subclass; decouple from `FreeX.Core.Model`.
3. **Free.Shared.Opc** — generic OPC/OOXML layer pulled out of `FreeX.Core.IO`; drop the `xl/`
   hardcoding; must not reference `FreeX.Core.Model`.
4. **Free.Shared.Commands** — generalize `ICommandContext` off the grid model so the command
   bus is app-neutral; spreadsheet command impls remain in `FreeX.Core.Commands`.
5. **Free.Shared.Shell** — extract the reusable WPF shell from `FreeX.App.Host` behind
   interfaces (`IDocumentWindow`, `ITabProvider`, `IBackstageAction`, document factory).
6. **Scaffold FreeW** — `freew/` app tree (host + text/paragraph/run model + docx adapter)
   referencing `Free.Shared.*`; bring up an empty Word-style window with the ribbon.

## Gotchas discovered

- `tests/FreeX.Core.Model.Tests/TestLaneSolutionTests.cs` hard-codes the exact project list
  in `FreeX.DefaultTests.slnx` / `FreeX.UiTests.slnx`. Renaming any test project must update
  this expectation and the `.slnx` lane files together.
- `Directory.Build.props` sets `TreatWarningsAsErrors=true` + `EnforceCodeStyleInBuild`, so
  every extraction step must stay warning- and style-clean.
- `Directory.Build.targets` auto-includes `tests/SharedTestInfrastructure/*.cs` into any
  `*.Tests` project — shared-tier test projects inherit it automatically.
- Central package management (`Directory.Packages.props`) — new projects use `<PackageReference>`
  without versions.
- Verification: default lane is
  `dotnet build FreeX.slnx -c Release` + `dotnet test FreeX.DefaultTests.slnx -c Release --no-build`.
  UI lane (`FreeX.UiTests.slnx`) only when shell/WPF host behavior is touched (Phase 5).

## Phase 3 (Opc) status — increment 3a done

Moved into `Free.Shared.Opc` (namespace `Free.Shared.Opc`), behaviour-preserving:
SecureXmlReaderSettings, SaveStreamPreparer, NativePasswordHelper, WorkbookOpenSizeGuard
(+ WorkbookTooLargeException/WorkbookInvalidException), XlsxXmlTextEscaper,
XlsxXmlNormalizationHelpers, XlsxNativeXmlMerger, XlsxSaveResult, XsltWorkbookTransform.
Wiring: `FreeX.Core.IO` references Opc + global `using Free.Shared.Opc`; six consuming
projects got the same global using; Opc grants `InternalsVisibleTo` to `FreeX.Core.IO`
and `FreeX.Core.IO.Tests` (the moved helpers stay `internal` until intentionally
promoted to the public shared API for FreeW).

Deferred OPC sub-work (real refactors, not moves):
- **Split `XlsxPackagePath`** into a format-neutral path/relationship core (→ Opc) and the
  `xl/`-hardcoded spreadsheet resolution (stays in Core.IO). Unlocks `_rels` reading,
  docProps preserver, thumbnail/signature, package metadata merger — all of which FreeW's
  docx layer needs. Hardcoding sites quoted by analysis: `NormalizeWorkbookTarget` (`xl/`
  prefix), `ResolveRelationshipTarget`/`GetRelationshipTarget` (14 `xl/<dir>` variants),
  `IsWorksheetXmlEntry`.
- **Genericize `IFileAdapter` → `IFileAdapter<TDocument>`** (currently `Load`/`Save` are typed
  to `Core.Model.Workbook`). Unlocks the file-format/dialog cluster: FileFormatDescriptor,
  FileFormatResolver, FilePickerTypeDescriptor, FileDialogFilterBuilder, FileSavePlanner.
- **Cosmetic renames** Xlsx*/Workbook* → Opc*/Ooxml* on the moved public types once the
  shared API surface is intentionally fixed.

## Reuse map summary (why these five)

| Layer | Reusable | Coupling to remove |
|-------|----------|--------------------|
| Ribbon | drop-in | none |
| Commands framework (~600 LOC of 80K) | near drop-in | `ICommandContext` exposes Workbook/Sheet |
| OPC core (~1–2K LOC of 87K) | yes | `xl/` paths; no Core.Model dep |
| AppServices generic (~31 of 94 files) | yes | `AppOptions` mixes spreadsheet fields; some Core.Model refs |
| App shell (~40–80 of 595 files) | partial | grid commands/dialogs/renderers stay in host |
| Core.Model / Formula / Calc | no | FreeW gets its own text document model |
