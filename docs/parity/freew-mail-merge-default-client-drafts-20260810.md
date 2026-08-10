# FreeW Mail Merge Default-Client Drafts

## Scope

- Materialize one merged message-body draft per validated recipient record.
- Preserve the user's subject and substitute each record into the current mail-merge template.
- Hand encoded `mailto:` drafts to the platform default mail client in WPF and Avalonia.
- Leave review and sending to the mail client; FreeW never sends automatically.

## Safety And Fallbacks

- Invalid recipient addresses and mailto payloads over the bounded shell URI length are skipped with a warning.
- Attachment output remains blocked until a provider with attachment support is available.
- HTML intent is handed off as merged plain text because `mailto:` has no portable HTML-body contract.
- The template and active document are not mutated while drafts are generated.

## Acceptance

- Shared planner proves per-record substitution, address and query encoding, warning behavior, and template stability.
- WPF routes drafts through the shared external-URI allowlist and OS shell launcher.
- Avalonia routes drafts through an injected host launcher; focused tests use a recording launcher and open no real mail client.
- Complete focused mail-merge tests and the FreeW Release solution build pass.
