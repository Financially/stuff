# Source coordinate audit

Coordinates are in the original 1399 × 731 ImGui frame. The Luau script keeps these design-space values and scales the root uniformly.

| Element | C++ draw coordinates | Luau design coordinates | Status |
| --- | --- | --- | --- |
| Dashboard | (23, 35)–(891, 716) | (23, 35), 868 × 681 | Match |
| Sidebar width | x 23–206 | 183 | Match |
| Header | x 206–891, y 35–95 | 685 × 60 | Match |
| Crown | (49, 56)–(88, 81) | sidebar (26, 21), 39 × 25 | Match |
| Brand title | origin (103.03, 53.51) | sidebar label near (80, 18) | Approximate text baseline |
| Aimbot icon | (45.78, 147.75), 16 × 16 | sidebar (22.78, 112.75), 16 × 16 | Match |
| Manipulation icon | (44.05, 186.17), 19.55 × 19.55 | sidebar (21.05, 151.17), 19.55 × 19.55 | Match |
| Triggerbot icon | (44.67, 231.35), 14 × 14 | sidebar (21.67, 196.35), 14 × 14 | Match |
| Visuals icon | (46.52, 306.85), 15 × 15 | sidebar (23.52, 271.85), 15 × 15 | Match |
| Main | (214, 115)–(542, 248) | (214, 115), 328 × 133 | Match |
| Player | (214, 261)–(542, 434) | (214, 261), 328 × 173 | Match |
| Info | (214, 492)–(542, 621) | (214, 492), 328 × 129 | Match |
| Extras | (214, 635)–(542, 708) | (214, 635), 328 × 73 | Match |
| Other | header y 129; body y 163–385 | card (554, 115), 328 × 270 | Approximate card backing |
| Visuals | (554, 399)–(882, 572) | (554, 399), 328 × 173 | Match |
| Effects | (554, 586)–(882, 731) | (554, 586), 328 × 145 | Match |
| Slider track | x 637–791, y 178–184 | Other local x 83–237, y 63–69 | Match width; y within 1 px |

The source uses embedded Inter, Geist, Roboto, and an icon font. The Luau mask images use each SVG's intrinsic dimensions and `ScaleType.Fit`; optional uploaded FontFamily IDs replace Gotham. Text baseline, antialiasing, rounded-corner rasterization, and source blur still require a Roblox runtime comparison. The three new tab pages and HSV picker have no source geometry to compare.
