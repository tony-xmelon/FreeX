# Avalonia parity wave 169: FreeW dialog font fallback

Date: 2026-08-22

## Scope

FreeW's Avalonia Font and Paragraph dialogs now inherit the shared Windows-style
dialog font fallback instead of overriding it with local `Segoe UI` settings.
The shared fallback includes metrically narrower Linux alternatives when Segoe UI
is unavailable.

## Controlled Linux A/B

Parent `4e894a9ed7d7` and candidate `dc3c75e81fa4` were captured with the same
Docker image, WPF authority, route inventory, viewport, and comparison thresholds.

| Font dialog state | Parent changed pixels | Candidate changed pixels | Improvement |
|---|---:|---:|---:|
| Initial | 19.8695% | 19.6941% | 0.1754 pp |
| Populated | 19.9614% | 19.7945% | 0.1669 pp |
| Validation error | 20.1618% | 19.9830% | 0.1788 pp |

Average changed pixels improved from 19.9975% to 19.8239%. Mean channel delta
improved from 12.1582 to 11.8907. All three states improved.

## Verification

- Agent focused run: 21 passed, 0 failed.
- Integration source-guard run: 7 passed, 0 failed.
- The committed Windows-baseline cohort is not used as the A/B authority because
  it was captured in a different rendering environment.
