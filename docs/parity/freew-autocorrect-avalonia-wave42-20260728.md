# FreeW AutoCorrect and AutoFormat Avalonia Parity Wave 42

Date: 2026-07-28

## Closed Functional Mismatch

WPF applies the shared `AutoCorrectEngine` and `AutoCorrect` rules during live text input. Avalonia
previously inserted every text-input character directly, so the same document could receive raw quotes,
typos, list markers, ordinal suffixes, fractions, and URLs in Avalonia while WPF transformed them.

Avalonia now applies the shared result through its existing undoable paragraph-run command path. It wires
the persisted `FreeWOptions` master switch and AutoCorrect/AutoFormat rule settings into the editor, and
handles the WPF-authoritative list, superscript, and hyperlink outcomes without copying WPF APIs.

## Evidence

- Shared model test: **1 new assertion passed** for the list-result contract.
- WPF authority test: **1 new assertion passed**; disabling the master switch leaves smart quotes raw.
- Avalonia headless tests: **4 new tests passed** for typo replacement, ordinal superscripting, all text
  outcomes, and an undoable automatic bullet list with separate subsequent typing history.
- Existing WPF AutoCorrect/AutoFormat and Avalonia editing coverage remains in the focused run.

## Residuals

- Avalonia still relies on its custom editor's existing rendering approximation for superscript metrics;
  this slice closes the input/model behavior and not pixel-level typography fidelity.
- Multi-character IME/paste input continues through the normal insertion path, matching the WPF guard that
  only applies the as-you-type transform to a single text-input character.
