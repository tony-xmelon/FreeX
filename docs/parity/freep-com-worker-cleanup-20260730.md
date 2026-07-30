# FreeP PowerPoint COM worker cleanup - 2026-07-30

The corpus worker now records the PowerPoint process IDs that existed before
each deck and, after a timeout, terminates only newly created `POWERPNT`
processes in addition to the worker tree. PowerPoint COM startup is also
polled briefly after activation so a newly created process cannot be mistaken
for a pre-existing user-owned instance and left running without `Quit`.

Verification on the current FreeP function integration branch:

- `PowerPointCorpusProcessExporterTests`: 42/42.
- Full corpus run: 25/26 decks exported before the first title-deck startup
  timeout; `01-title-slide.pptx` then exported 1/1 on retry and
  `14-smartart-live.pptx` exported 4/4 in isolation.
- Forced one-second timeout smoke: reported `TimedOut`, reaped its orphan
  PowerPoint PID, and left `PowerPointAfter=0`.

The result is a bounded open/export validation, not a claim of one
uninterrupted 26-deck run. The outer command timeout remains a separate
harness limitation.
