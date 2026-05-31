# Localization Plan

Date: 2026-06-01

## Goal

Make FreeX localizable without weakening spreadsheet fidelity. UI text should come from resources selected by `CurrentUICulture`; user-entered and displayed numbers/dates should respect `CurrentCulture` or an explicit workbook/import culture; file formats, formula storage, telemetry IDs, schema IDs, and command identities should remain invariant.

## Current State

- FreeX is a .NET 10 WPF desktop app. `FreeX.App.Host` owns the shell, dialogs, message boxes, localization resources, and command surface; `FreeX.App.UI` owns custom rendering such as the grid and charts; core projects own model, formulas, commands, calc, and IO.
- The first localization substrate is implemented in `FreeX.App.Host`: `UiText` wraps `ResourceManager`, `LocExtension` binds XAML attributes to resources, `AppLocalization` applies startup UI culture and WPF language metadata, and `AppLanguageCatalog` discovers satellite resources after build.
- Neutral resources now live in `src/FreeX.App.Host/Resources/Strings.resx`. A full Bulgarian satellite resource file, `Strings.bg-BG.resx`, exists and is covered by tests for key parity, placeholder parity, access-key parity, and high-value Excel terminology.
- XAML and host-source guard tests now enforce localization usage for user-facing XAML attributes, message/progress calls, automation names/help text, and used resource keys.
- A large portion of host dialog and shell text now flows through `UiText`/`Loc`. Remaining work is translator review, additional locales, core message-code boundaries, culture-sensitive user input audits, pseudo-localization visual smoke coverage, and package/release language metadata validation.
- Command identity remains a risk area wherever planners still infer behavior from display text. Continue migrating behavior to invariant command IDs before expanding translated command surfaces.
- Culture handling is still mixed: workbook/file paths correctly use `InvariantCulture`, but direct user entry and some dialog/import parsers still need explicit `CurrentCulture` acceptance tests where localized entry should be accepted.

## Localization Boundaries

Localize:

- Window titles, ribbon tabs/groups/commands, context menus, dialog labels, button text, access-key text, keytips, tooltip titles/descriptions, status/progress text, help/about text, message-box titles/bodies, accessibility names/help text, function browser descriptions, chart fallback display labels, and file-dialog display names.

Keep invariant:

- `AutomationId`, command IDs, telemetry event/property names, file extensions, file format IDs, OOXML/XML/JSON payload values, internal enum names, formula storage, canonical formula function names, A1/R1C1 grammar, test fixture data, and persisted workbook content.

Use culture deliberately:

- `CurrentUICulture`: resource lookup for UI strings.
- `CurrentCulture`: user-entered and displayed numbers/dates when no workbook/import culture is specified.
- `InvariantCulture`: file formats, formula engine storage/coercion where Excel-compatible invariant behavior is required, telemetry, package metadata, and diagnostics intended for machines.

## Proposed Architecture

1. Add a localization foundation in `FreeX.App.Host`.
   - Create neutral `en-US` `.resx` resources and a small `UiText` accessor around `ResourceManager`.
   - Add a WPF markup extension, for example `Loc`, for XAML attributes such as `Text`, `Content`, `Header`, `Title`, `AutomationProperties.Name`, and `RibbonTooltip.Title`.
   - Set `FrameworkElement.LanguageProperty` from `XmlLanguage.GetLanguage(CultureInfo.CurrentCulture.IetfLanguageTag)` at app startup so WPF formatting follows the chosen culture.
   - Decide whether the first release supports culture at startup only or live switching. Startup-only is much smaller; live switching needs change notification or dynamic resources.

2. Introduce stable command identity before translating the ribbon.
   - Add an invariant command ID for ribbon/menu commands.
   - Move icon, layout, grouping, keytip, and presentation planning from English labels to command IDs.
   - Store display labels, tooltip titles/descriptions, and keytips as resource keys. Keep keytip conflict tests, but run them against localized resources.

3. Keep programmatic UI on the same resource path.
   - Replace literals in `DialogButtonRowFactory`, `WpfUserMessageService`, `DialogMessageHelper`, `DeferredCommandMessages`, backstage/status planners, context-menu planners, and code-built dialogs with `UiText`.
   - Add format helpers for plurals and interpolated messages so translators see complete sentences with named arguments.

4. Put core user-facing output behind codes.
   - Introduce structured result/message records such as `MessageCode` plus arguments for command failures, validation failures, and accessibility issues.
   - Let `FreeX.App.Host` render those codes through resources.
   - For IO, keep adapter format IDs/extensions invariant and let the host localize display names and file-dialog filters.

5. Separate formula/workbook semantics from localized affordances.
   - Keep stored formulas and parser canonical names invariant for now.
   - Localize function browser names, descriptions, argument labels, and help text.
   - Treat localized formula-name aliases as a later feature at parser/display edges, with explicit round-trip tests.

6. Normalize user culture behavior.
   - Change direct cell entry and dialog numeric/date entry to try `CurrentCulture` first, with invariant fallback where compatibility matters.
   - Keep file import/export parsers invariant by default unless the UI exposes explicit delimiter/date/number culture options.
   - Preserve existing locale-aware number-format behavior and add tests for current-culture display vs invariant storage.

## Rollout

1. Foundation and guardrails
   - **Implemented:** `UiText`, `LocExtension`, neutral resources, Bulgarian satellite resources, startup UI-culture application, and WPF language metadata application.
   - **Implemented:** tests for missing keys, used resource keys, raw XAML user-facing text, inline message/progress text, raw automation metadata, Bulgarian key parity, placeholder parity, and access-key parity.
   - **Remaining:** pseudo-localization resource set and visual clipping smoke pass.

2. Centralized strings
   - **Partially implemented:** common buttons, message-box titles, many dialogs, automation metadata, MainWindow XAML, progress/status calls, and app/startup text now use resources.
   - Continue migrating any residual host/core user-facing strings found by focused audits.
   - This creates early value with low merge risk and establishes patterns for later slices.

3. Ribbon and command identity
   - **Partially implemented:** visible ribbon labels/tooltips/keytips and many automation names are resource-backed.
   - Remaining work is to finish invariant command-ID plumbing anywhere behavior still depends on localized English labels.

4. Dialog batches
   - Convert XAML dialogs in grouped batches: Format Cells/Page Setup/Options, then Data Validation/Find Replace/Goal Seek, then Pivot/Chart/Workbook Theme dialogs.
   - Convert code-built dialogs in separate batches to reduce conflicts.

5. Core message boundaries
   - Convert data validation, command bus, accessibility checker, formula/audit UI results, and workbook model errors from English prose to message codes plus arguments.
   - Add host-side resource rendering and keep core tests focused on codes/args.

6. Culture-sensitive input/display
   - Audit parsers that currently use invariant parsing for user input.
   - Add culture smoke tests for `de-DE` and one pilot UI culture, plus import/export tests proving persisted workbook data remains invariant.

7. Packaging and release
   - Verify satellite resource assemblies survive publish/single-file settings.
   - Update MSIX/package manifest language metadata and localized display/description fields.
   - Add release preflight checks for resources and a pseudo-localized smoke run.

## Parallel Work Slices

- Host localization foundation: resource files, `UiText`, `Loc`, startup culture, and common buttons/messages.
- Command surface identity: command IDs, ribbon planner refactor, keytip/resource tests.
- Dialog extraction: XAML dialog batches and code-built dialog batches.
- Core message contracts: validation/accessibility/command result codes and host renderers.
- Culture behavior: direct entry/import/parser audit and culture-specific tests.
- Packaging/test gates: resource parity, pseudo-localization, MSIX/publish checks, CI integration.

These slices are mostly disjoint if shared files are coordinated: `MainWindow.xaml`, ribbon planner files, and common message helpers should have a single active owner at a time.

## Test Strategy

- Resource tests: every non-neutral resource has the same keys as neutral `en-US`; no missing or whitespace-only values; placeholders match by name.
- XAML/source guardrails: fail on new hard-coded user-visible text outside an allowlist for invariants, icons, file extensions, and test fixtures.
- UI tests: assert stable `AutomationId` values and localized visible/accessibility text from resources instead of duplicated English literals.
- Keytip tests: validate uniqueness per localized menu/tab and detect prefixes/collisions.
- Culture tests: run representative parsing/display tests under `en-US`, `de-DE`, and the pilot UI culture.
- Layout tests: run pseudo-localized resource smoke tests for ribbon/dialog clipping risk.
- Packaging tests: confirm satellite resources are present in publish output and package manifests declare expected languages.

## Risks

- English labels currently drive command behavior. This must be fixed before mass ribbon translation.
- Existing tests are heavily coupled to English copies. Convert tests alongside each migrated surface.
- Invariant workbook behavior and localized user input are easy to blur. Keep explicit helper names and tests for `CurrentCulture`, `CurrentUICulture`, and `InvariantCulture`.
- Access keys and keytips need per-locale conflict checks.
- Pseudo-localized and translated text will expose fixed-width ribbon/dialog layout assumptions.
- Single-file/MSIX packaging may omit or misdeclare satellite resources unless tested.

## Initial Done Criteria

- App can run in default `en-US` from resources with no visible regression. **Implemented for the current resource-backed host surfaces.**
- A full non-English satellite resource can be discovered and selected at startup. **Implemented for `bg-BG`; translator review is still needed before treating the translation as final.**
- Pseudo-localized resources can be selected at startup and cover common shell/dialog/message surfaces. **Remaining.**
- Command identity is no longer derived from localized English labels. **Partially complete; continue replacing display-text classification with invariant IDs.**
- Core user-facing errors converted in at least one vertical slice use codes plus localized host rendering. **Remaining beyond host-layer message/resource migration.**
- Build and relevant tests pass under default culture, with at least one culture smoke suite under `de-DE` or another comma-decimal culture. **Resource tests exist; broader culture parsing/display smoke coverage remains.**
