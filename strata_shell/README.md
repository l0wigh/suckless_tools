# Strata Shell 🪨✨

**Strata Shell** is a full-featured, modern, and fluid desktop shell and sidebar designed for the **Fluorite** window manager on **X11**, powered by **Quickshell** (Qt 6 / QML).

Inspired by Fluorite's mineral and geometric aesthetics, Strata Shell provides a native, modular, and fully customizable desktop experience:
- **Unibody & Frame Mode Design**: Full desktop framing bars (`TopBar`, `BottomBar`, `RightBar`, and `Bar`) seamlessly joined with smooth concave corner fillets and harmonized corner radii.
- **Centralized Configuration Manager (`Config.qml`)**: Global control of bar dimensions (`leftBarWidth`, `topBarHeight`, `bottomBarHeight`, `rightBarWidth`), frame mode toggling (`enableFrameBars`), global animation duration (`animDuration`), and dynamic corner radius linking (`cornerRadius` & `popoutCornerRadius`).
- **Reactive & Geometric OSD (`Osd.qml`)**: On-Screen Display anchored flush to the top bar for Volume, Brightness, Wi-Fi status, MPRIS Media tracks, and Battery events. Features top-to-bottom sliding animations (`Translate { y }`) preserving concave corner fillets and rounded bottom edges, with global timing tied to `Config.animDuration`.
- **Pure Geometric Popout Animations (`Popout.qml`)**: Fluid popouts using horizontal width expansion and shrinking transitions (`card.width`) tied to `Config.animDuration`, maintaining right corner radii completely visible without opacity fading or X11 edge clipping.
- **Smart OSD Suppression**: Automatic suppression of redundant volume OSD popups when adjusting volume directly from bar modules or popout sliders (`Sys.suppressVolumeOSD()`).
- **Minimalist Vertical Popouts (`VolumePopup.qml` & `BatteryPopup.qml`)**: Sleek vertical cards (72x200px) matching the OSD aesthetic, featuring refined 10px progress/volume bars, percentage-only headers, and smooth handleless direct-drag volume controls.
- **Vertical Bar Modules (`BarModule.qml`)**: Vertical stacking (`Column`) of module icons and labels (volume/battery percentages), maintaining fixed bar width (34px) while expanding vertically.
- **Window Manager & Scratchpad Tracking**: Real-time tracking of Fluorite's 5 layouts (Cascade, DWM, Centered, Stacked, Scrolling) and active scratchpads.
- **Full Control Centers**: Modular popouts for Wi-Fi, Volume/Microphone, Battery, MPRIS Media, Calendar, Quick settings, System Tray, and Notifications.

> [!WARNING]
> **Strata Shell is entirely vibe coded.** Expect spontaneous architectural decisions, experimental patterns, and unique features. Tweak, hack, and enjoy at your own vibe!

---

## 🛠️ Building Quickshell for X11

Quickshell is a Qt 6 / QML framework. To use it on X11 (with or without Wayland), build it from source with X11 support enabled.

### Build Dependencies (Gentoo / Arch / Debian)

- **Compiler**: C++20 (`gcc >= 12` or `clang >= 15`)
- **Build system**: `cmake >= 3.20`, `pkg-config`, `ninja` (recommended)
- **Qt 6** (`>= 6.6`):
  - `qtbase` (with GUI, Widgets, OpenGL support)
  - `qtdeclarative` (QML and private headers)
  - `qtsvg`
  - `qtshadertools`
- **System libraries**:
  - `libdrm`
  - `spirv-tools`
  - `cli11`
  - `jemalloc` (or disable via CMake)
  - X11 libraries: `libX11`, `libxcb`, `xcb-util-*`

### Build Instructions

```bash
git clone https://github.com/outfoxxed/quickshell.git
cd quickshell

# CMake configuration with X11 support
cmake -B build -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DX11=ON \
    -DWAYLAND=OFF \
    -DCRASH_HANDLER=OFF

# Compilation and installation
cmake --build build -j$(nproc)
sudo cmake --install build
```

---

## 🧩 Tools & Runtime Dependencies

Strata Shell interfaces with several Unix tools to display and control the environment:

### 1. Window Manager & IPC
- **Fluorite**: Dynamic X11 window manager.
- **`polybar-msg` (IPC bridge)**: Script placed in `~/.local/bin/polybar-msg` (with priority in `$PATH`). Since Fluorite emits `#fluorite_layout.hook.%d` actions, this bridge intercepts signals to update root X11 window properties:
  - `FLUORITE_LAYOUT`: active layout index.
  - `FLUORITE_SCRATCHPADS`: active scratchpads list and state (`[k]` = visible, `k` = hidden).
- **`xprop`**: inspects X11 EWMH and Fluorite window atoms (`_NET_CURRENT_DESKTOP`, `_NET_CLIENT_LIST`, `FLUORITE_*`).
- **`xdotool`**: sends keyboard actions (e.g. `Super+r` to cycle layouts or switch workspaces).

### 2. Audio & Media
- **`pactl` / `pamixer`**: master volume control, mute toggling, and microphone management.
- **`playerctl`**: MPRIS-compatible media player detection and control (Spotify, Firefox, etc.).

### 3. Brightness & Power
- **`brightnessctl` / `udevadm`**: backlight brightness reading, smooth adjustment, and kernel event-driven OSD updates.
- **Power supply & battery**: percentage and charging state monitoring with smart OSD notifications (charger toggles, low threshold ≤ 30%, optimal charge limit ≥ 80%).

### 4. Network & Wireless
- **`wpa_cli` / `wpa_supplicant`**: Wi-Fi access point scanning, connection management, floating password authentication modal, and real-time connection/disconnection OSD notifications.
- **`rfkill` / `bluetoothctl`**: radio state event monitoring (airplane mode / soft blocks) and Bluetooth quick toggles.

### 5. Security, Lock & Sleep
- **`xsecurelock`**: secure X11 screen locker.
- **`elogind-inhibit`**: sleep lock coordination with the session daemon.
- **`xset` (DPMS)**: immediate display blanking upon locking.
- **`~/tools/suckless_tools/scripts/lock.sh`**: combined script triggered by keyboard shortcut (`Mod4+Shift+e`) and sleep button.

---

## 🚀 Installation & Launch

1. **Create the symbolic link in your user configuration**:
```bash
ln -sfn ~/tools/suckless_tools/strata_shell ~/.config/quickshell
```

2. **Autostart in your `~/.xinitrc`**:
```bash
# Launch Quickshell in the background before the window manager
quickshell &

# Launch Fluorite
exec Fluorite
```

3. **Hot Reloading**:
Quickshell automatically reloads QML files upon each save without requiring a full restart.
