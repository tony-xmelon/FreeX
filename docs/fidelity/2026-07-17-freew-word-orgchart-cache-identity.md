# FreeW Word Org-Chart Cache Identity

Date: 2026-07-17

## Finding

The generated `orgChart1` hierarchy cache used synthetic DrawingML shape IDs
that were not presentation-point IDs in `data1.xml`. Each node also used a
separate backing and text shape. Word could render the diagram, but could not
cleanly associate the cached geometry with its native presentation graph.

## Fix

The native three-node org-chart data template now maps its `rootText*` and
parent-transition presentation points to the deterministic IDs used by the
cached drawing. Hierarchy output emits one text-bearing rectangle per node and
uses the hierarchy-box width for connector centers.

## Evidence

`chart-smartart-complex.docx` was regenerated and exported through the visible
Word publish path. Word produced both PDF pages and retained all three hierarchy
labels and four pyramid labels:

- `freew-fidelity-corpus/runs/word-orgchart-cache-identity-20260717/word-png/chart-smartart-complex_p1.png`
- `freew-fidelity-corpus/runs/word-orgchart-cache-identity-20260717/word-png/chart-smartart-complex_p2.png`

## Verification

- `SmartArtRoundTripTests`: 33/33
- full `FreeW.Core.IO.Tests` run follows this focused package check.
