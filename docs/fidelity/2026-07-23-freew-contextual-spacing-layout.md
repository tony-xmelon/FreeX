# Contextual Paragraph Spacing Layout

The WPF document compositor now applies Word's contextual paragraph-spacing behavior for adjacent ordinary body paragraphs with the same effective style. When the resolved `w:contextualSpacing` state is enabled, it clears both margins at their shared boundary; explicit off and unrelated boundaries retain their spacing.

The first renderer slice intentionally leaves list and table-cell container boundaries unchanged. Their spacing is owned by separate WPF containers and needs separate Word-raster evidence before extending this rule. Focused WPF coverage verifies enabled and explicit-off style cases plus the surrounding document-view round-trip suite.
