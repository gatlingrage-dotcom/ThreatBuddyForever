# 🚥 ThreatBuddyForever

**ThreatBuddyForever** is a smart, ultra-lightweight multi-target threat monitoring addon designed specifically for the **WoW Forever / Classic (Vanilla)** game client. 

Instead of forcing you to stare at complex numerical tables, this addon attaches a **dynamic, glowing circular traffic light** directly to the right side of floating enemy health bars (**Nameplates**). This allows you to manage threat across massive AoE pulls with a single split-second glance.

---

## 🚀 Key Features

* **Smart Role Inversion (Tank vs. DPS/Healer):** Automatically detects your active stance, form, or buff. 
  * *As a DPS/Healer:* Green means you are safe; Red means you have agro (danger!).
  * *As a Tank:* Inverts automatically! Green means you have secure agro (your goal); Red means you lost it to an ally.
* **Cyan Neon Taunt Alert:** Turns the signal into a **Neon Cyan Blue** circle and displays **`TAUNT`** (`FIXADO`) while a mob is mechanically hard-locked by a taunt ability.
* **Emergency Audio Warnings:** Triggers a clean, high-priority system sound (**Raid Warning**) the exact millisecond a secondary mob rips threat onto you.
* **Focused Target Highlight:** Dynamically enlarges the widget of your current target (customizable size multiplier) with thick text outling for easier tracking in large packs.
* **Trivial Unit Filter:** Automatically hides widgets on enemy Totems and minor pets to keep your screen clean and lag-free.
* **Per-Character Profiles:** Choose to save your options account-wide or keep scales, offsets, and lag controls unique to each character.
* **7-Language Support:** Localized at runtime for **English, Portuguese, Spanish, Italian, French, German, and Japanese**.

---

## 🛠️ Configuration Panel

Type `/tbf` in chat to open the customized interface within WoW's native options window. It features a **glowing, code-animated neon Logo**, a **Vertical Scrollbar** for smooth navigation, and the following controls:

* **Interactive Checkboxes:** Toggle Neon Glow, Hide While Solo, Allow Solo with Pet, Audio Alerts (with a dedicated `Play` button for testing), Target Highlight, Totem Filter, and Per-Character Profiles.
* **Sliders (Stacked Vertically):**
  * *General Size (Scale):* Controls the baseline size of widgets (0.5x to 2.0x).
  * *Target Highlight Size:* Customizes your active target's widget size (1.0x to 2.5x).
  * *Lateral Distance:* Adjusts how many pixels to the right the widget sits away from the nameplate.
  * *Update Frequency (Lag Control):* Slide down to `0.02s` for real-time precision (Zero Lag), or up to `0.30s` to maximize CPU performance on older systems.

---

## ⌨️ Slash Commands

Manage your addon at any time using these chat commands:
* `/tbf` — Opens the scrollable options panel.
* `/tbf test` — Toggles a static test widget at 50% threat in the center of your screen to safely adjust scales.
* `/tbf scale [0.5-2.5]` — Swiftly alters the baseline widget scale via chat.
* `/tbf reset` — Emergency reset command that re-centers the test frame back to default screen coordinates.

---

## 📦 Installation

1. Download the repository as a `.zip` file.
2. Extract it into your World of Warcraft directory:
   `World of Warcraft\_classic_\Interface\AddOns\`
3. Ensure the folder is named exactly **`ThreatBuddyForever`**.
4. Restart your game and enjoy smooth threat tracking!

---

## 📝 Changelog
# Changelog - ThreatBuddyForever


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
