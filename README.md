# 🚥 ThreatBuddyForever

**ThreatBuddyForever** is a smart, ultra-lightweight, and multi-expansion compatible threat monitoring addon designed for **World of Warcraft (Classic, Cataclysm, and Retail)**.

Instead of forcing you to stare at complex numerical tables, this addon attaches a **clean, high-fidelity threat indicator** directly to the right side of floating enemy health bars (**Nameplates**). This allows you to manage threat across massive combat pulls with a single split-second glance.

---

## 🚀 Key Features

* **Automated Group Role Synchronization:** Natively queries Blizzard's secure group assignment API (`UnitGroupRolesAssigned`). The addon automatically tracks your active dungeon/raid role profile and specializations, instantly swapping color profiles without needing manual clicks:
  * **As a DPS/Healer:** **Green** means you are safe; **Crimson Red** means you have pulled aggro (danger!).
  * **As a Tank:** Inverts automatically! **Green** means you have secure aggro (your goal); **Crimson Red** means a teammate ripped it off you.
* **Dictionary-Free Global Icon Selector:** Features an advanced, lightweight text-to-asset translation system. Type **any raw icon text name** (e.g., `spell_deathknight_mindfreeze`, `ability_evoker_dragonrage2_blue`) or entry **pure numeric Asset ID**, and the engine will instantly map it, completely bypassing Blizzard's directory locks.
* **Independent Dual Opacity Sliders:** Opacity layers operate completely separately. The **Threat Indicator Opacity** slider controls number transparency, while the **Icon Texture Color Opacity** slider isolates the artwork fading levels.
* **Native Artwork Bypass Matrix:** Pulling the Icon Opacity slider down to exactly **0%** switches the addon into Native Art Mode. This disables threat color tints and displays your chosen icon in its full original artwork colors while keeping the overlay percentage numbers dynamically colored.
* **Corner-Clip Custom Option:** Toggle a new **"Clip Icon Corners (Smooth Rounded Edges)"** checkbox to apply a high-fidelity alpha portrait mask, cleanly rounding off square icon corners into smooth tokens.
* **Cyan Neon Taunt Alert:** Turns the signal into a **Neon Cyan Blue** indicator and displays **`TAUNT`** while an enemy is mechanically hard-locked by a taunt ability.
* **Dungeon Secret String & Taint Protection:** Features encapsulated protected calls (`pcall`) built directly into the scanner loops. This renders the addon completely immune to modern UI taint crashes caused by cross-faction PvP, Mythic+ affixes, or protected NPC names/classification tokens.
* **In-Game Automatic Version Synchronization:** Uses addon communication network channels (`C_ChatInfo.SendAddOnMessage`) to cross-reference version hashes via party/raid packets. Automatically alerts players in chat if a teammate is running a newer codebase release.
* **7-Language Support:** Localized at runtime for **English, Portuguese, Spanish, Italian, French, German, and Japanese**.

---

## 🛠️ Configuration Panel

Type `/tbf` in chat to open the customized interface within WoW's native options window. It features a **glowing neon Logo**, an **auto-fitting multi-language layout** to prevent clipped translation labels, and a **Vertical Scrollbar** for smooth navigation:

* **Interactive Controls:** Toggle Neon Glow, Hide While Solo, Allow Solo with Pet, Audio Alerts (with a dedicated `Play` button for testing), Target Highlight, Totem Filter, and **Clip Icon Corners**.
* **Global Paginated Icon Gallery Dialog:** Clicking the **Browse...** button opens an enlarged **275x300** custom popout grid next to your configuration window. It houses pages of iconic combat abilities inside a dynamic **5x4 (20 tiles per page)** layout, changing textures character-by-character **instantly as you type or paste text**.
* **Stacked Sliders Configuration:**
  * *Master Size (Scale):* Controls the baseline size of widgets (0.5x to 2.0x).
  * *Target Highlight Size:* Customizes your active target's widget size (1.0x to 2.5x).
  * *Lateral Distance:* Adjusts how many pixels to the right the widget sits away from the nameplate.
  * *Update Frequency (Lag Control):* Slide down to `0.02s` for real-time precision (Zero Lag), or up to `0.30s` to maximize CPU performance.
  * *Threat Indicator Opacity:* Controls text percentage number fade levels (10% to 100%).
  * *Icon Texture Color Opacity:* Independently controls the overlay transparency of the icon artwork (0% to 100%).

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
   `World of Warcraft\_retail_\Interface\AddOns\` (or `_classic_`, `_classic_era_`)
3. Ensure the folder is named exactly **`ThreatBuddyForever`**.
4. Restart your game and enjoy clean, automated threat tracking!
