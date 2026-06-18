# HANDOVER — FreeX fidelity work

**From:** Claude Code session `d7c9c7c4-1124-4422-9847-817c221113e7` (Fidelity / DESKTOP)
**Date:** 2026-06-18
**Branch:** `main` — all work below is **pushed to `origin/main`** (`https://github.com/tony-xmelon/FreeX.git`).
The repo is shared by many concurrent FreeX/FreeW/ribbon sessions, so `origin/main` advances constantly; pull before you start.

---

## 1. What this session did (all merged to main)

This session drove **FreeX↔Excel fidelity** — both *functional* (load / recalc / round-trip) and *visual* (rendering) — across three corpora, mostly via fan-out subagents in isolated worktrees, integrated sequentially.

**Corpora & results**
- **ExcelExamples1.xlsx** (36 real-world sheets) → **100% recalc parity** (956→0 mismatches); visual fidelity built out.
- **Contextures** (8 feature-rich workbooks: pivots, slicers, charts, CF, dynamic arrays, advanced filter, comments) → load crash fixed, dynamic-array reload crash + 4 native calc bugs fixed, schema fixes, full visual pass.
- **tealeg-xlsx** (25 edge-case fixtures, BSD, committed) → all load/round-trip/reload clean; the 4 schema-flagged files are **source-invalid pass-throughs, not FreeX bugs**; the one real gap (chartsheets) was implemented.

**Functional fixes**: array-formula reload-throw (cache `<v>` on save); pivot single-cell `<location>` load crash (`GridRange.ParseCellOrRange`); dynamic-array spill round-trip reload crash; native dynamic-array calc bugs (multi-key `SORT`, `SORT(ANCHORARRAY)`, `SUMIFS(ANCHORARRAY criteria)`, `UNIQUE(CHOOSE(array))`); pageSetup dpi=0 sanitizer; corpus-test bookkeeping.

**Visual fixes**: chartsheets (full-page chart sheets) load + render; combo line-over-band charts; pie legend + per-point colors; clustered-column side-by-side; `todo` StackedBar (single-cell-series synthesis); Budget-v-Actual **deviation bars + percent labels + colored emoji**; conditional-format fills, black table-style headers, AutoFilter dropdown buttons; **form controls** — checkbox/option/spinner/scrollbar/groupbox/label/**dropdown (with resolved selected-item text)**/listbox/button chrome, sub-cell EMU placement, VML-textbox captions.

**Findings docs**: `docs/fidelity/2026-06-15-ExcelExamples1-findings.md` + `docs/fidelity/2026-06-17-*.md` + `docs/fidelity/2026-06-18-*.md` (one per area).

---

## 2. Outstanding / deferred (NOT done — with reasons)

| Item | Why deferred | To unblock |
|---|---|---|
| Funnel / `cx:` chartEx rendering | Only corpus driver is a single **degenerate `treemap`** (`ptCount=0`); general `cx:` rendering is a large feature, poor ROI for one quirky chart | A real (non-degenerate) funnel/treemap/sunburst workbook |
| Form-control **interactivity** (click checkbox→linked cell, dropdown select, spin/scroll) | Behavior, not rendering fidelity — out of the fidelity theme; sizable | Decide it's in scope; wire GridView events → linked cell |
| Chart-label emoji **true color font** | WPF text stack has no DirectWrite COLR/CPAL; impossible. Currently drawn as a faithful colored approximation | (won't-fix unless WPF gains it / Skia path) |
| Dropdown list cells with **number formats** | Current driver is plain-text; uses current-culture number text, not the source cell's display format | A dropdown whose list cells are formatted numbers/dates |
| `testFileToSlice` `defaultImageDpi=32767`, file-03 chart `extLst uri` | **Source files themselves** fail the strict validator; FreeX faithfully preserves (Excel opens fine) — documented non-defects | (none — correct behavior) |

The fidelity backlog is otherwise **exhausted** for the current corpora.

---

## 3. Tools / harnesses (NOT in `FreeX.slnx` — rebuild separately)

- `tools/FreeX.SheetFidelity` — functional gate for any .xlsx: load warnings, unsupported features, structural inventory, formula-parity (recalc vs cached, with volatile/VBA-UDF segregation), round-trip OpenXmlValidator. `--validate-only` validates a file directly (use it to prove a schema error is in the SOURCE, not FreeX). Run: `dotnet run --project tools/FreeX.SheetFidelity -c Release -- "<file.xlsx>"`.
- `tools/FreeX.SheetGridImageCompare` — renders each sheet via the REAL GridView headless (fills/CF/table styling/form controls). Recalcs before render. Excel ground truth optional via `%TEMP%/<sanitizedBaseName>-excel/`.
- `tools/FreeX.ExcelExamplesCharts` — chart census + Excel-COM ground-truth diff + round-trip; `--no-excel` skips COM (diff against pre-saved PNGs).

**Excel COM** is foreground-only and the clipboard (`CopyPicture`) is a single shared resource — capture ground truth SERIALLY (one COM user at a time); have fan-out agents run `--no-excel` against pre-captured PNGs. Use a single en-US instance; `Chart.Export(path,'PNG')` for charts; `Range.CopyPicture(1,2)` + `[Windows.Forms.Clipboard]::GetImage()` (PowerShell `-STA`) for sheets.

---

## 4. Build / verify (and the gotchas that will bite you)

**Fast gate:** `dotnet build FreeX.slnx -c Release` then `dotnet test FreeX.DefaultTests.slnx -c Release --no-build`. Chart/form-control render tests live in `tests/FreeX.App.UI.Tests` (NOT in DefaultTests) — run it too.

1. **HOST-CRASH FLAKE (will scare you):** the gate often ends with `Test host process crashed / Run Aborted` while **all 10 assemblies report 0 failures**. This is an environmental teardown flake (Avalonia host under parallel load), NOT a test failure and usually NOT your diff. Disposition: confirm (a) every assembly shows `Passed!`/0-failed, (b) `FreeX.App.Avalonia.Tests` passes STANDALONE (~430/430), (c) `App.UI.Tests` passes. If all hold, the per-assembly results ARE green — push. (It is sometimes stale-base — one `git fetch && git merge origin/main` + rebuild can clear it — but it also fires on a current base. Don't burn many reruns.)
2. **ZOMBIE-PROCESS FILE LOCKS:** after a crash/reboot, orphaned `testhost`/`FreeX.App.Host`/`dotnet` processes hold the output DLLs → build fails with **MSB3027/MSB3021 "Could not copy … locked by: testhost(PID)"**. These are NOT compile errors. Fix: `Get-Process testhost,FreeX.App.Host,FreeX.App.Avalonia,FreeX.SheetGridImageCompare,FreeX.ExcelExamplesCharts,vstest.console,dotnet | Stop-Process` then rebuild. Read the error TEXT before assuming the code is broken.
3. **Corpus bookkeeping:** flipping a corpus file unsupported→supported can break `XlsxCorpusScaffoldTests`/`XlsxCorpusRunnerTests` public-warning-count tests + `docs/formats/xlsx-corpus-report.md`. Keep the public unsupported-tag count consistent (e.g. `testhyperlinks` carries `sensitivity-labels`).

---

## 5. Working with the shared worktree (concurrency hazards)

- **Don't blind `git stash pop`.** The main worktree + stash stack are shared with concurrent sessions; a blind pop can restore *their* edits. If you must stash to clear a dirty tree for a merge, capture the specific `stash@{N}`/SHA and pop that one. There is currently a leftover `stash@{0}: preserve concurrent edits (gitignore + freew docx)` — concurrent sessions', leave it.
- **Integration pattern that worked:** isolated worktree per agent → `git diff --name-only main...<branch>` license/overlap check → merge sequentially → build → gate → push; chase `origin/main` (it moves every few minutes; FreeW/Avalonia files often show as benign overlap from shared origin lineage).
- **License:** `test-corpus/public/contextures/*.xlsx` are redistribution-UNCONFIRMED — gitignored, NEVER commit. The `.gitignore` entry for them is **not committed upstream** (kept as a local uncommitted edit); verify `git check-ignore` covers them before any `git add`. tealeg-xlsx IS committed (BSD).

---

## 6. Local-only assets you need (not in git)

- `E:\Users\anton\Downloads\ExcelExamples1.xlsx` — primary functional+visual driver.
- `test-corpus/public/contextures/` (8 workbooks) — gitignored, license-unconfirmed.
- Excel ground-truth PNGs were in `%TEMP%` — transient, regenerate with the harnesses.

A full session-transfer bundle (this transcript + memory + these assets + restore guide) was produced at
`E:\Users\anton\Documents\Claude\FreeX-session-transfer-d7c9c7c4.zip` (and staged dir alongside).

---

## 7. Durable knowledge

The cross-session memory under `~/.claude/projects/<project-dir>/memory/` is authoritative — especially **`freex-sheet-fidelity-harnesses.md`** (every harness, gotcha, fix, and the lessons above in detail) and `MEMORY.md` (index). Read it first on the new machine.

## 8. Suggested next step
Pull `origin/main`, drop the contextures assets + ExcelExamples1.xlsx into place, then either (a) wait for new example workbooks to reopen the deferred `cx:`/dropdown-format items, or (b) take a scope decision on form-control interactivity. Nothing is half-finished or uncommitted — the tree was clean and synced at handover (`e615ff9c8`, since advanced by concurrent sessions).
