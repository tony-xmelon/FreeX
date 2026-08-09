# FreeP SmartArt OrgChart Assistant Routing

Date: 2026-08-09

## Functional Gap

The shared orgChart layout already preserved `dgm:pt type="asst"`, used a
side-slot assistant box, and delayed regular reports below the assistant band.
Its relationship output still used the ordinary diagonal parent-to-child line,
so assistant ownership was not represented by an assistant-specific connector
route.

## Change

- OrgChart assistant relationships now emit three shared line segments:
  horizontal from the manager's right edge, vertical through a junction, and
  horizontal into the assistant's left edge.
- Regular reports retain the existing direct parent-bottom to child-top
  connector.
- The route is scoped to the shared `orgChart`/`nameAndTitleOrgChart` plan;
  other hierarchy layouts are unchanged.
- WPF and Avalonia continue to consume the same renderer-neutral `SlideShape`
  connector operations.

## Verification

- Shared SmartArt layout/editing tests: 367/367.
- WPF orgChart assistant compositor test: 1/1.
- Avalonia orgChart assistant compositor test: 1/1.
- Presentation, WPF, and Avalonia Release builds: 0 warnings, 0 errors.

This is a functional relationship-ownership improvement. Exact PowerPoint
connector styling and raster comparison remain separate evidence work.
