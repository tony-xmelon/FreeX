# FreeW Avalonia titlebar quick-access contrast — Wave 227 (2026-08-25)

FreeW's Avalonia titlebar now renders its backed Save, Undo, and Redo quick-access controls with the titlebar foreground brush. The titlebar itself intentionally uses FreeW's neutral Office-like `#F3F4F6` surface; the QAT had incorrectly forced white icons on that light background, making the controls effectively invisible.

The shell now resolves the titlebar foreground once and gives that same brush to both the title text and the QAT. This preserves command behavior and makes the existing controls discoverable without adding any platform or external dependencies. The focused shared-frame tests cover the titlebar/QAT wiring.

The canonical shell evidence was recaptured at 1500, 1100, 900, and 750 DIPs, including contextual fixtures. The inventory check passed with 40 paired static captures and 32 paired contextual captures.

Ink/Draw behavior and map-chart fidelity remain deferred by the [UX visual-parity scope](ux-visual-parity-scope-2026-08-25.md).
