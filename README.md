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

### Version 2.0.0 (Ultimate Edition)
* **Added Tank/DPS Auto-Inversion:** Colors adapt automatically based on active Tank stances/forms.
* **Added Cyan Neon Taunt Alert:** Visual and textual warning when a mob is spottet/taunted.
* **Added Per-Character Profiles:** Independent database tracking for separate characters.
* **Added Spanish & Italian Support:** Extended localization dictionaries (`esES` / `itIT`).
* **Fixed Interface Overlap:** Added a native Vertical Scrollbar and redesigned slider label layouts.
* **Fixed Classic API Compatibility:** Re-engineered aura scanning to prevent engine crashes on WoW Forever clients.
