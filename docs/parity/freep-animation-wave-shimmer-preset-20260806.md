# FreeP Wave and Shimmer preset semantics - 2026-08-06

PowerPoint-authored emphasis effects use these DrawingML preset identities:

- Wave: `presetClass="emph" presetID="34"`
- Shimmer: `presetClass="emph" presetID="36"`

A short PowerPoint COM fixture created each effect and emitted those IDs with
`presetSubtype="0"`. FreeP previously used IDs 13 and 11 for the two presets.

The shared map now reads and writes the authored IDs. Existing direction and
color-behavior payload handling remains unchanged. Regression contracts cover
Wave direction and Shimmer color payload round-trips. This is a functional and
package-semantics correction; it makes no visual playback claim.
