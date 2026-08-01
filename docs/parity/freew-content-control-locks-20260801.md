# FreeW content-control lock parity (2026-08-01)

## Gap

FreeW read content controls but discarded `w:sdtPr/w:lock`. Saving therefore removed Word's control/content restrictions, and interactive checkbox/list/date changes ignored an authored content lock.

## Slice

- Preserve absence plus all four Word lock values: `unlocked`, `contentLocked`, `sdtLocked`, and `sdtContentLocked`.
- Apply the same model/XML mapping to inline and body-level content controls.
- Emit `w:lock` in `sdtPr` only when the source/model specifies a value.
- Keep control-only locks interactive because they prevent deleting the SDT, not editing its contents.
- Block checkbox, list, combo, and date value changes for `contentLocked` and `sdtContentLocked` in both hosts.

## Verification

- Exact XML/read/reopen lock contracts: 5/5 passed.
- Complete Core IO suite: 1,166/1,166 passed.
- Shared content-control interaction planner: 12/12 passed.
- Avalonia content-control interaction class: 6/6 passed.
- WPF content-control editor class: 9/9 passed.

Deleting a control wrapper is not currently a separate FreeW editing command, so `sdtLocked` deletion enforcement needs no additional host path in this slice.
