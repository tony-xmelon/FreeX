# Custom Number Fixed Denominator Fractions Plan

## Tasks

- [x] Identify that formats such as `# ?/4` and `# ??/16` fell through to literal numeric formatting.
- [x] Add focused tests for fixed denominator quarter and sixteenth formats.
- [x] Extend simple fraction detection to recognize numeric denominators after question-mark numerator placeholders.
- [x] Format fixed-denominator fractions without reducing the requested denominator.
- [x] Document the architecture and command-parity decision.

## Decisions

- Fixed denominator formats keep the denominator specified by the format code, matching Excel display semantics for values like `2/4`.
- Variable denominator formats continue to approximate to one or two digit denominators using the existing bounded search.
- This slice does not attempt Excel's spacing alignment for `?` placeholders; it improves displayed values only.
