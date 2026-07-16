# FreeP chart view3D retention

## Scope

FreeP now retains authored PowerPoint chart camera metadata from \`c:view3D\`
through the chart model, slide cloning, and PPTX write path.

The retained fields are:

- \`rotX\` / \`RotationX\`
- \`rotY\` / \`RotationY\`
- \`rAngAx\` / \`RightAngleAxes\`
- \`perspective\` / \`Perspective\`
- \`hPercent\` / \`HeightPercent\`
- \`depthPercent\` / \`DepthPercent\`

The writer emits \`c:view3D\` in chart schema order, between
\`autoTitleDeleted\` and \`plotArea\`. The view child order follows the OOXML
chart contract: \`rotX\`, \`hPercent\`, \`rotY\`, \`depthPercent\`, \`rAngAx\`,
\`perspective\`.

## PowerPoint evidence

PowerPoint COM reported these settings for the corpus deck
\`22-chart-baseline-depth.pptx\`:

\`\`\`text
chartType=83 rotation=20 elevation=15 perspective=30
heightPercent=100 depthPercent=100 rightAngle=False
\`\`\`

Those values correspond to \`rotY=20\`, \`rotX=15\`, \`perspective=30\`,
\`hPercent=100\`, \`depthPercent=100\`, and \`rAngAx=0\`.

## Boundary

This slice preserves the authored camera settings for subsequent renderer
work. It does not claim full PowerPoint camera projection parity for the
existing 3-D surface mesh; that remains the leading corpus render residual.

## Verification

- \`dotnet test freep/FreeP.App.Host.Tests/FreeP.App.Host.Tests.csproj --configuration Release --filter "FullyQualifiedName~ChartTests"\`: 86 passed
- \`dotnet test freep/FreeP.App.Presentation.Tests/FreeP.App.Presentation.Tests.csproj --configuration Release --filter "FullyQualifiedName~ChartBaselineCorpusTests|FullyQualifiedName~PptxRepairCorpusValidityTests"\`: 32 passed
