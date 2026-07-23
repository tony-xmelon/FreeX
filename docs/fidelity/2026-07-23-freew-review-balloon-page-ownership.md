# Review Balloon Page Ownership

`FreeW.FidelityRender` built review balloon sources once per document and painted every
comment on every rendered page. In `f2-comments.docx`, the two comments are anchored on
page 1, but page 2 received a duplicate review strip that Microsoft Word leaves empty.

The fidelity renderer now captures the editor paginator's block-to-page assignment before
the `FlowDocument` is detached and filters each review balloon by its anchor block's
physical page. If assignment cannot be determined, the prior behavior is retained as a
safe compatibility fallback.

Matched Word PNG evidence at 816x1056:

| Fixture / page | Whole-page diff | Review-strip diff |
| --- | ---: | ---: |
| `f2-comments` page 1 | 3.0364% -> 3.0364% (SHA-256 stable) | 14.8699% -> 14.8699% |
| `f2-comments` page 2 | 0.9882% -> 0.7018% | 10.4072% -> 0.0000% |

The independent `review-protection-proofing-comments-only` page-1 control is
byte-identical before and after the change (SHA-256
`9BF9ECB32D596522CC092B5032337D9A2F108A463176EFD51060CD3402432060`).

Verification:

```text
dotnet build freew/tools/FreeW.FidelityRender/FreeW.FidelityRender.csproj --configuration Release --no-restore
  0 warnings, 0 errors

dotnet test freew/FreeW.App.Host.Tests/FreeW.App.Host.Tests.csproj --configuration Release --no-restore --filter FullyQualifiedName~FidelityRender_ScopesCommentBalloonsToTheirAnchorPage
  1 passed
```

The broader existing `VisualEvidenceFidelityRenderSourceTests` method remains stale on its
unrelated `thisPixW - 2 * ins` footer-source assertion; this slice adds and executes a
dedicated ownership contract instead of changing that unrelated expectation.
