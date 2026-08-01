# FreeW Avalonia PDF header/footer images

## Result

The Avalonia direct-PDF path now exports page-resolved header and footer images.
It reuses the live header/footer items after section, first-page, odd/even,
alignment, dimensions, and page ownership have been resolved. This avoids a
second export-only paginator and retains the shared image crop, opacity,
rotation, flip, and adjustment path.

Images are emitted in the existing header/footer pass after in-front floating
objects and before note regions, matching live Print Layout ownership.

## Verification

- `FreeW.App.Avalonia` Release build: 0 warnings, 0 errors.
- `FreeW.App.Avalonia.Tests` Release build: 0 warnings, 0 errors.
- `DocumentViewPdfExportTests|DocumentViewHeaderFooterTests`: 38/38 passed.
- The focused PDF contract uses distinct first-page, even-page, and default
  odd-page header images and verifies their bytes, alignment order, page bounds,
  page selection, and portable PDF serialization.

## Remaining scope

Run-level character surfaces and decorations remain separate direct-PDF visual
owners. Header/footer text and images are now both retained.
