# Avalonia parity Wave 150 integration

Date: 2026-08-04

Final upstream base: `fdeb3b4f484d`.

## Accepted slices

- FreeX Avalonia Print Preview now paginates the current single-cell or
  multi-cell selection, returns cleanly to Active Sheets scope, and preserves
  Selection scope across nested Page Setup changes without mutating the
  worksheet print area.
- FreeW Avalonia Print Layout now implements Justified page vertical alignment
  for single-column body flow. Unused body height is distributed across block
  boundaries, and glyph, object, caret, selection, and hit-test geometry move
  through the same offset path.
- FreeP WPF and Avalonia slideshow playback now honors the selected playable
  media caption track and falls back to the first playable track when the
  selection is absent or invalid.
- Shared WPF and Avalonia ribbon/context-menu renderers now consume one neutral
  menu-item presentation plan. Avalonia no longer discards authored shortcut
  text and projects valid shortcuts to native `KeyGesture` values.

## Integration review

The FreeP slice was returned before acceptance because shape IDs are local to
a slide. A preference keyed only by shape ID could select the wrong caption on
a later slide carrying the same ID. The accepted revision carries the source
presentation slide index through normal, custom-show, and hidden-slide routes;
duplicate shape IDs on other slides retain their own first-playable fallback.

The generated FreeP whole-window evidence manifest was refreshed after the
accepted FreeP and shared ribbon changes. Its only changes are the expected
source hashes for the two FreeP hosts and the WPF/Avalonia ribbon renderers.

## Evidence boundary

FreeX live preview still paginates one active sheet, so Entire Workbook remains
disabled. FreeW Justified layout remains document-wide and single-column;
per-section and column-aware distribution remain separate. FreeP stores the
caption preference only for the transient slideshow launch and does not claim
a global caption-language setting or external caption retrieval. Native popup
focus traversal and shortcut execution remain toolkit-owned beyond the shared
shortcut presentation contract.

## Verification

The combined integration-focused lane passed `50/50` tests:

- FreeX selected-range preview: `4/4`.
- FreeW Justified planner and Avalonia geometry: `9/9` and `4/4`.
- FreeP caption selector and Avalonia media lane: `18/18` and `11/11`.
- Shared Avalonia and WPF menu shortcut presentation: `3/3` and `1/1`.

Worker-side adjacent evidence also passed FreeX preview `134/134`, FreeP WPF
media/package `65/65`, and the complete FreeP Release build with zero warnings
or errors.

Repository preflight passed over `220` JSON files, `261` XML-backed files,
`90` PowerShell scripts, `125` .NET projects, `92` solution entries, `22`
default-test entries, and `11,079` text files. FreeP whole-window evidence is
current at `33/33` paired across its `173`-artifact manifest. The full Release
solution build completed with zero warnings and zero errors. The serialized
default lane passed `36,466` tests across `21` assemblies, skipped `134`
benchmark or explicit cases, and reported zero failures.

The final upstream sync added FreeP print-markup export and FreeW WPF canonical
footnote continuation. Their affected FreeP presentation, FreeW presentation,
and FreeW host lanes passed `78/78`, `140/140`, and `23/23` respectively.
