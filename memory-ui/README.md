# Memory ImGui UI recreated for Roblox

## Install

1. Add `MemoryUI.client.lua` as a **LocalScript** under `StarterPlayer > StarterPlayerScripts` in Roblox Studio.
2. Press Play. The dashboard appears immediately; the loader, username, and password screens have been removed.
3. The script creates its entire `ScreenGui` at runtime. It uses a 1399 × 731 coordinate frame and uniformly shrinks it to fit smaller viewports.

## Assets

`assets/` contains the image, icon, and font files extracted from the supplied project. All 24 SVG icons also have white PNG masks for Roblox uploads; the script applies the original source colors with `ImageColor3`. The `ASSET_IDS` and `ICON_IDS` tables near the top of the script accept uploaded Roblox image asset IDs. Use the file stem as the key for icons; for example, upload `assets/target_fill.png` and set `ICON_IDS.target_fill` to its asset ID. `icon-manifest.json` maps icons to their UI locations and Roblox asset IDs. For the main textures:

| Lua key | Source file |
| --- | --- |
| `background` | `subtle_dark_interface_background_texture.png` |
| `sidebarCrown` | `sidebar_crown_logo.png` |
| `sliderFill` | `example_slider_filled_part.png` |

In standard Roblox, icons remain hidden when IDs are empty, so unsupported Unicode glyphs never appear. Roblox cannot display local file paths or raw GitHub image URLs directly in `ImageLabel`. A guarded adapter uses the GitHub PNGs only when the runtime exposes `writefile`, `getcustomasset`, and `game:HttpGet`; it caches image bytes locally and never executes downloaded code. This adapter has not been tested in the user's target runtime. Set `FONT_IDS.inter`, `.geist`, and `.roboto` to uploaded Roblox FontFamily IDs to use the extracted source fonts; without IDs, the script uses Gotham. The source icon font is represented by PNG masks. Four login icons remain in `assets/` for source completeness but are not used by the script.

## Scope and source map

The implementation follows `generated/generated_ui.cpp`, `generated/generated_theme.hpp`, `generated/lazyui_runtime.cpp`, and `Menu/main.cpp` from the supplied archive. It creates the dashboard directly, sidebar selection, seven visible dashboard sections, 14 source switches, slider, two one-item dropdowns, editable fields, and drag interaction. Controls keep local UI state.

The source has no separate Aimbot, Manipulation, or Triggerbot pages and no color picker. At your request, this version adds distinct UI pages for those tabs and body/outline/highlight HSV pickers on Visuals. These additions follow the dashboard's visual style but are not source-identical. The new controls have UI state only. The top `Visuals > Players > World` labels are static source breadcrumbs; the Luau version makes their selection clickable. The two dropdowns each contain only `Player 1` in the source. The source window is fixed at 1399 × 731 and `resize_window` is empty. The slider value box accepts 0–100 to one decimal place; press Enter to apply it.

## Fidelity limits

This is a source-based ScreenGui recreation, not a verified pixel match. Roblox ScreenGui uses retained UI objects and different text rasterization from Dear ImGui/DirectX. Rounded corners, custom glyph spacing, image tinting, blur, and some exact alpha/animation states therefore differ. The original DX11 blur and arbitrary ImDrawList geometry are not reproduced. The source does not provide Roblox gameplay behavior for the visible switches, and this script does not invent it.

The Luau file passed a static Lua parse check. It has **not** been run in Roblox Studio or compared side by side in Roblox at the video viewport. Asset IDs are empty until the images and font families are uploaded. The supplied screenshots have different viewport sizes: their outer menu proportions agree after normalization, so the fix retains the source's 1399 × 731 geometry rather than shrinking every component arbitrarily. See `geometry-audit.md` and `font-manifest.json`.
