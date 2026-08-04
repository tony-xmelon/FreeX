# Avalonia Parity Wave 154: FreeW Legal Notices

Date: 2026-08-04
Scope: FreeW Avalonia Legal Notices, all six dialog-harness states
Authority: current FreeW WPF SharedLegalNoticesDialog at 96 DPI

## Change

The Avalonia adapter now applies a route-local document inset after the shared
read-only template is created and again after the window opens. The WPF field
uses the shared eight-pixel document padding directly; the Avalonia template
adds a leading inset. For this route, the paired captures show that the
authority-aligned leading value is nine pixels, while the right, top, and
bottom values remain the shared eight pixels. The shared shell helper and all
other read-only document consumers are unchanged.

The existing Avalonia 12.1 font compensation, Consolas family, 18-pixel
scrollbar lane, fixed line-height handling, tab chrome, focus behavior, and
Close row are preserved. No legal notice text was changed. A 12.5 font-size
experiment was rejected: it improved one long document's wrapping but raised
the aggregate pixel delta in the other five states.

## Paired evidence

Fresh WPF and Avalonia captures were produced at identical 620 x 600 logical
pixels and 96 DPI. All six WPF captures and all six Avalonia captures passed
the pixel-content gate. The before Avalonia captures came from the same source
revision before this adapter change; the after captures include this change.

| State | Before changed ratio | After changed ratio | Delta | Before mean channel delta | After mean channel delta | Delta |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `initial` | 8.7000% | 8.0637% | -0.6363 pp | 10.256 | 8.978 | -1.278 |
| `tab-project-license` | 8.7032% | 8.0637% | -0.6395 pp | 10.264 | 8.978 | -1.286 |
| `tab-legal-notices` | 18.7965% | 18.1876% | -0.6089 pp | 21.612 | 19.670 | -1.942 |
| `tab-privacy-notice` | 16.5901% | 16.8919% | +0.3018 pp | 19.449 | 19.378 | -0.071 |
| `tab-third-party-notices` | 18.0780% | 17.1573% | -0.9207 pp | 21.972 | 19.782 | -2.190 |
| `tab-third-party-license-texts` | 17.8992% | 17.1914% | -0.7078 pp | 21.678 | 20.058 | -1.620 |

Privacy Notice's changed-pixel ratio is effectively the remaining text-stack
floor: WPF ClearType and Avalonia/Skia choose slightly different wrap points
for a few lines even though the mean channel delta improved. The structural
differences reduced by this slice are the document leading inset and its
resulting text-field geometry; no semantic or accessibility difference was
introduced.

## Verification

- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj --configuration Release --no-restore --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1 --filter "FullyQualifiedName~LegalNoticesDialogVisualParityTests"`
- Result: 13/13 passed.
- WPF route captures: 6/6 captured and content-gated.
- Avalonia route captures: 6/6 captured and content-gated.
- Aggregate comparison bundles were kept as temporary evidence and are not
  part of this commit.
