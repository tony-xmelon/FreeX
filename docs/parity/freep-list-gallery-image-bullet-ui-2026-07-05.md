# FreeP List Gallery and Image Bullet UI Evidence - 2026-07-05

Scope: bounded FreeP visible paragraph-list UI slice for table-cell text editing plus focused picture-bullet import, render-plan, picker payload, paragraph authoring, and PPTX media-part persistence. This does not claim PowerPoint-authoritative visual baselines or full rich editor parity.

## Improved

- `PresentationListGalleryPlanner` now owns shared WPF/Avalonia bullet and numbering gallery plans, including stable command ids, display labels, preview text, enabled-state, and renderer-neutral preset descriptors.
- The shared bullet gallery exposes disc, hollow circle, square, dash, and check presets plus an enabled picture-bullet command backed by a shared payload and paragraph authoring contract.
- The shared numbering gallery exposes Arabic, upper/lower Roman, and upper/lower alpha presets that route through `TableCellEditPlanner` and the existing undoable table-cell text mutation path.
- WPF and Avalonia ribbon definitions consume the same gallery plans in their Home paragraph groups, keeping host code to menu/control projection and command registration.
- WPF and Avalonia command adapters register the same gallery preset command ids and apply them through the active table-cell list preset route.
- PPTX import now resolves paragraph `a:buBlip/a:blip r:embed` image bullets from slide relationships into a shared `Paragraph.BulletImage` payload.
- `SlideCompositor` and `TextLayoutPlanner` carry imported image bullets into renderer-neutral `TextBulletPlacement` plans, while WPF and Avalonia only decode/draw the shared image placement through thin host helpers.
- WPF and Avalonia picture-bullet commands now feed picked image bytes/content type into `PresentationPictureBulletAuthoringPlanner` and `TableCellEditPlanner`, applying image bullets through the shared undoable table-cell paragraph command path.
- PPTX writer serialization now emits authored image bullets as slide `a:buBlip` relationships plus `ppt/media/slideN_bulletM.*` parts that round-trip through the existing reader.

## Remaining

- Avalonia still lacks a true editable rich-text widget equivalent to WPF `RichTextBox`.
- PowerPoint-authoritative visual baselines for the list galleries and table-cell rich editing were not generated on this machine.

## Evidence

- `PresentationListGalleryPlannerTests.BulletGallery_ExposesPowerPointLikeCharacterPresetsAndImageBulletCommand`
- `PresentationListGalleryPlannerTests.PictureBulletPayload_InfersContentTypeAndClonesBytes`
- `PresentationListGalleryPlannerTests.NumberingGallery_UsesSharedTableCellPresetDescriptors`
- `PresentationListGalleryPlannerTests.TryGetPresetCommand_MapsVisibleMenuCommandsToMutationPreset`
- `TableCellEditPlannerTests.PlanParagraphPictureBullet_SelectionBuildsUndoableSharedCommand`
- `FreePRibbonDefinitionProfileTests.Home_paragraph_group_exposes_shared_visible_list_gallery_in_both_profiles`
- `RibbonEditorCompleteness5BTests.Cmd_Bullets_VisibleGalleryPresetCommand_AppliesSharedTableCellPreset`
- `RibbonEditorCompleteness5BTests.Cmd_PictureBullet_WithInjectedPicker_AppliesSharedTableCellImageBullet`
- `MainWindowHeadlessTests.Ribbon_visible_bullet_gallery_preset_command_routes_to_active_table_cell`
- `MainWindowHeadlessTests.Ribbon_picture_bullet_command_routes_picked_payload_to_active_table_cell`
- `PptxRoundTripTests.RoundTrip_AuthoredPictureBullet_WritesAndReadsBuBlipMedia`
- `BulletsAutofitTests.PptxImport_BuBlip_ResolvesImageBulletIntoSharedRenderPlan`
- `TextLayoutPlannerTests.PlanBodyText_ImageBullet_PlansImagePlacementFromIndentAndHanging`
- `TextLayoutPlannerTests.WpfAndAvaloniaSlideCanvases_DelegateTextLayoutMathToSharedPlanner`
