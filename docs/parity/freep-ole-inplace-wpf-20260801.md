# FreeP WPF In-Place OLE Hosting

## Scope

FreeP previously preserved embedded OLE bytes and opened a temporary copy in the
registered Office application, but every host interaction was external. The WPF
slide canvas now attempts a real in-place OLE site for an unrotated, unflipped
slide OLE frame on double-click.

The host owns the WPF child HWND and supplies `IOleClientSite`,
`IOleInPlaceSite`, `IOleInPlaceFrame`, and `IOleContainer`. The embedded payload
is materialized to a private temporary package, opened through `OleCreateFromFile`,
and copied back into `OleObjectInfo.EmbeddedBytes` when the server closes cleanly.

## Fallback and limits

- If the COM server is unavailable, declines in-place activation, or cannot save,
  the existing external activation path remains the fallback.
- Rotated or flipped objects intentionally use external activation; their slide
  frame cannot be represented by the rectangular child HWND without changing the
  authored transform.
- Avalonia remains external-activation-only because it has no Windows OLE child
  HWND contract in the shared surface.

## Verification

- WPF host Release build: 0 warnings, 0 errors.
- `WpfOleInPlaceHostTests`: 2/2.
- The runtime contract is registered-server dependent; Office installation and
  object-specific COM behavior are required for a live in-place session.
