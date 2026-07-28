# Floating-Wrap Fixture Identity

## Finding

The combined visual-evidence runner first generated the canonical
`f2-01-float-wrap.docx` from `FreeW.FidelityRender`, then generated a legacy
object corpus into the same directory. The latter used the same filename but
different text, image bytes, and floating anchors. A Word PNG captured from the
canonical fixture could therefore be compared with a WPF PNG rendered from the
legacy fixture.

The mismatch is visible without a diff tool: the canonical Word page begins
with `F2-01: Floating image wrap evidence`, while the overwritten WPF input
began with `F2-01: Floating image with Square and Tight text wrap`.

## Change

The legacy object fixture is now named `f2-objects-01-float-wrap.docx`.
`f2-01-float-wrap.docx` remains exclusively owned by the canonical
FidelityRender F2 corpus and its MS Word baseline policy.

## Verification

- Source contract prevents the legacy generator from writing the canonical
  filename.
- Regenerate both corpora into one directory and verify the canonical DOCX hash
  remains unchanged after the legacy generator runs.
- Render the canonical fixture against the existing matching Word PNG before
  using it for visual-rank decisions.
