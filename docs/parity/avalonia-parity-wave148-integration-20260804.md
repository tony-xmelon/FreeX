# Avalonia parity Wave 148 integration

Date: 2026-08-04

Final upstream base: `42af3da77d`.

## Accepted slices

- FreeX Print Preview now opens the existing Page Setup workflow when the user
  chooses Custom Margins or Custom Scaling Options. The live preview
  re-paginates after the nested dialog closes instead of silently reverting a
  no-op selection.
- FreeW Insert Text from File now preserves DOCX body blocks, tables, rich run
  formatting, styles, annotations, numbering, and reachable preserved package
  parts through the existing `DocumentMerge` path. The inserted block sequence
  is one Avalonia undo action; plain TXT insertion remains text-only.
- FreeP Avalonia now follows WPF's in-place-first OLE activation route on
  Windows for unrotated, unflipped embedded shapes. Native-host failure falls
  back externally exactly once, edited bytes commit to the existing payload,
  and refresh, editor rewire, and window shutdown deterministically dispose the
  host and remove temporary storage.
- Shared WPF and Avalonia ribbon renderers now consume one neutral tab-chrome
  metric contract for header height, label padding and font size, selected
  underline thickness, and inter-tab spacing.

## Integration review

The FreeP implementation was returned before acceptance for two lifecycle
issues: synchronous native-host failure could publish a closed overlay child,
and window shutdown did not explicitly dispose an active host. The final patch
removes the exact candidate before publishing failure, keeps external fallback
single-owner, resets hit testing, and closes the active host from the window's
`Closed` path.

## Evidence boundary

The OLE in-place host is a Windows Avalonia capability because it depends on
COM and native child windows. Linux/macOS, rotated/flipped shapes, and servers
that decline in-place activation retain the existing external activation and
payload-preservation path. FreeX native printer properties and Print Selection
remain separate platform workflow gaps. Ribbon structural equality is stronger
than duplicated constants but does not by itself prove pixel identity across
all fonts, DPI values, and desktop compositors.

## Verification

The combined focused lane passed `444/444` tests:

- FreeX live Print Preview rail: `4/4`.
- FreeW Avalonia insert depth and shared document merge: `50/50` and `20/20`.
- Shared Avalonia and WPF ribbon tab chrome: `1/1` and `1/1`.
- FreeP OLE routing, window lifecycle, and package round trip: `2/2`,
  `356/356`, and `10/10`.

Repository preflight passed over `220` JSON files, `261` XML-backed files,
`90` PowerShell scripts, `125` .NET projects, `92` solution entries, and all
`22` default-test solution entries. FreeP whole-window evidence remained
`33/33` paired with zero explicit mismatches or capture limitations after its
`173`-artifact manifest was regenerated. The full `Release` solution build
completed with zero warnings and zero errors.

The serialized default lane produced one order-dependent WPF clipboard failure
in `PlainCtrlV_SingleArea_StillCarriesRules`; it passed alone and the complete
affected assembly then passed `1,498` executable tests with `4` benchmark
skips. Substituting that full-assembly rerun, current-source default evidence is
`36,438` passed across `21` test assemblies, `134` benchmark or explicit skips,
and zero failures.

After the default lane, the final upstream merge added FreeW explicit
auto-hyphenation preservation and nested fidelity-corpus coverage. Its affected
Avalonia, WPF host, and Core IO suites passed `86/86`, `25/25`, and `229/229`;
repository preflight and the full zero-warning Release build then passed again.
