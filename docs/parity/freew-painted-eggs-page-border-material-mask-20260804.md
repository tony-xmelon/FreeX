# FreeW Painted Eggs page-border material mask (2026-08-04)

## Scope

The imported Word `eggsBlack` page-border route (art ID 66) used nine smooth
polygons per motif. Word instead paints a 32x32 asymmetric, mottled grayscale
sprite. The shared page-border planner now consumes a measured four-level mask,
so WPF and Avalonia/PDF use the same source-faithful material plan.

## Provenance

- Fixture: `eggs.docx`, SHA-256
  `F6EBBADA0FB52F60D33D4566AA04538A288BA1DAE7804A1043116E91FAB4E9F7`.
- Word COM PNG: 816x1056, SHA-256
  `4AE17F03FF3003DC11765BA8AEE40E0B264ECB591B417A9F357D32E241A5ED45`.
- FreeW path: rebuilt Release `FreeW.FidelityRender --composite`, 816x1056.
- Current-main PNG: SHA-256
  `7DBE1F9EBA1FF0177F62910D26F8561F5C0B5B8099D7ADA5211376D58088D7F5`.
- Candidate PNG: SHA-256
  `B9758DDE620851824202A4F3F228768A523B6903EADD41EC0B0C5F606E7DCFA5`.

## Results

Mean RGB absolute-difference percentages against the same Word PNG:

| Region | Before | After | Delta |
| --- | ---: | ---: | ---: |
| Whole page | 3.9051% | 1.8550% | -2.0501 pp |
| Top rail | 18.8182% | 6.2105% | -12.6076 pp |
| Bottom rail | 18.6820% | 6.9018% | -11.7802 pp |
| Left rail | 18.6158% | 8.4400% | -10.1758 pp |
| Right rail | 18.4691% | 8.8283% | -9.6409 pp |
| First 32x32 motif | 28.1150% | 2.8029% | -25.3121 pp |
| Interior control | 0.6521% | 0.6521% | 0.0000 pp |

The interior control is pixel-identical. Removing the obsolete polygon builder
after acceptance also produced a byte-identical candidate PNG. Render time fell
from 12.2 seconds to about 4.1 seconds because the shared plan emits horizontal
material runs rather than 918 antialiased polygons.

## Verification

- `PageBorderArtVisualPlannerTests`: 19/19.
- Focused Avalonia direct-PDF Painted Eggs and Weaving Ribbon controls: 2/2.
- `FreeW.FidelityRender` Release build: 0 warnings, 0 errors.

## Process rule

When Word border-art cadence and placement already match, isolate one clean
motif and preserve its material levels in a shared mask. Accept only with the
same Word target, whole-page and all-edge gains, an unchanged interior control,
and a byte-stable neighboring sprite route after helper generalization.
