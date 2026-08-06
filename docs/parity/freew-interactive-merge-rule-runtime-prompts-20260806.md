# FreeW Interactive Merge-Rule Runtime Prompts

## Scope

Avalonia could insert `Fill-in` and `Ask` merge rules, but Finish & Merge created an
empty `MergeState`. The evaluator therefore emitted blank results. WPF collected
answers, but its private scanner inspected only top-level body paragraph text.

## Change

`MailMergeInteractivePromptPlanner` now discovers prompts in document order across:

- body paragraphs and split runs;
- table-cell paragraphs;
- text in shapes and nested drawing groups;
- section and final-section headers and footers.

Fill-in prompts are de-duplicated by prompt text and Ask prompts by bookmark name,
case-insensitively. WPF consumes this shared plan. Avalonia awaits each answer before
New Document, Printer, or Check for Errors completion, then passes one populated
`MergeState` through the complete selected-record run. Cancelling a prompt cancels the
finish operation without replacing the template or submitting a print job.

## Functional Evidence

- Core planner contracts: 2/2 passed, covering split-run parsing, quote unescaping,
  ordering, de-duplication, tables, shape text, and a header story.
- Complete `MailMergeTests`: 204/204 passed.
- Avalonia Mailings, dialog-surface, and error-check contracts: 47/47 passed.
- WPF finish-planner source contract: 1/1 passed.
- The Avalonia engine contract proves the same Fill-in and Ask answers are present in
  every merged record and that Ask sets the expected bookmark value.

## Process Rule

Interactive field parity has two owners: document-wide prompt discovery and a host
dialog orchestrator. Keep parsing/traversal shared, keep dialogs host-native, and pass
one state object through the entire record sequence so answers and bookmarks remain
stable for New Document, Printer, and error-check completion.
