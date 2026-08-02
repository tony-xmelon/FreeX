# FreeW Legal Notices Visual Parity Wave 111

Date: 2026-08-02
Scope: FreeW Avalonia Legal Notices initial state and all five notice tabs
Authority: shared WPF `SharedLegalNoticesDialog` and paired 620x600 harness captures

## Change

The shared Avalonia read-only document chrome now matches the WPF authority's selected-tab
frame and focused document border. The text host uses the WPF-equivalent 2 px leading and
1 px trailing inset while preserving the existing text origin, 18 px scrollbar lane,
read-only behavior, focus target, tab lifecycle, automation IDs, and default/cancel button.
The measured 12.1 px Consolas compensation is retained for both short and long documents.

## Fresh Evidence

The WPF and Avalonia harnesses captured all six paired states at 620x600. Changed-pixel
ratios below use the pinned Wave107 baseline values supplied for this slice.

| State | Before | After | Improvement |
| --- | ---: | ---: | ---: |
| `legal-notices.initial` | 9.1022% | 8.9785% | 0.124 pp |
| `legal-notices.tab-project-license` | 9.1022% | 8.9785% | 0.124 pp |
| `legal-notices.tab-legal-notices` | 19.8567% | 18.2777% | 1.579 pp |
| `legal-notices.tab-privacy-notice` | 17.5675% | 16.5145% | 1.053 pp |
| `legal-notices.tab-third-party-notices` | 19.5737% | 17.9952% | 1.578 pp |
| `legal-notices.tab-third-party-license-texts` | 19.9003% | 18.5226% | 1.378 pp |

Evidence manifest and comparison report: `artifacts/freew-legal-wave111-final/report-final/`.

## Verification

- `dotnet test freew/FreeW.App.Avalonia.Tests/FreeW.App.Avalonia.Tests.csproj -c Release --filter FullyQualifiedName~LegalNoticesDialogVisualParityTests`: **11/11 passed**.
- Focused WPF and Avalonia harness captures: **6/6 each captured**, all content gates passed.
- Final paired classification: six genuine visual mismatches with no semantic differences.
