# FreeP Modern Comment Author Identity Persistence - 2026-07-04

## Scope

This slice advances the FreeP modern comments/review workflow-depth lane by
preserving PowerPoint-authored modern comment and author identity metadata
through the shared model, shared review descriptors, package read/write, and
clone/mutation paths.

## What changed

- `SlideComment` now carries modern comment id, author id, author user id, and
  provider id metadata from `p188:cm` plus `p188:author` records.
- `SlideCommentReply` now carries modern reply id and the same modern author
  identity metadata for threaded replies.
- `PresentationCommentDescriptor` and `PresentationCommentReplyDescriptor`
  expose those identity fields so WPF and Avalonia can remain thin consumers of
  the shared review plan.
- `PptxPackageReader` reads modern author `userId`/`providerId` values and
  attaches them to comments and replies.
- `PptxPackageWriter` preserves imported modern comment ids, reply ids, author
  ids, user ids, and provider ids when present, while retaining deterministic
  generated identities for new FreeP-authored reviewers.
- `SlideCloner` and shared comment mutation plans preserve the modern identity
  fields during duplicate/edit/reply/resolve/reopen workflows.

## Verification

- `SectionsCommentsTests` proves modern comments read PowerPoint-authored
  comment ids, reply ids, author ids, user ids, and provider ids into the model
  and shared pane descriptors.
- `SectionsCommentsTests` proves read/write preserves imported PowerPoint
  author/comment/reply ids in `ppt/authors/author1.xml` and
  `ppt/comments/comment1.xml`.
- Existing modern comment round-trip coverage now verifies explicit preserved
  ids and provider metadata for FreeP-authored modern comment packages.

## Remaining Work

This does not implement rich mention UI, coauthor presence/cloud identity sync,
or PowerPoint-authoritative visual baselines. It preserves local package
identity metadata so those richer review surfaces have stable shared evidence
to consume.
