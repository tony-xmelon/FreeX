# Contextual Paragraph Spacing Layout

The WPF document compositor now applies Word's contextual paragraph-spacing behavior for adjacent ordinary body paragraphs, coalesced list items, and paragraphs inside the same table cell when they have the same effective style. When the resolved `w:contextualSpacing` state is enabled, it clears both margins at their shared boundary; explicit off and unrelated boundaries retain their spacing.

Table-cell spacing is resolved in the shared real-paragraph construction path, covering ordinary top-aligned and rotated cells plus the nested paragraph hosts used for row-height, border, and vertical-alignment layouts. Constrained rotated row-height hosts retain their required `TextBlock` path, where the renderer now maps explicit logical paragraph margins and applies the same contextual boundary rule. Focused WPF coverage verifies enabled and explicit-off body, list, and table-cell cases plus the surrounding document-view round-trip suite.
