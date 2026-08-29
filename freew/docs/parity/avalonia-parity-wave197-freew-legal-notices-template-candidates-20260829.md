# FreeW Legal Notices Wave 197 Template Candidates

Date: 2026-08-29
Scope: FreeW Avalonia Legal Notices tab-template family
Authority: FreeW WPF `SharedLegalNoticesDialog`
Decision: no candidate accepted

## Fresh route-local baseline

The current shared Avalonia source was captured against a fresh WPF authority
manifest at 620 x 600 logical pixels. The four requested long-document rows
were retained as the comparison baseline for both candidate measurements.

| Scenario | Changed pixels | Changed ratio | Mean channel delta |
| --- | ---: | ---: | ---: |
| `legal-notices.tab-legal-notices` | 69,858 | 18.7790% | 21.3559 |
| `legal-notices.tab-privacy-notice` | 59,025 | 15.8669% | 16.5294 |
| `legal-notices.tab-third-party-license-texts` | 66,445 | 17.8616% | 20.3898 |
| `legal-notices.tab-third-party-notices` | 59,886 | 16.0984% | 17.4049 |

The short control rows, `legal-notices.initial` and
`legal-notices.tab-project-license`, were both 31,491 changed pixels
(8.4653%, mean channel delta 9.3954) in the baseline.

## Refuted candidates

### Selected tab-surface trailing margin

Adding a one-pixel right margin to the Legal Notices tab surface regressed all
four target rows. The change was reverted.

| Scenario | Before ratio | Candidate ratio | Pixel delta |
| --- | ---: | ---: | ---: |
| `tab-legal-notices` | 18.7790% | 18.8970% | +439 |
| `tab-privacy-notice` | 15.8669% | 15.9852% | +440 |
| `tab-third-party-license-texts` | 17.8616% | 17.9796% | +439 |
| `tab-third-party-notices` | 16.0984% | 16.2164% | +439 |

The short rows also regressed by 437 pixels each, so this was not an
unaffected-control-preserving correction.

### WPF shared overflow line box

Changing the shared overflowing-document line box from 15.0 to the WPF shared
16.0px metric produced a visible text-stack change but did not improve the
family as a whole. It was reverted.

| Scenario | Before changed | Candidate changed | Pixel delta | Ratio delta |
| --- | ---: | ---: | ---: | ---: |
| `tab-legal-notices` | 69,858 | 69,050 | -808 | -0.2172 pp |
| `tab-privacy-notice` | 59,025 | 63,164 | +4,139 | +1.1127 pp |
| `tab-third-party-license-texts` | 66,445 | 63,353 | -3,092 | -0.8312 pp |
| `tab-third-party-notices` | 59,886 | 65,338 | +5,452 | +1.4656 pp |

The short rows were unchanged. Because two target rows regressed, this
general candidate was not accepted.

## Verification and disposition

- The candidate outputs were captured with the route-local `legal-notices`
  harness using the same fresh WPF authority manifest.
- All six WPF and all six Avalonia route-local captures passed capture/content
  validation.
- The shared Avalonia source files are restored exactly to `HEAD`; no FreeX or
  FreeP files were changed.
- No production code or test assertion was changed because no candidate
  improved all four target rows while preserving the short controls.

Commands:

```powershell
dotnet run --project freew/tools/FreeW.DialogVisualHarness/FreeW.DialogVisualHarness.csproj -c Release -- inventory --repo-root . --output artifacts/wave197-freew-legal-template-inventory
dotnet run --project freew/tools/FreeW.DialogVisualHarness.Wpf/FreeW.DialogVisualHarness.Wpf.csproj -c Release -- --inventory artifacts/wave197-freew-legal-template-inventory/freew_dialog_evidence_inventory.json --route legal-notices --output artifacts/wave197-freew-legal-template-before-wpf
dotnet run --project freew/tools/FreeW.DialogVisualHarness.Avalonia/FreeW.DialogVisualHarness.Avalonia.csproj -c Release -- --inventory artifacts/wave197-freew-legal-template-inventory/freew_dialog_evidence_inventory.json --wpf-authority artifacts/wave197-freew-legal-template-before-wpf/wpf_dialog_capture_manifest.json --route legal-notices --output artifacts/wave197-freew-legal-template-before-avalonia
```

Tracked audit bundle: [`freew/docs/parity/evidence/`](evidence/), including
the exact candidate metrics, source mutations, capture-manifest provenance,
and checksums for the ignored local capture artifacts.
