# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is **Illogical Impulse**, a QuickShell configuration for Hyprland providing a complete desktop shell with bars, sidebars, notifications, widgets, and more. QuickShell is a Qt/QML-based Wayland shell compositor.

- **Primary Language**: QML (QtQuick)
- **Secondary**: Python scripts, Bash scripts
- **Framework**: QuickShell with Qt 6

## Running & Development

No build step required - QuickShell loads QML directly:
```bash
qs -c ii                              # Run the shell
qs -c ii ipc call panelFamily cycle   # Switch between ii/waffle themes
```

### QML Formatting
```bash
qmlformat -i <file.qml>  # Format file in place
```
Configuration in `.qmlformat.ini`: 4-space indent, 110 max column width, unix newlines.

### Translation Management
```bash
cd translations/tools
./manage-translations.sh status       # Show translation status
./manage-translations.sh extract      # Extract translatable strings
./manage-translations.sh update       # Update translation files
./manage-translations.sh clean        # Remove unused keys
./manage-translations.sh sync         # Synchronize across languages
```

## Architecture

### Entry Points
- `shell.qml` - Main shell entry, loads panel families and services
- `settings.qml` - Standalone settings application

### Key Directories
```
modules/
├── common/           # Shared components
│   ├── Config.qml    # Configuration singleton (JSON persistence)
│   ├── Appearance.qml # Material Design 3 colors, animations, typography
│   ├── functions/    # Utility functions (FileUtils, ColorUtils, etc.)
│   └── widgets/      # 95+ reusable UI components
├── ii/               # Main "Illogical Impulse" theme panels
└── waffle/           # Windows-style alternative theme

services/             # Singleton services (Audio, Battery, Notifications, etc.)
panelFamilies/        # Theme loaders (ii, waffle)
scripts/              # Python/Bash utilities (color generation, image processing)
translations/         # i18n JSON files (12 languages)
```

### Panel Family System
Two UI themes available, switchable at runtime:
- **ii** (Illogical Impulse): Modern Material Design 3 style
- **waffle**: Windows-style alternative

### Configuration System
User config stored at `$XDG_CONFIG_HOME/quickshell/config.json`, managed via `Config.qml` singleton.

Access nested values: `Config.options.bar.showBackground`
Set nested values: `Config.setNestedValue("bar.showBackground", true)`

### State Management
- `GlobalStates` - UI state (barOpen, sidebarRightOpen, screenLocked, etc.)
- `Config` - User configuration
- `Appearance` - Material Design 3 theming
- Services in `services/` - Hardware and system state singletons

## QML Patterns

### Standard Imports
```qml
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland
import qs.modules.common
import qs.modules.common.functions as CF
import qs.modules.common.widgets
import qs.services
```

### Singletons
```qml
pragma Singleton
pragma ComponentBehavior: Bound

Singleton {
    id: root
    // ...
}
```

### Lazy Loading (for panels)
```qml
LazyLoader {
    active: Config.ready && GlobalStates.barOpen
    component: PanelWindow { ... }
}
```

### Per-Monitor Components
```qml
Variants {
    model: Quickshell.screens
    LazyLoader {
        required property ShellScreen modelData
        component: PanelWindow { screen: modelData }
    }
}
```

### Safe Property Access
```qml
Config?.options?.appearance?.transparency ?? 0
```

### Translations
```qml
Translation.tr("Some text")
Translation.tr("Hello, %1!").arg(name)
```
For dynamic strings that shouldn't be auto-cleaned, add `/*keep*/` in the translation JSON value.

## Code Style

### QML
- 4-space indentation, never tabs
- Max 110 characters per line
- Use optional chaining (`?.`) for safe property access
- Type annotations preferred: `function foo(x: int): string { }`
- Console logging: `console.log("[ModuleName] Message")`

### Python Scripts
- Type hints required
- Snake_case for functions and files

### Bash Scripts
- UPPER_SNAKE_CASE for variables
- snake_case for functions

## Key Services

| Service | Purpose |
|---------|---------|
| `Audio` | Volume control, mute state |
| `Battery` | Battery level, charging state |
| `Brightness` | Screen brightness |
| `Notifications` | Notification daemon |
| `HyprlandData` | Compositor state, workspaces, windows |
| `Ai` | AI assistant with OpenAI/Gemini/Mistral support |
| `Translation` | i18n system |
| `Wallpapers` | Wallpaper management |
| `Cliphist` | Clipboard history |

## Material Design 3 Theming

Colors accessed via `Appearance.m3colors.*`:
- `primary`, `onPrimary`, `primaryContainer`, `onPrimaryContainer`
- `secondary`, `tertiary`, `error`, `surface`, `background`
- Full Material You color scheme from wallpaper

Animations via `Appearance.animation.*`:
- `elementMoveFast`, `elementMoveEnter`, `menuDecel`
