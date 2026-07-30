# FreeP SmartArt horizontal block list import

The native `horizontalBlockList` SmartArt ID already had a shared live layout,
authoring preset, and host command route, but imported packages were rejected by
the reader's live-layout allow-list and fell back to cached artwork.

The reader now admits the native ID, so imported diagrams use the same shared
horizontal block layout as newly authored diagrams and remain editable after
node/text changes. Verification covers reader admission and live ordered output;
no new native PowerPoint raster-fidelity claim is made.
