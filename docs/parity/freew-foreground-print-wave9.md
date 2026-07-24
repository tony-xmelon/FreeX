# FreeW Foreground Print Wave 9

Validation date: 2026-07-24

The shared Linux Docker/X11 harness reaches the production FreeW Avalonia Backstage Print
route at `1280x820` and exercises the app-owned CUPS dialog. The harness uses a container-local
`FreeW-DryRun` queue: the intercepted `lp` command records its arguments and copies the generated
PDF to the session evidence directory. It never reaches a host printer or physical device.

## Latest Evidence

Latest manifest:
`artifacts/linux-foreground-print/freew/sessions/20260724T023231487Z/freew-foreground-print/freew-foreground-print-wave9.json`

| Evidence row | Result | Evidence / meaning |
| --- | --- | --- |
| FreeW owner visible and active | passed | Physical X11 screenshot before the route. |
| Print dialog opens and is focused | passed | Production `CupsPrintDialog`, active after Backstage Print. |
| Dialog owner metadata | not-proven | `ShowDialog(owner)` is present, but Xvfb did not expose `WM_TRANSIENT_FOR`. |
| Cancellation restores owner focus | passed | The probe records the actual successful method (`escape`, `pointer-click`, or `tab-return`) and requires the owner to be active afterward. |
| Escape-only cancellation | passed / not-proven | Separate row: passed only when Escape alone closes the dialog; fallback completion leaves this row not-proven. |
| CUPS dry-run submission | passed | Non-empty generated PDF plus recorded `lp -d FreeW-DryRun ...` invocation and restored owner. |
| Native GTK/system print chrome | not-proven | Deliberately outside this app-owned CUPS route and not claimed by headless/Xvfb evidence. |

Latest run count: **5 passed, 0 failed, 2 not-proven**. The cancellation method is recorded in
`print-cancel-method.txt` rather than inferred from the generic restoration row; this run recorded
`method=escape`, `dialog-closed=true`, and `owner-active=true`.

## Reproduce

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\Run-FreeWForegroundPrintValidation.ps1 -Replace
```

The runner stops its owned `freex-linux-interactive-freew-6091` container in `finally`.
