# FreeP external RTF list-level templates

## Scope

External RTF list definitions now preserve bounded `\\leveltext` substitutions
as renderer-neutral `%1` through `%9` level tokens. The shared marker state expands
those tokens using the active nested counters, so a Word-style template such as
`%1.%2.` remains `1.1.` instead of collapsing to the current level's
`AutoNumType` punctuation.

The template survives shared rich clipboard serialization and FreeP's PPTX
read/write path through an `a:pPr/a:extLst` payload. Ordinary PowerPoint
`a:buAutoNum` numbering remains unchanged when no external template is present.

## Verification

- RTF parser preserves single- and multi-level `\\leveltext` templates.
- WPF/Avalonia shared rich visual planning expands nested markers correctly.
- Private rich clipboard serialization preserves the template.
- PPTX writer/reader preserves the template without changing standard numbering.

This is a functional external-clipboard/package slice. Broader Word list-template
semantics, including unsupported numbering controls and full gallery equivalence,
remain separate work.
