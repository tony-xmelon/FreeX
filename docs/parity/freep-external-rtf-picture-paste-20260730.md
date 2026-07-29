# FreeP external RTF picture paste

## Scope

The slide-level native RTF paste path now extracts bounded PNG and JPEG `\\pict`
payloads in addition to the existing formatted text projection. WPF and Avalonia
insert the image as a picture shape and retain the RTF text as an editable textbox;
the private FreeP clipboard payload still has precedence over native RTF.

## Safety and limits

- The parser accepts only validated PNG/JPEG signatures, not arbitrary RTF binary data.
- Hex and `\\bin` picture data are bounded by the existing RTF byte limit.
- Unsupported picture formats and malformed payloads continue through the normal
  text/image fallback chain.
- This is slide-level insertion; it does not claim inline picture runs or OLE
  activation inside a text body.

## Verification

- Presentation parser: `RtfPict_PreservesPngPayloadAlongsideText`.
- WPF host: `Paste_ExternalRtfPicture_InsertsPictureAndRetainsText`.
- Avalonia host: `External_Rtf_picture_is_pasted_as_picture_and_text_box`.
