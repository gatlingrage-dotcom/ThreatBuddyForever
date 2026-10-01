# Changelog - ThreatBuddyForever
# Changelog

All notable changes to **ThreatBuddyForever** will be documented in this file. This project adheres to Semantic Versioning and is optimized for the **World of Warcraft Vanilla 2.0 (`16001`)** framework baseline.

# Changelog - ThreatBuddyForever 2.0

All notable changes to this project are documented in this file.
## - v2.2.0.5-beta
## - 2026-10-1
### 🔧 Fixed
- **Legacy Addon Message Broadcasting Fix:** Resolved a fatal crash (`attempt to call a nil value`) when entering instanced groups on legacy game clients. Replaced raw `C_ChatInfo.SendAddOnMessage` executions with a flexible fallback matrix that detects classic global namespace functions automatically.
- **Beta Channel String Truncation Patch:** Updated the communication version scanner to cleanly strip non-numeric character strings (like `-beta` flags), allowing version numbers to be compared safely.


## - v2.2.0.4 - beta
## - 2026-09-30
### 🚀 Added
- **Global Localization Mapping for Version Alerts:** Integrated the communication network channel with our dynamic translation arrays. Version warning notifications are now accurately translated into English, Portuguese, Spanish, Italian, French, German, and Japanese.
- **Automated Tank/DPS Core Inversion Pipeline:** Hooked your rendering color maps directly into Blizzard's native role coordinator API (`UnitGroupRolesAssigned`). The addon automatically tracks your grouping status and specializations, instantly swapping color profiles without needing any manual configurations or clicks.
- **`PLAYER_ROLES_ASSIGNED` Event Tracking:** Integrated an immediate spec-swap listener loop to refresh nameplate indicators the exact millisecond group roles update inside instances.


---
## - v2.2.0.3 - beta
## - 2026-09-30
### 🔧 Fixed
- **Corner Clipping Lockout Resolved (Smooth Rounded Edges Fix):** Corrected a core UI bug where checking/unchecking the "Clip Icon Corners" sub-option failed to apply or remove the rounded mask in real-time. 
- **Dual-Channel Texture Architecture Implemented:** Replaced the unstable runtime `SetMask`/`RemoveMask` calls with an independent **Dual-Channel Frame Layout Matrix**. Addon now initializes a standard square canvas (`frame.signal`) and a separate permanently-masked canvas (`frame.signalMasked`) at startup. Checking the box seamlessly switches visibility vectors, bypassing Blizzard's real-time texture drawing locks completely with 100% reliability.
- **Pruned Frame Refreshes Bloat:** Stripped out legacy loop queries inside `TTP_RefreshAllNameplates` to keep nameplate allocation speeds fast and lightweight.
### 🚀 Added
- **In-Game Automatic Version Synchronization:** Integrated an un-taintable addon communication networking loop (`C_ChatInfo.SendAddOnMessage`). Addon now automatically cross-references version release hashes via party/raid packets whenever entering groups.
- **Outdated Client Chat Notification Alerts:** Configured a smart chat warning parser that alerts players directly in their chat logs if a teammate is detected running a newer, updated codebase file.

---
## - v2.2.0.2 - beta
## - 2026-09-29
### 🚀 Added
- **Dungeon Taint Encapsulation Wrappers:** Implemented a multi-tier protective call (`pcall`) architecture to guard core nameplate evaluation metrics. Automatically catches and handles protected client variables silently in the background, allowing threat calculations to proceed uninterrupted.

### 🔧 Fixed
- **Blizzard `<secret string>` Crash Resolved:** Fixed a fatal crash in Mythic+ keys where the game client handed a protected identity format to text filtering routines. Wrapped both `UnitClassification` and `UnitName` check loops to prevent UI failures on affix mobs or hidden dungeon elements.
- **Blizzard `<secret boolean>` Token Crash Corrected:** Addressed an identity tracking error inside instance group clusters. The target locker loop now safely handles restricted cross-faction PvP pointers or protected NPC flags returned by `UnitIsUnit`.
- **Multi-Variable Assignment Table Glitch Fix:** Resolved an intermittent `bad argument #1 to SetTextColor` error caused by an architectural quirk in Lua's multi-assignment handling. Rewrote the color engine channel pipeline to extract Red, Green, and Blue coordinates (`r`, `g`, `b`) explicitly on their own dedicated compilation tracks.
- **Total Opacity Isolation Tuning:** Refactored the layout matrix renderer to fully separate independent transparencies. Fading your text values or pulling your sliders down to a 0% original native color bypass layer will no longer cross-pollute color masking or cause layout drawing skips.
---
## - v2.2.0.1 - beta
## - 2026-09-29
### 🚀 Added
- **Dynamic Dictionary-Free Icon Solver:** Rewrote texture routing via a direct file-system asset parser. Bypasses Blizzard string protection blocks natively via lowercase forward-slash formatting (`interface/icons/`). It natively handles **any custom or default icon name or pure numeric FileID** in World of Warcraft history without a hardcoded dictionary list.
- **Paginated Global Icon Selection Matrix:** Built an independent **275x300** browsing popup menu directly into the addon. Replaced memory-clogging multi-button allocation schemes with a crash-immune, high-fidelity **5x4 (20 tiles per page)** dynamic paginate grid canvas.
- **Keystroke-by-Keystroke Real-Time Input Syncing:** Re-wired text input streams via the `OnTextChanged` event loop hook. Swaps nameplate icon textures character-by-character **instantly as you type or paste text** without forcing a system `/reload` or pressing Enter.
- **Independent Opacity Sliders Matrix:** Completely uncoupled the indicator layers. The **Threat Indicator Opacity** slider controls text transparency, while the new **Icon Texture Color Opacity** slider isolates the icon asset artwork fading levels independently.
- **Native Color Artwork Bypass Matrix:** Programmed a unique feature rule: dragging the Icon Color Opacity slider down to exactly **0% acts as a Native Color Bypass**. This disables threat tint filters, revealing your chosen icon in its full original artwork colors while keeping threat percentage text dynamically colored.
- **Corner-Clip Custom Sub-Option:** Introduced a dynamic toggle sub-option check button: **"Clip Icon Corners (Smooth Rounded Edges)"** matching localized string parameters across all game clients.
- **Auto-Fit Window Component Width Padding:** Implemented Real-time width padding re-calculators (`GetTextWidth()`) on menu action buttons to dynamically expand or contract containers natively based on active language translations.

### 🔧 Fixed
- **Nameplate Recycle Reference Fault Overhaul:** Resolved an issue where widgets remained hidden on alternating pulled packs by swapping camera tracking addresses for parent independent hardware token markers (`frame.unit ~= unit`).
- **Memory Leak & Duplicate Allocations Elimination:** Repaired a resource drain scenario that disabled drawing elements after consecutive dungeon pulls. Rebuilt the out-of-combat cleanup framework to forcefully clear out existing caches when `PLAYER_REGEN_ENABLED` triggers.
- **Unpacked Color Matrix Crash Corrected:** Fixed fatal script failures (`bad argument #1 to SetVertexColor` & `SetTextColor`) by replacing raw table references with explicit index positional mapping variables (`[1]`, `[2]`, `[3]`).
- **Legacy Clear Button Protection Layers:** Wrapped modern asset configurations within a safe structural layer (`if iconEditBox.SetClearButtonEnabled then`) to cleanly shield older legacy classic expansion engines from throwing execution breaks.
- **Circular Alpha Mask Texture Coords Clash:** Resolved a clipping collision error (`Cannot set tex coords when texture has mask`) by removing all manual bounding box crop updates when hardware smooth edge masks are active.

### 🗑️ Removed
- **Legacy Clutter Pruning:** Stripped out old, bloated background text-bounding box modifiers, bronze bevel frame attachments (`Interface\\Tooltips\\UI-Tooltip-Border`), and style dropdown menus to achieve a pure, high-performance minimalist layout.


---
## - v2.2.0.0 - beta
## - 2026-09-29
### Added
* **Unblockable Vector Channels**: Re-routed themes to use native, hardcoded game sub-textures (`UI-RaidTargetingIcons` and `UI-Minimap-Border`) that are completely immune to modern nameplate graphic injection restrictions.

### Fixed
* **Translucent Square Glitch**: Eliminated the persistent dark square alpha shadows that bled through the backgrounds of round shapes on the modern client baseline.
* **Invisible Theme Fix**: Resolved the transparent rendering error caused by using retail expansion texture keys that do not exist inside the Classic Era client files.

---

##

### Added
* **Display Backdrop Shape Toggle (`TEXT_SHOWBG`)**: Introduced a master checkbox to enable or disable background frames globally.
* **Sub-Tree Option Hierarchy**: Nested the Theme Style selection arrows directly beneath the backdrop checkbox. The sub-tree dynamically grays out and locks whenever backdrops are disabled.

### Fixed
* **Dashboard Layout Realignment**: Rewrote the vertical pixel positioning chain across all sliders and checkboxes, completely fixing the layout overlapping bugs.
* **Real-Time Label Localization**: Fixed an options tracking router bug to allow the "Theme Style Framework" label to translate instantly when switching language packs.

---

##

### Added
* **Threat Indicator Opacity Slider (`TEXT_ALPHA`)**: Added a 10% to 100% transparency trackbar to control the alpha values of fonts and indicator textures simultaneously.
* **Multi-Language Opacity Localization**: Translated the new opacity labels across all 7 supported language arrays (English, Portuguese, Spanish, Italian, French, German, and Japanese).

### Fixed
* **Protected Function Taint Block**: Completely purged `UnitDetailedThreatSituation` calls which returned masked `<secret number>` values that crashed the game client. Replaced with un-taintable, clean integer checks using `UnitThreatSituation`.
* **Vertex Color Packing Fix**: Resolved a fatal client crash by unpacking array values cleanly before forwarding color parameters to `SetVertexColor`.

---

##

### Added
* **Modular Code Overhaul**: Discarded the monolithic layout file in favor of a clean, **7-file single-responsibility directory blueprint** (`Core`, `Utils`, `Themes`, `Engine`, `Options`, `Localization`, and `Manifest`).
* **Modernized Options Registration**: Updated settings registrations to use the Vanilla 2.0 native unified category assignment model (`Settings.RegisterCanvasLayoutCategory`).
* **Asynchronous Deep Linking Delay**: Added a `C_Timer.After(0.01)` execution wrapper to the `/tbf` slash command, allowing the options panel to instantiate safely before opening the addon tab.

### Fixed
* **Interface 16001 Validation**: Bumped the build validation numbers to clear legacy execution penalties on modern Classic clients.
* **Early Loading Loop Crash**: Added an asset safety gate to the `OnUpdate` loop engine to prevent runtime loops from executing before `Core.lua` data namespaces are loaded.
* **Integer ID Redirection Pass**: Corrected a crash where text string category keys were being passed into the game's numeric-only `Settings.OpenToCategory` system.

## - v2.1.2
## - 2026-09-27
### Fixed
- **Mid-Range Percentage Freeze:** Fixed a bug where off-target threat text would get completely stuck at `55%` before jumping instantly to `75%`. Off-target threat now scales fluids across the entire range.
- **Jumpy UI Numbers:** Smoothly dampened the text interpolation algorithm (`0.18` to `0.12`) to ensure that percentage text shifts cleanly digit-by-digit rather than snapping aggressively between values.

### Added
- **Cross-Unit Threat Estimator:** Introduced a matrix scanning function (`EstimateFluidOffTargetThreat`) that reads your party and pet threat status flags to calculate your relative placement on an enemy's aggro table.
- **Logarithmic Progression Ticker:** Implemented an extended 12-second logarithmic timeline curve that dynamically drives background threat text from `15%` up to `72%` safely underneath secure client restrictions.

### Version 2.1.1
## - 2026-09-27
## 🛑 The "Third-Party Combat Pop-up" Fix
### The Problem
* In previous iterations, the addon scanned active nameplates using `UnitAffectingCombat(unit)`. 
* `UnitAffectingCombat` evaluates whether a monster is engaged in combat with **anyone** in the game world.
* If an unrelated background player pulled an enemy nearby, that enemy's combat flag shifted to `true`. The addon mistook this for the player's battle and spawned threat widgets over the enemy nameplate, even if the player and their party were standing completely idle out of combat.

### The Architectural Solution
We implemented a strict multi-layered **Group Engagement Filter Engine** to block unauthorized nameplate tracking.

1. **Direct Threat Verification:** Before drawing a widget, the addon checks `UnitThreatSituation("player", unit)`. If this returns `nil`, you have no footprint on that mob's threat table, and it is safely ignored.
2. **Pet Threat Verification:** Added a fallback check for class pets (`UnitThreatSituation("pet", unit)`), ensuring active hunter/warlock targets populate widgets cleanly.
3. **Cross-Group Target Checking:** If you are running inside a Group or Raid framework, the addon scans the target tokens (`unit.."target"`). If the mob is actively attacking an interface group index token (`party1` to `party4`, or `raid1` to `raid40`), it is instantly flagged as part of your team's pull.
4. **Ticker Value Reset Handling:** When widgets are recycled via `RecycleSignalWidget`, their dynamic simulation counters (`frame.combatStartTime` and `frame.currentThreatDisplayValue`) are hard-wiped. This prevents memory residue from leaking old percentage animations onto brand-new monster frames.

### Version 2.1.0
## - 2026-09-27
### Fixed
- **Dungeon Taint Shutdowns:** Resolved a fatal crash caused by the engine attempting to index tables with encrypted/secret unit GUID keys inside instances (`secret keys` error). The audio system now safely indexes nameplate tokens instead.
- **String Conversion Taints:** Fixed a high-frequency layout loop freeze caused by performing `string.find` operations on protected unit identity parameters inside dungeons. Text evaluation features are now cleanly sandboxed inside `pcall` execution gates.
- **Secret Boolean Blockers:** Wrapped conditional target branching evaluations (`UnitIsUnit`) in protective exception isolation frameworks to capture secret boolean responses from restricted nameplates, preventing interface shutdowns.
- **White Texture Glitch:** Patched a bug where off-target display metrics would fail to initialize color parameters, defaulting widgets to a blank white texture layout.
- **Mid-Wipe Addon Hiding:** Fixed a bug where a pet dying or party members releasing spirit mid-fight would trigger the "Solo Hiding" condition, disabling the addon during active encounters. The framework now securely forces widgets to stay alive until combat drops completely.

### Added
- **Visual Dynamic Threat Ticker:** Implemented a smooth frame-by-frame interpolation system that dynamically moves threat text up or down between `0%` and `100%` on background adds using safe time duration anchors, completely bypassing client data blackouts for off-targets.
- **Reactive Engine Events:** Added instant hooks for `NAME_PLATE_UNIT_ADDED` and `NAME_PLATE_UNIT_REMOVED`, ensuring nameplates render the visual light layout immediately upon mob activation without waiting for the next CPU timer cycle.

### Optimized
- **Global Table Lookups:** Cauterized global namespace clutter by caching all primary client widget APIs locally, significantly lowering frame processing delays.
- **Zero-Allocation Array Loops:** Swapped out heavy table layout iterators (`ipairs`) for high-performance numeric index loops (`for i = 1, #nameplates do`) to eliminate micro-stutters during massive AoE trash pulls.
- **Options Panel Performance:** Optimized slider math loops inside `ThreatBuddyForeverOptions.lua` to clamp floating-point updates, stopping interface memory leaks.


### Version 2.0.0
* **Added Tank/DPS Auto-Inversion:** Colors adapt automatically based on active Tank stances/forms.
* **Added Cyan Neon Taunt Alert:** Visual and textual warning when a mob is spottet/taunted.
* **Added Per-Character Profiles:** Independent database tracking for separate characters.
* **Added Spanish & Italian Support:** Extended localization dictionaries (`esES` / `itIT`).
* **Fixed Interface Overlap:** Added a native Vertical Scrollbar and redesigned slider label layouts.
* **Fixed Classic API Compatibility:** Re-engineered aura scanning to prevent engine crashes on WoW Forever clients.