# Changelog - ThreatBuddyForever
# Changelog

All notable changes to **ThreatBuddyForever** will be documented in this file. This project adheres to Semantic Versioning and is optimized for the **World of Warcraft Vanilla 2.0 (`16001`)** framework baseline.

# Changelog - ThreatBuddyForever 2.0

All notable changes to this project are documented in this file.

## - v2.2.1
## - 2026-10-03
### 🔧 Fixed
- **Role-Isolated Taunt Alerts:** Restricted the `TAUNT` text override and Cyan color formatting exclusively to players actively flagged as a **Tank**. DPS and Healers will now cleanly see their standard native threat tracking percentages on taunted targets.
- **72% Threat UI Freeze Resolved:** Corrected a type mismatch in the layout matrix engine where full array tables were mistakenly assigned to color channels instead of index pointers (`[1]`, `[2]`, `[3]`). Threat display calculations now adjust smoothly between **0% and 100%** without hanging.
- **TOC Initialization Loading Order:** Rearranged structural load steps inside `ThreatBuddyForever.toc`. Library utilities (`Utils.lua`) and directory trackers (`Engine.lua`) now compile completely before driving dependent execution panels.
- **Beta String Version Mismatch:** Reset the global communication hash tracking string to clear trailing character strings (`-beta`), preventing system version channels from throwing false outdated addon alerts.
- **UnitClassification Safety Check:** Added strict string containment wrappers to the trivial mob nameplate filter to prevent fatal runtime script errors if the game client returns `nil` strings.

## - v2.2.0
## - 2026-10-1
### 🔧 Fixed
- **Legacy Addon Message Broadcasting Fix:** Resolved a fatal crash (`attempt to call a nil value`) when entering instanced groups on legacy game clients. Replaced raw `C_ChatInfo.SendAddOnMessage` executions with a flexible fallback matrix that detects classic global namespace functions automatically.
- **Beta Channel String Truncation Patch:** Updated the communication version scanner to cleanly strip non-numeric character strings (like `-beta` flags), allowing version numbers to be compared safely.
- **Corner Clipping Lockout Resolved (Smooth Rounded Edges Fix):** Corrected a core UI bug where checking/unchecking the "Clip Icon Corners" sub-option failed to apply or remove the rounded mask in real-time. 
- **Dual-Channel Texture Architecture Implemented:** Replaced the unstable runtime `SetMask`/`RemoveMask` calls with an independent **Dual-Channel Frame Layout Matrix**. Addon now initializes a standard square canvas (`frame.signal`) and a separate permanently-masked canvas (`frame.signalMasked`) at startup. Checking the box seamlessly switches visibility vectors, bypassing Blizzard's real-time texture drawing locks completely with 100% reliability.
- **Pruned Frame Refreshes Bloat:** Stripped out legacy loop queries inside `TTP_RefreshAllNameplates` to keep nameplate allocation speeds fast and lightweight.
- **Blizzard `<secret string>` Crash Resolved:** Fixed a fatal crash in Mythic+ keys where the game client handed a protected identity format to text filtering routines. Wrapped both `UnitClassification` and `UnitName` check loops to prevent UI failures on affix mobs or hidden dungeon elements.
- **Blizzard `<secret boolean>` Token Crash Corrected:** Addressed an identity tracking error inside instance group clusters. The target locker loop now safely handles restricted cross-faction PvP pointers or protected NPC flags returned by `UnitIsUnit`.
- **Multi-Variable Assignment Table Glitch Fix:** Resolved an intermittent `bad argument #1 to SetTextColor` error caused by an architectural quirk in Lua's multi-assignment handling. Rewrote the color engine channel pipeline to extract Red, Green, and Blue coordinates (`r`, `g`, `b`) explicitly on their own dedicated compilation tracks.
- **Total Opacity Isolation Tuning:** Refactored the layout matrix renderer to fully separate independent transparencies. Fading your text values or pulling your sliders down to a 0% original native color bypass layer will no longer cross-pollute color masking or cause layout drawing skips.
- **Blizzard `<secret string>` Crash Resolved:** Fixed a fatal crash in Mythic+ keys where the game client handed a protected identity format to text filtering routines. Wrapped both `UnitClassification` and `UnitName` check loops to prevent UI failures on affix mobs or hidden dungeon elements.
- **Blizzard `<secret boolean>` Token Crash Corrected:** Addressed an identity tracking error inside instance group clusters. The target locker loop now safely handles restricted cross-faction PvP pointers or protected NPC flags returned by `UnitIsUnit`.
- **Multi-Variable Assignment Table Glitch Fix:** Resolved an intermittent `bad argument #1 to SetTextColor` error caused by an architectural quirk in Lua's multi-assignment handling. Rewrote the color engine channel pipeline to extract Red, Green, and Blue coordinates (`r`, `g`, `b`) explicitly on their own dedicated compilation tracks.
- **Total Opacity Isolation Tuning:** Refactored the layout matrix renderer to fully separate independent transparencies. Fading your text values or pulling your sliders down to a 0% original native color bypass layer will no longer cross-pollute color masking or cause layout drawing skips.
- **Nameplate Recycle Reference Fault Overhaul:** Resolved an issue where widgets remained hidden on alternating pulled packs by swapping camera tracking addresses for parent independent hardware token markers (`frame.unit ~= unit`).
- **Memory Leak & Duplicate Allocations Elimination:** Repaired a resource drain scenario that disabled drawing elements after consecutive dungeon pulls. Rebuilt the out-of-combat cleanup framework to forcefully clear out existing caches when `PLAYER_REGEN_ENABLED` triggers.
- **Unpacked Color Matrix Crash Corrected:** Fixed fatal script failures (`bad argument #1 to SetVertexColor` & `SetTextColor`) by replacing raw table references with explicit index positional mapping variables (`[1]`, `[2]`, `[3]`).
- **Legacy Clear Button Protection Layers:** Wrapped modern asset configurations within a safe structural layer (`if iconEditBox.SetClearButtonEnabled then`) to cleanly shield older legacy classic expansion engines from throwing execution breaks.
- **Circular Alpha Mask Texture Coords Clash:** Resolved a clipping collision error (`Cannot set tex coords when texture has mask`) by removing all manual bounding box crop updates when hardware smooth edge masks are active.

### 🚀 Added
- **In-Game Automatic Version Synchronization:** Integrated an un-taintable addon communication networking loop (`C_ChatInfo.SendAddOnMessage`). Addon now automatically cross-references version release hashes via party/raid packets whenever entering groups.
- **Outdated Client Chat Notification Alerts:** Configured a smart chat warning parser that alerts players directly in their chat logs if a teammate is detected running a newer, updated codebase file.
- **Global Localization Mapping for Version Alerts:** Integrated the communication network channel with our dynamic translation arrays. Version warning notifications are now accurately translated into English, Portuguese, Spanish, Italian, French, German, and Japanese.
- **Automated Tank/DPS Core Inversion Pipeline:** Hooked your rendering color maps directly into Blizzard's native role coordinator API (`UnitGroupRolesAssigned`). The addon automatically tracks your grouping status and specializations, instantly swapping color profiles without needing any manual configurations or clicks.
- **`PLAYER_ROLES_ASSIGNED` Event Tracking:** Integrated an immediate spec-swap listener loop to refresh nameplate indicators the exact millisecond group roles update inside instances.
- **Dungeon Taint Encapsulation Wrappers:** Implemented a multi-tier protective call (`pcall`) architecture to guard core nameplate evaluation metrics. Automatically catches and handles protected client variables silently in the background, allowing threat calculations to proceed uninterrupted.
- **Dynamic Dictionary-Free Icon Solver:** Rewrote texture routing via a direct file-system asset parser. Bypasses Blizzard string protection blocks natively via lowercase forward-slash formatting (`interface/icons/`). It natively handles **any custom or default icon name or pure numeric FileID** in World of Warcraft history without a hardcoded dictionary list.
- **Paginated Global Icon Selection Matrix:** Built an independent **275x300** browsing popup menu directly into the addon. Replaced memory-clogging multi-button allocation schemes with a crash-immune, high-fidelity **5x4 (20 tiles per page)** dynamic paginate grid canvas.
- **Keystroke-by-Keystroke Real-Time Input Syncing:** Re-wired text input streams via the `OnTextChanged` event loop hook. Swaps nameplate icon textures character-by-character **instantly as you type or paste text** without forcing a system `/reload` or pressing Enter.
- **Independent Opacity Sliders Matrix:** Completely uncoupled the indicator layers. The **Threat Indicator Opacity** slider controls text transparency, while the new **Icon Texture Color Opacity** slider isolates the icon asset artwork fading levels independently.
- **Native Color Artwork Bypass Matrix:** Programmed a unique feature rule: dragging the Icon Color Opacity slider down to exactly **0% acts as a Native Color Bypass**. This disables threat tint filters, revealing your chosen icon in its full original artwork colors while keeping threat percentage text dynamically colored.
- **Corner-Clip Custom Sub-Option:** Introduced a dynamic toggle sub-option check button: **"Clip Icon Corners (Smooth Rounded Edges)"** matching localized string parameters across all game clients.
- **Auto-Fit Window Component Width Padding:** Implemented Real-time width padding re-calculators (`GetTextWidth()`) on menu action buttons to dynamically expand or contract containers natively based on active language translations.

### 🗑️ Removed
- **Legacy Clutter Pruning:** Stripped out old, bloated background text-bounding box modifiers, bronze bevel frame attachments (`Interface\\Tooltips\\UI-Tooltip-Border`), and style dropdown menus to achieve a pure, high-performance minimalist layout.

