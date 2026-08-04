# Avalonia/WPF parity wave 141: FreeW Building Blocks Organizer

Date: 2026-08-04

## Scope

This slice audited the retained genuine visual-mismatch rows for
`building-blocks-organizer.initial`, `building-blocks-organizer.populated`, and
`building-blocks-organizer.validation-error` after the About audit established
that About's remaining difference is the intentional WPF/Avalonia framework
line plus native text rasterization.

## Implementation

The organizer now consumes the shared `BuildingBlocksOrganizerPlanner` contract
from both hosts. It centralizes the WPF-authority width, list/preview minimum
sizes, column gap, labels, empty-state text, list-item metadata formatting,
description-aware preview text, and removal status. Avalonia now also uses
WPF's content-sized, non-resizable shell, displays the same two column labels,
preserves gallery/category metadata in its selected items, renders the same
description/body preview, and disables Insert/Delete when no block is selected.

Before this slice, Avalonia declared a fixed 620x390 resizable surface with
260x220 and 280x220 content controls, omitted both column labels and the WPF
empty/status treatment, formatted previews as name/gallery/category plus body,
and left its action-state contract host-specific. WPF used a 660-DIP,
content-sized surface with 300x240 controls and description/body preview text.

## Evidence

The retained paired baseline was a genuine mismatch in all three states:

| State | Retained changed ratio | Retained mean delta | WPF bounds | Avalonia bounds before |
| --- | ---: | ---: | --- | --- |
| initial | 5.9991% | 4.5855 | `x=14,y=17,518x339` | `x=16,y=16,530x260` |
| populated | 6.0146% | 4.6032 | `x=14,y=17,518x339` | `x=16,y=16,530x260` |
| validation-error | 6.0214% | 4.6317 | `x=14,y=17,518x339` | `x=16,y=16,530x260` |

Fresh post-edit Avalonia captures for all three states passed the full pixel
content gate and measured `x=14,y=18,532x316`. The fresh WPF harness attempt
returned zero valid frames and was rejected by the harness (`0.00%` opaque,
near-transparent/near-black output); no WPF authority or changed-pixel ratio
was replaced. The retained WPF pair therefore remains the only valid visual
comparison authority.

## Verification

- `BuildingBlocksOrganizerPlannerTests`: 2/2 passed.
- `BuildingBlocksOrganizerParityTests`: 2/2 passed.
- Existing WPF `BuildingBlocksOrganizerTests`: 2/2 passed.
- Fresh Avalonia harness: 3/3 organizer states captured and content-gated.
- Fresh WPF harness: 0/1 valid for the initial state; rejected and not promoted.

The remaining visual residual is native WPF versus Avalonia control and text
rasterization plus the still-unavailable fresh WPF raster authority. The About
surface remains semantically aligned apart from its explicitly host-native
framework line and is not changed in this wave.
