# AGENTS.md - QuickShell Illogical Impulse Dotfiles

## Overview

This is an end4 dotfiles project for QuickShell (QtQuick/QML-based Wayland shell on Hyprland).
Primary languages: QML (560 files), Python (11 files), Bash (19 files).

## Build/Test Commands

No traditional build system - this is a configuration project.

**Setup:**
```bash
/home/pico/Documents/dots-hyprland/setup
```

**Diagnostics:**
```bash
/home/pico/Documents/dots-hyprland/diagnose
```

**Python scripts use virtual environment:**
```bash
source $ILLOGICAL_IMPULSE_VIRTUAL_ENV/bin/activate
```

## Code Style Guidelines

### QML (QtQuick)

**File naming:** PascalCase.qml (e.g., RippleButton.qml, MaterialSymbol.qml)
**Indentation:** 4 spaces
**Singletons:** PascalCase (e.g., Appearance, GlobalStates, Icons)
**Components:** camelCase (e.g., rippleAnim, notifTimer)
**Properties/Functions:** camelCase (e.g., buttonText, iconSize, startRipple)

**Import patterns:**
```qml
// Group related imports, Qt modules first
import QtQuick
import QtQuick.Window
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

import "modules/common"
import "services"
import qs.modules.common.widgets
import qs.modules.common.functions as CF
```

**Type annotations (preferred):**
```qml
function getWeatherIcon(code: string): string { }
property real screenZoom: 1
property bool barOpen: true
property list<string> families: ["ii", "waffle"]
```

**Error handling with optional chaining:**
```qml
const result = Config?.options?.setting ?? defaultValue
property real transparency: Config?.options?.appearance?.transparency.enable ? autoBackgroundTransparency : 0
```

**Console logging with context:**
```qml
console.log("[Notifications] File not found, creating new file.")
```

**Signal/Event patterns:**
```qml
signal initDone();
signal notify(notification: var);
onCompleted: { MaterialThemeLoader.reapplyTheme() }
onPressed: (event) => { if(event.button === Qt.RightButton) { root.altAction(event) } }
```

**Component definitions:**
```qml
component RippleAnim: NumberAnimation {
    duration: rippleDuration
    easing.type: Appearance?.animation.elementMoveEnter.type
}

pragma Singleton
pragma ComponentBehavior: Bound
Singleton { id: root; function myFunction(): string { } }
```

### Python

**File naming:** snake_case.py (e.g., generate_colors_material.py, get_keybinds.py)
**Functions:** snake_case (e.g., calculate_optimal_size, read_content)
**Classes:** PascalCase (e.g., KeyBinding, Section)
**Variables:** snake_case (e.g., darkmode, color_list)
**Indentation:** 4 spaces

**Import patterns:**
```python
import argparse
import re
import os
from os.path import expandvars as os_expandvars
from typing import Dict, List
from PIL import Image
from materialyoucolor.quantize import QuantizeCelebi
```

**Type hints required:**
```python
def calculate_optimal_size(width: int, height: int, bitmap_size: int) -> (int, int):
def read_content(path: str) -> str:
```

**Error handling:**
```python
if (not os.access(os.path.expanduser(os.path.expandvars(path)), os.R_OK)):
    return "error"
try:
    image = Image.open(args.path)
except Exception as e:
    print(f"Error processing image: {e}")
    return 1
```

### Bash Scripts

**Variables:** UPPER_SNAKE_CASE (e.g., CONFIG_DIR, CACHE_DIR)
**Functions:** snake_case (e.g., apply_term, apply_qt)
**Shebang:** Use proper shell interpreter

**Error handling:**
```bash
read_content() {
    if [[ ! -f "$1" ]]; then
        echo "error"
        return 1
    fi
    cat "$1"
}
```

**Pattern matching:**
```bash
case $(whoami) in
  root) echo "Not to be executed with sudo"; exit 1 ;;
esac
```

## Project Structure

- `modules/common/` - Shared components (panels, widgets, functions, utils, models)
- `modules/ii/` - Illogical Impulse theme modules (bar, sidebars, lock, background)
- `modules/waffle/` - Waffle/Windows-style alternative theme
- `services/` - Singleton services (Notifications, Audio, Network, Ai, etc.)
- `scripts/` - Shell and Python utilities (colors, hyprland, images, thumbnails, keyring, ai, kvantum)
- `translations/` - i18n files (12 languages)
- `shell.qml` - Main entry point

## Architecture Patterns

- **Singletons** for shared state and services
- **Component-based** UI with reusable widgets
- **Translation support:** Use `Translation.tr("text")` for user-facing strings
- **String templates:** `` `${path}/${file}` ``
- **Spread operator:** `["bash", "-c", `echo '${text}' > '${file}'`]; Process { command: ["pidof", ...programs] }`
- **Arrow functions:** `onPressed: (event) => { }`

## Dependencies

- QtQuick/QuickShell framework
- Material Design 3
- Python: materialyoucolor, Pillow
- Hyprland compositor

## Notes

- QML files use 4-space indentation consistently
- Optional chaining (`?.`) with nullish coalescing (`??`) is standard for safe property access
- Type annotations are preferred in QML but optional
- Python uses standard type hints
- All Python scripts should be executable with proper shebangs
