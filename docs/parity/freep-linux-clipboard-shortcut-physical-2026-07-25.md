# FreeP Linux Clipboard Shortcut Probe, Stage 1

This stage adds the foundation for the physical X11 clipboard-shortcut lane:

- suite `freep-linux-clipboard-shortcut-physical`
- app surface `document-editor-clipboard-shortcuts`
- exactly eight ordered contract IDs
- a real visible-window discovery check
- deterministic slide-1 PPTX inspection using only Python `zipfile` and
  `xml.etree.ElementTree`
- mounted package SHA256 and baseline inspection artifacts
- exit-safe JSONL records and final manifest generation

The parser reports package SHA256, editable `p:sp` records (`id`, `name`,
`text`, and bounds), `p:pic` count, and `p:graphicFrame` count. Shell helpers
also provide baseline, duplicate-copy, empty-user-shape, and restored-copy
predicates for the later physical workflow.

Stage 1 does not execute physical C/X/V/A/Z input. The seven clipboard and
mutation rows therefore remain failed with `stage1-not-executed.txt` evidence,
including when the X11 owner precondition is unavailable. This document makes
no claim of a passing clipboard lane; Stage 2 will call the parser predicates
around real physical input and native undo/redo behavior.

Static checks:

```text
bash -n tools/LinuxInteractiveDocker/run-freep-clipboard-shortcut-probe.sh
git diff --check
```
