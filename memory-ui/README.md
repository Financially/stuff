# Memory ImGui UI recreated for Roblox

## Install

1. Add `MemoryUI.client.lua` as a **LocalScript** under `StarterPlayer > StarterPlayerScripts` in Roblox Studio.
2. Press Play. The UI starts on the centered login panel, as in the C++ source and video. The original C++ credentials are `Glitch` / `Glitch`.
3. The script creates its entire `ScreenGui` at runtime. It uses a 1399 × 731 coordinate frame and uniformly shrinks it to fit smaller viewports.

## Assets

`assets/` contains the image, icon, and font files extracted from the supplied project. All 24 SVG icons also have white PNG masks for Roblox uploads; the script applies the original source colors with `ImageColor3`. The `ASSET_IDS` and `ICON_IDS` tables near the top of the script accept uploaded Roblox image asset IDs. Use the file stem as the key for icons; for example, upload `assets/target_fill.png` and set `ICON_IDS.target_fill` to its asset ID. `icon-manifest.json` maps icons to their UI locations and Roblox asset IDs. For the main textures:

| Lua key | Source file |
| --- | --- |
| `background` | `subtle_dark_interface_background_texture.png` |
| `sidebarCrown` | `sidebar_crown_logo.png` |
| `loginBackground` | `login_panel_dark_abstract_background_texture.png` |
| `loginCrown` | `login_crown_logo.png` |
| `sliderFill` | `example_slider_filled_part.png` |

In standard Roblox, icons remain hidden when IDs are empty, so unsupported Unicode glyphs never appear. Roblox cannot display local file paths or raw GitHub image URLs directly in `ImageLabel`. A guarded adapter uses the GitHub PNGs only when the runtime exposes `writefile`, `getcustomasset`, and `game:HttpGet`; it caches image bytes locally and never executes downloaded code. This adapter has not been tested in the user's target runtime. The source's embedded Inter, Geist, Roboto, and icon fonts cannot be used without creating Roblox font assets. The script currently uses Gotham as its text fallback.

## Scope and source map

The implementation follows `generated/generated_ui.cpp`, `generated/generated_theme.hpp`, `generated/lazyui_runtime.cpp`, and `Menu/main.cpp` from the supplied archive. It creates the login panel, dashboard, sidebar selection, seven visible dashboard sections, 14 switches, slider, two one-item dropdowns, editable fields, and drag interaction. Controls keep local UI state. The source's `try_login()` credential check and initial Triggerbot selection are retained.

The original menu renders the dashboard independently of the selected sidebar tab; changing tabs changes the highlight, while the same dashboard remains visible. The top labels `Visuals > Players > World` are static breadcrumbs in the supplied C++ source, with no alternate page implementations. The Luau version makes their selection clickable while retaining the only dashboard present in the source. The two dropdowns each contain only `Player 1` in the supplied C++ source. The original window is fixed at 1399 × 731 and `resize_window` is empty. The slider value box accepts a number from 0 to 100 with one decimal place; press Enter to apply it.

## Fidelity limits

This is a source-based ScreenGui recreation, not a verified pixel match. Roblox ScreenGui uses retained UI objects and different text rasterization from Dear ImGui/DirectX. Rounded corners, custom glyph spacing, image tinting, blur, and some exact alpha/animation states therefore differ. The original DX11 blur and arbitrary ImDrawList geometry are not reproduced. The source does not provide Roblox gameplay behavior for the visible switches, and this script does not invent it.

The Luau file passed a static Lua parse check. It has **not** been run in Roblox Studio or compared side by side in Roblox at the video viewport. Asset IDs are empty until the images are uploaded. The supplied screenshots have different viewport sizes: their outer menu proportions agree after normalization, so the fix retains the source's 1399 × 731 geometry rather than shrinking every component arbitrarily.

