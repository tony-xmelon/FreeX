# FreeW DOCX fidelity — real-world corpus round-trip (2026-06-17)

Ran FreeW's `DocxReader`/`DocxWriter` against the **26-file `freew-fidelity-corpus`** (Apache POI
`test-data/document` + `integration` fixtures: rich formatting, tables, comments, tracked changes,
footnotes/endnotes, multi-section headers/footers, images/drawings/charts, embedded documents,
attachments, and large stress files up to ~3 MB).

For each file: **(1) OPEN** (`DocxReader.Read`), **(2) ROUND-TRIP** (write → re-read), **(3)** compare
modeled-content counts before/after, and **(4)** diff the OOXML *package-part inventory* (original vs
round-tripped) to expose content FreeW drops because it does not model it.

## Headline result

| Phase | Result |
|---|---|
| **Open** (no exception) | **26 / 26** |
| **Round-trip** (write → re-read, no exception) | **26 / 26** |
| **Modeled-content stable** (blocks/tables/paras/runs/chars/images/footnotes/endnotes/comments counts unchanged) | **26 / 26** |

Every document — including the largest stress files (`stress008` 367 k chars / 182 footnotes,
`stress004` 8.7 k runs / 138 footnotes, `saut_page` ~3 MB) — opens, round-trips, and preserves all
content FreeW models, with **no crashes and no measured data loss in the modeled dimensions**. One file
(`deep-table-cell.docx`) round-trips with a **byte-for-byte-equivalent part inventory** (zero drops).

## What FreeW drops on round-trip (package-part inventory diff)

The count metric only proves FreeW preserves what it *models*; a part FreeW never reads is dropped on
write and looks "stable" (absent on both sides). The part-inventory diff catches that. Drops, by category:

### Real content loss (genuine fidelity gaps)
- **Headers / footers** — **FIXED.** FreeW now models **per-section** headers/footers (default + even +
  first), reads/writes first-page (`w:titlePg`) headers, and round-trips **images inside headers/footers**
  (part-local `header1.xml.rels`), byte-equivalent for legacy single-section docs. A real-world **read** bug
  was also found and fixed: `ReadHeaderFooterPart` only read *direct-child* `<w:p>`, but Word wraps header
  content in a `<w:tbl>`/`<w:sdt>`, so table-wrapped headers read as empty and were dropped on write (footers,
  using direct paragraphs, survived — the asymmetry). One-line fix: `Elements(w:p)` → `Descendants(w:p)`.
  **Post-fix corpus result:** every file with *real* header/footer content round-trips it (`PageSpecificHeadFoot`,
  `stress008/010/015/018/023`, …). The only remaining header/footer "drops" are **empty auto-created parts**
  (`checkboxes` 6 empty, `saut_page` 2 empty) that FreeW correctly does not re-emit.
- **Non-PNG image formats** — **FIXED.** `InlineImage` was PNG-only; it now carries an `ImageFormat`
  (Png/Jpeg/Gif/Bmp/Tiff/Emf/Wmf) and round-trips the original bytes + extension + content-type. `VariousPictures`
  (jpeg/png/wmf/emf/pict) no longer drops media. The editor also renders these: WIC for raster formats and
  **GDI+ metafile rendering** for WMF/EMF, with a crash-proof **placeholder** fallback for any undecodable image
  (previously an undecodable image threw `NotSupportedException` and failed the whole document open).
- **Media (images)** still dropped in 4 files (`chartex`, `testComment`, `stress010`, `stress015`). These images
  live in **comment** or **chart** parts, not the body/header/footer run flows FreeW reads. *(Open follow-up.)*
- **Numbering definitions** — **partly fixed.** FreeW now preserves the original `numbering.xml` + paragraphs'
  `w:numPr` (under a disjoint `numId` range, alongside FreeW's own ids) when a paragraph carries a *direct*
  `numPr` FreeW doesn't model as a list. *Corpus residual:* the 3 corpus files still dropping numbering use a
  **different pattern** — `FieldCodes`/`stress023` reference numbering only from **styles.xml** (style-level
  numbering; `numId=0` in the body, `numId=2/10` in styles), which the direct-`numPr` pass-through doesn't reach;
  `stress010` has 6 body `numPr` and warrants a separate look. **Style-level numbering preservation is the open
  deeper follow-up.**

### Subset limitations
- **`settings.xml` / `webSettings.xml` / `customXml`** — **FIXED** via a preserve-and-re-emit pass-through
  (`TextDocument.Preserved`): the original `settings.xml` is captured and FreeW's modelled toggles are
  **overlaid** in CT_Settings schema order (so unmodelled compat/default settings survive); `webSettings.xml`
  and `customXml/*` (item + itemProps + rels) round-trip verbatim with their content-types/relationships.
  Authored-from-scratch docs still emit none of these (byte-equivalent). Closed these drops across all 26 files.
- The **`glossary`** (building-blocks AutoText) document (`PageSpecificHeadFoot`) is still not modelled/dropped (niche).

### Not actual loss
- Several `footnotes.xml` / `endnotes.xml` drops are **empty separator-only parts** (the conventional
  `id=-1/0` separators with no real notes); every modeled note survived (counts stable), so these are benign.
- `theme1.xml` is never *dropped* — FreeW now always writes one (parity Z2), even where the original had none.

## Suggested follow-ups (priority order)
1. **Per-section headers/footers** — extend the header/footer model beyond document-level so multi-section
   and page-specific references round-trip (the highest-impact gap).
2. **Read images from headers/footers/comments** — extend the picture reader beyond the body run flow.
3. **Preserve unmodeled `numbering.xml`** (and `settings.xml`) verbatim when FreeW has nothing of its own
   to assert there — a "pass-through unknown parts" strategy would close most of the remaining gap cheaply.
4. (Low) custom XML / glossary / webSettings pass-through.

## Visual rendering (FreeW's own output)

> **Update (2026-06-17, later):** MS Word (Office16) is now installed and COM-automatable on this machine,
> so the deferred pixel-diff **has now been run** — see
> [`2026-06-17-freew-word-visual-comparison.md`](2026-06-17-freew-word-visual-comparison.md). Headline:
> clean single-page text documents match Word at SSIM ≈ 0.95; gaps concentrate in charts (single series /
> wrong type), header content + header images, footnote/endnote body text, RTL alignment, and pagination
> density. The render also surfaced that FreeW's **Print / Print-Preview crashes** on most real documents
> (`XamlWriter` cannot serialize the editor's non-public paragraph `Tag` types). The original note below is
> retained for context.

A true **pixel-diff against MS Word could not be run on this machine**: no `WINWORD.EXE` is installed (Word
COM is unregistered) and no Word-compatible reference renderer (LibreOffice `soffice`) is present, so there is
no ground-truth Word rendering to diff against. Instead, FreeW's own editor render path (`DocumentView` →
`FlowDocument` → page rasterization) was used to render the first page of representative corpus documents to
PNG, to assess whether FreeW lays these real-world files out sensibly.

What rendered **well** (faithful, Word-like):
- Body text + run formatting (bold/italic), bullet and **numbered lists incl. restarts** (`ComplexNumberedLists`
  shows 1–12 then a restarted 1–2 correctly).
- **Tracked changes** in Word's "All Markup" style — insertions underlined in red, deletions struck through in
  red — alongside blue underlined hyperlinks (`delins`).
- **Footnote reference markers** as superscripts (`footnotes`, `table_footnotes`).
- **Tables with borders** (`checkboxes`).

Observed **rendering gaps** (FreeW's live view, independent of round-trip):
- Footnote/endnote **text is not shown at the page foot** — only the reference marker (a WPF `FlowDocument`
  limitation; the note content still round-trips in the model/docx).
- **Multilevel** list children render as flat decimal (`2-a` → "3.") rather than Word's accumulated `2.1` text
  (the documented best-effort marker limitation).
- **Checkbox content-control glyphs** (☐/☑) are not drawn (the surrounding text/table is faithful).
- Table borders are drawn when the source defines them, but a borderless source table shows no gridlines.
- ~~One embedded image format failed to decode offscreen (`VariousPictures`)~~ — **FIXED**: `VariousPictures`
  (jpeg/png/wmf/emf/pict) now renders all five images (WIC + GDI+ metafile decode; placeholder on any failure).

### Re-running the visual comparison once a Word engine is available
1. Render ground truth: `soffice --headless --convert-to pdf <doc>` (LibreOffice) **or** Word
   `ExportAsFixedFormat`/`Document.SaveAs2(wdFormatPDF)` (COM) → rasterize the PDF pages to PNG.
2. Render FreeW: the offscreen `DocumentView` → `FlowDocument` → `RenderTargetBitmap` harness used above.
3. Diff: per-page SSIM / pixel-delta heatmap (FreeX's image-compare tooling under `tools/` can be adapted).

## How this was run
A throwaway console runner referencing `FreeW.Core.IO` + `FreeW.Core.Model` iterated
`freew-fidelity-corpus/files/*.docx` (fetched via `tools/Fetch-FreeWFidelityCorpus.ps1`). The runner is
not committed; a permanent corpus-gated runner (skipping when `files/` is absent, so CI stays green) would
make this repeatable — see follow-up.
