# FreeW authored note reference-mark parity (2026-08-04)

## Scope

WordprocessingML note bodies may omit `w:footnoteRef` or `w:endnoteRef`. Word then renders only the authored note text. FreeW previously discarded that distinction while reading, always restored the marker while writing, and painted an automatic number in WPF and Avalonia.

The model now retains `HasAutomaticReferenceMark` for footnotes and endnotes. DOCX reading records the source element, writing emits it only when retained, merge/mail-merge clones preserve it, and both host planners suppress only the absent marker. Newly authored notes still default to an automatic marker.

For WPF, an absent marker keeps a zero-width superscript metric anchor. This preserves the established footnote pagination reservation without painting or horizontally reserving an unauthorized glyph. The dedicated endnote overflow surface also applies the measured 8-DIP Word top registration.

## Package evidence

- `endnotes.docx` SHA-256: `38EA812C80EBFD6E42905A13D120F4B7FFA093E981CFB990CB1B6FB8E274911A`
- `footnotes.docx` SHA-256: `467AC274B16517B7AA6549F67A2539173A90031024B22EE5E0A7B2EFEF08CBF4`
- Both fixture note parts omit their automatic reference element.
- Focused package tests assert serialized XML omission, reopened-model retention, and the default-marker path.

## Visual evidence

Fresh Microsoft Word COM export and the rebuilt Release `FreeW.FidelityRender` consumer used matching 816x1056 PNG surfaces. Mean absolute RGB channel differences are percentages.

| Fixture/page | Before | After | Result |
| --- | ---: | ---: | --- |
| endnotes p1 | 4.9560% | 4.9560% | byte-stable control |
| endnotes p2 | 5.8716% | 5.8716% | byte-stable control |
| endnotes p3 | 0.5919% | 0.5453% | improved |
| footnotes p1 | 4.5929% | 4.5857% | improved |
| footnotes p2 | 5.7632% | 5.7632% | byte-stable control |
| footnotes p3 | 4.0832% | 4.0832% | byte-stable control |

Target ROIs:

- Endnotes p3 top 260px: `2.3893% -> 2.1997%`.
- Footnotes p1 bottom note band `(0,800)-(816,1000)`: `4.2766% -> 4.2385%`.

Word PNG SHA-256 references:

- Endnotes p1/p2/p3: `25BA55CB1A97FA9B2ECB2A56A2210A436D292C96D3DF965E8FF0599B030E1094`, `92053B505556E3296E0A448D74278A005F3AF0CF752F4F9A4D93FA7D977011F8`, `F52AF49A7081883AE9EFB197217592F4BAED988CC2B3867E079446BCC9E93052`.
- Footnotes p1/p2/p3: `09F5B8C62C7450DD771AA1FC5EBF31C29152C875EB83CA2EDDEF227B8702EBA1`, `2611E3E0CC5AE96B9637407818F6B93851B64A35D9C680ED168BF15629129D36`, `EEE0524C8819752A715D6793CD14785BB99FAE497520DA63C92393942B62F2D6`.

## Verification

- DOCX package/default-marker tests: 4/4.
- Shared note-region planner tests: 7/7.
- FidelityRender source contract: 1/1.
- WPF host, Avalonia host, and FidelityRender Release builds: 0 warnings, 0 errors.
- Repository preflight: passed.
- `dotnet build FreeX.slnx --configuration Release`: passed with 0 warnings and 0 errors.
- The default test aggregate recorded 32,780 passing tests and one unrelated FreeP startup-shutdown timeout before its 10-minute runner bound; the failed test passed 1/1 when rerun alone.
- The UI aggregate recorded 1,037 passing tests and eight unrelated FreeX spreadsheet failures before the host-test process exceeded its 10-minute runner bound. No failure involved FreeW note package, layout, or rendering code.

## Process rule

Treat marker presence as serialized source authority. If suppressing a visible marker changes pagination, separate paint ownership from line metrics; do not restore an unauthorized glyph merely because its font metrics accidentally reserve useful space. Gate the complete affected footnote/endnote page sequence and rebuild the actual fidelity consumer before scoring.
