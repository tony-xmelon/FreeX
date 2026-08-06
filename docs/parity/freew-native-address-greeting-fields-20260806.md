# FreeW Native Address Block and Greeting Line (2026-08-06)

## Scope

FreeW now authors Word-native `ADDRESSBLOCK` and default formal `GREETINGLINE` complex fields from both WPF and Avalonia. Preview and Finish & Merge resolve the supported native instructions through the existing mapped composite values; imported Word templates without a session mapping auto-match ordinary recipient headers.

The default Address Block follows Word's measured name line and omits the middle-name role. Explicit synthetic `AddressBlock` and `GreetingLine` values remain authoritative so Match Fields and custom session mappings are preserved. Custom native instructions outside the measured signatures retain their cached field and are not silently replaced with default semantics.

## Exact Word Gate

A short-path C# COM corpus authored the native fields in Word over two recipient records. Word serialized:

- `ADDRESSBLOCK  \* MERGEFORMAT`
- `GREETINGLINE \f "<<_BEFORE_ Dear >><<_TITLE0_ >><<_LAST0_>><<_AFTER_ ,>>" \e "Dear Sir or Madam," \l 1033 \* MERGEFORMAT`

Word produced:

- full address: `Dr. Ada Lovelace PhD`, company, two street lines, `London, CA 12345`, and `United Kingdom`
- full greeting: `Dear Dr. Lovelace,`
- sparse address: `Grace Hopper`, one street line, `Arlington, VA 22201`, and `United States`
- sparse greeting: `Dear Grace Hopper,`
- no-name address: an empty leading name line, `3 Anonymous Ave`, `Nowhere, NY 10000`, and `United States`
- no-name greeting fallback: `Dear Sir or Madam,`

FreeW reopened the exact Word-authored template and reproduced all three records line-for-line.

Word package hashes:

- data source: `E748D45A45B15E659E12AA2D149CAA2A760C65703E4CFF842EBC648E66963342`
- merge template: `82D902D3C2E5D21231A73E597F6B1BDF115D16A6ECA440D6B76F452A2952454F`
- merged result: `A5DC7FE2B1A6738AFAE8B260DA796C917F607241C939BFFA3818596EEAFDD5D6`

## Verification

- focused `MailMergeTests`: 166/166
- native complex-field package round trip: 1/1
- Avalonia `MailingsTabTests`: 37/37
- focused WPF native insertion command: 1/1
- WPF finish/session mapping and print controls: 4/4
- WPF host Release build: 0 warnings, 0 errors
- exact Word-authored package/result cross-check: 3/3 records

## Process Note

Composite-field parity has three owners: native package identity, session mapping authority, and exact field-format semantics. Preserve explicit composed values, auto-map only when they are absent, and dispatch only measured native signatures; a shared keyword alone is not enough to claim custom Address Block or Greeting Line compatibility.
