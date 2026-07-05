# FreeP Export/Backstage Evidence - 2026-07-05

This slice closes the next export/backstage evidence-depth gap beyond notes-page
PDF by adding a shared no-COM evidence contract for Backstage fixed-layout PDF,
image sequence export, full-page print package handoff, 3-up handout package
handoff, and video frame-package handoff.

## Evidence Contract

- `PresentationExportBackstageEvidencePlanner` emits WPF and Avalonia rows from
  shared export, print, image, and video planners.
- `tools/FreeP.RenderCompare --export-backstage-evidence <deck.pptx> <outDir>`
  writes `export-backstage-evidence.csv` from that contract.
- WPF/Avalonia rows can pass locally without PowerPoint COM.
- PowerPoint baseline cells are explicitly
  `n/a/deferred-powerpoint-com-baseline`; this is not Microsoft PowerPoint
  visual parity evidence.

## Verification

- `freep/FreeP.App.Presentation.Tests/PresentationExportBackstageEvidencePlannerTests.cs`
- `tools/FreeP.RenderCompare.Tests/ExportBackstageEvidenceTests.cs`
- `tools/Generate-FreePCommandParityInventory.ps1`

## Remaining Work

PowerPoint-authoritative fixed-layout PDF, image, video, native print, and
Backstage visual baselines still require a machine with `PowerPoint.Application`
COM registered.
