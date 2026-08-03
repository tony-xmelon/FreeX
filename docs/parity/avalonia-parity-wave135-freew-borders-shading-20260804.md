# Avalonia Parity Wave 135: FreeW Borders and Shading

Scope: `borders-and-shading.initial`, `borders-and-shading.populated`, and `borders-and-shading.validation-error`.

The route-only baseline exposed two FreeW-specific mismatches. WPF's visual harness invokes the dialog constructor directly, where the four edge checks retain their seeded checked state; Avalonia applied the paragraph-setting plan during construction and rendered them unchecked. Avalonia now matches that constructor contract, while `ShowAndApplyAsync` applies the plan before the real modal route opens, preserving command behavior. The Avalonia selected tab pane also carried the Fluent template's 12-DIP horizontal inset; the route now uses the shared classic-tab chrome's established `-12` pane compensation so its content frame is flush with WPF.

Focused WPF and Avalonia tests cover the constructor edge-check contract. Fresh matched captures and before/after pixel metrics are recorded below after verification.

| State | Before changed pixels | After changed pixels | Before mean channel delta | After mean channel delta |
| --- | ---: | ---: | ---: | ---: |
| initial | 11.2824% | 11.1902% | 6.5772 | 6.4982 |
| populated | 11.2824% | 11.1902% | 6.5772 | 6.4982 |
| validation-error | 11.3857% | 11.2935% | 6.7362 | 6.6573 |

Fresh WPF/Avalonia route evidence is retained in the ignored branch-local `artifacts/freew-dialog-harness/wave135-final-*` and `wave135-pane-*` directories. All six lifecycle captures passed the content gate, semantics matched, and the three WPF-only tab rows remain `state-not-applicable`. The paired rows remain genuine visual mismatches; this note does not claim full visual parity.
