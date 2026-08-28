# FreeX Wave195 AutoFilter Criteria Workflow Evidence

Date: 2026-08-28

Canonical evidence: `docs/parity/evidence/wave195-freex-autofilter-criteria-workflows-20260828/`

## Scope

This FreeX-only note records two passing production Linux physical workflows captured through the Avalonia application in Docker/Weston/VNC:

- Multi-column criteria: Region `North`, Category `Hardware`, Category changed to `Software`, Region cleared while Category remained, Category cleared, save/reopen.
- Color criteria: rendered green fill `#00B050`, changed to rendered yellow fill `#FFC000`, cleared, save/reopen.

The captured X11 manifests report one passed result per selector. The exact postconditions preserve the visible rows, package signatures, dirty-state discard prompt, and reload witness. In both sessions the witness marker was read before reopen, the dirty in-memory mutation was discarded, and the persisted `East` value was read after reopen with `reload-witness-passed=true`.

## Package Transitions

Multi-column:

```text
region-package=ref=A1:C7|columns=0:North;
both-package=ref=A1:C7|columns=0:North;1:Hardware;
changed-package=ref=A1:C7|columns=0:North;1:Software;
region-cleared-package=ref=A1:C7|columns=1:Software;
cleared-package=ref=A1:C7|columns=
```

Color:

```text
green-package=ref=A1:B5|colId=0|cellColor=1|fill=FF00B050
yellow-package=ref=A1:B5|colId=0|cellColor=1|fill=FFFFC000
cleared-package=ref=A1:B5|columns=
```

## Provenance and Boundary

The retained runner provenance identifies source commit `c8609b78c4a0483e65f55a8eb3da1b61893e86ec`, payload fingerprint `90d5c1e625e33149dd9fbda49be5a6d45a3bac3307885dcc66d37faecf3e60b2`, payload file count `778`, and app image IDs `sha256:e7cd3c44db99e49771d84429a87699b6e160f3fed9b925c3ae3f0504f95a68e0` and `sha256:241789748b034be33ea35727aacfdf562ccf7a608b9edbee86a8bd7312acb78b`.

This is bounded physical evidence for production FreeX Avalonia on Linux, not a claim of exhaustive parity or WPF execution. It does not cover other dashboards, other applications, untested filter types, or the later clipboard-consumer cleanup change. No product, harness, shared dashboard, or generator code is changed by this evidence-only slice.

See the bundle `manifest.json` and `hash-audit.txt` for the complete inventory and verification result.
