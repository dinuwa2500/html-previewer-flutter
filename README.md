# ⚡ Flutter Online HTML Viewer & Previewer

<p align="center">
  <img src="web/icons/Icon-192.png" width="96" height="96" alt="HTML Viewer Logo" />
</p>

<p align="center">
  <strong>A production-grade, responsive Flutter application for writing, debugging, and rendering HTML, CSS, and JavaScript in real-time.</strong>
</p>

<p align="center">
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.44+-02569B?logo=flutter&logoColor=white" alt="Flutter"></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-3.12+-0175C2?logo=dart&logoColor=white" alt="Dart"></a>
  <a href="https://github.com/flutter/packages/tree/main/packages/webview_flutter"><img src="https://img.shields.io/badge/WebView-Native_Engine-green" alt="WebView"></a>
  <a href="#"><img src="https://img.shields.io/badge/Material_3-Modern_UI-6366F1" alt="Material 3"></a>
  <a href="#"><img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT"></a>
</p>

---

## 🌟 Overview

The **Flutter Online HTML Viewer** provides an in-app web development playground that mirrors online code previewers. Instead of displaying HTML as plain text, it renders full web pages inside a native WebView engine with full JavaScript execution, CSS styles, device simulation, and an integrated developer console.

---

## ✨ Features

### 💻 Rich Code Editor
- **Real-Time Syntax Highlighting**: Tokenized highlighting for HTML tags, attributes, string values, comments, CSS units, and JavaScript keywords in both Dark and Light themes.
- **Synchronized Line Numbers**: Gutter dynamically scales with font size and scrolls in lock-step with the editor.
- **Undo / Redo History**: Dual-stack history with debounced state snapshots.
- **Find & Replace**: Search with live match counter, match highlighting, next/prev navigation, and single or bulk replace.
- **HTML Beautifier**: Built-in 2-space indentation formatter.
- **Auto-Save**: Changes persist seamlessly to local storage.
- **Customizable**: Adjustable font size, word wrap toggle, and line number visibility.

### 🌐 Native WebView Rendering Engine
- Renders standard **HTML5**, **CSS3**, and **JavaScript**.
- Supports interactive DOM manipulations, animations, buttons, form submissions, and external assets.
- Isolates untrusted HTML safely inside the WebView sandbox.

### 📱 Responsive Viewport Simulation
- **Mobile (375px)**: Realistic phone frame with notch, speaker slot, and drop shadow.
- **Tablet (768px)**: Centered tablet viewport container.
- **Desktop (100%)**: Edge-to-edge desktop preview.
- **Zoom Controls**: Zoom in, zoom out, and 100% reset (50% – 200%).
- **Controls Toolbar**: Refresh (↻) and Fullscreen preview (↗).

### 🐞 Developer Console Panel
- Intercepts `console.log`, `console.warn`, `console.error`, and `window.onerror`.
- Displays real-time error badge counters on the toolbar.
- Filter logs by: **All**, **Errors (❌)**, **Warnings (⚠️)**, and **Info (ℹ️)**.
- Safe execution: Script errors inside user HTML never crash the Flutter application.

### 🎨 8 Pre-Built Interactive Templates
1. **Basic HTML**: Responsive starter template with interactive counter.
2. **Login Page**: Glassmorphic auth card with animated gradient, form validation, and show/hide password.
3. **Portfolio**: Dark mode developer portfolio with tech pills, projects grid, and contact modal.
4. **Landing Page**: SaaS landing page with gradient typography, metrics stats, and CTAs.
5. **Card UI**: E-commerce card with color picker switcher and interactive add-to-cart animation.
6. **Calculator**: Interactive working JavaScript grid calculator with arithmetic evaluation.
7. **JavaScript Demo**: Live DOM counter, color generator, dynamic todo list adder, and timer.
8. **CSS Animation**: Hypnotic 3D glowing sphere with pulsing rings and speed slider.

### 📁 History & File Management
- **Local Storage**: Auto-saves active code and maintains recent project history.
- **Relative Timestamps**: Displays timestamps as *"Today"*, *"Yesterday"*, or formatted dates.
- **Import**: Open `.html`, `.htm`, or `.txt` files directly into the editor.
- **Export**: Save HTML snippets directly as `index.html`.
- **Clipboard**: Quick one-tap copy with visual snackbar feedback.

### 📐 Adaptive Layout
- **Desktop & Tablet (≥ 900px)**: Side-by-side dual-pane split screen with Navigation Rail.
- **Mobile (< 900px)**: Tabbed layout (`HTML Code` ↔ `Preview`) with Bottom Navigation Bar.

---

## 🏗️ Architecture

The project is structured using a **Feature-First Architecture**:

```text
lib/
├── main.dart                                    # MultiProvider setup & Storage initialization
├── app/
│   ├── app.dart                                 # Responsive Shell (Dual-pane / Tabbed)
│   └── theme.dart                               # Material 3 light & dark themes
│
├── features/
│   ├── editor/                                  # Code editor feature
│   │   ├── presentation/
│   │   │   ├── editor_controller.dart           # Undo/redo, find/replace & auto-save state
│   │   │   └── editor_view.dart                 # Editor UI with status bar
│   │   └── widgets/
│   │       ├── html_syntax_controller.dart      # Syntax highlighting controller
│   │       ├── line_number_gutter.dart          # Synchronized line numbers
│   │       ├── editor_toolbar.dart              # Action toolbar
│   │       └── find_replace_bar.dart            # Search & replace bar
│   │
│   ├── preview/                                 # WebView preview feature
│   │   ├── presentation/
│   │   │   ├── preview_controller.dart          # WebView state, zoom & console logs
│   │   │   └── preview_view.dart                # Native WebView container
│   │   └── widgets/
│   │       ├── preview_toolbar.dart             # Zoom, device switcher & reload
│   │       ├── device_frame_container.dart      # Viewport simulator (Mobile/Tablet/Desktop)
│   │       └── console_panel.dart               # JavaScript console drawer
│   │
│   ├── templates/                               # Pre-built templates
│   │   └── presentation/
│   │       └── templates_view.dart              # Template gallery
│   │
│   ├── history/                                 # Saved projects
│   │   ├── presentation/
│   │   │   ├── history_controller.dart          # Project history provider
│   │   │   └── history_view.dart                # Recent projects list
│   │
│   └── settings/                                # Preferences
│       └── presentation/
│           ├── settings_controller.dart         # Preferences provider
│           └── settings_view.dart               # Settings screen
│
├── core/
│   ├── services/
│   │   ├── html_beautifier.dart                 # HTML code formatter
│   │   ├── html_export_service.dart             # Import, export & clipboard
│   │   └── console_bridge.dart                  # JavaScript console bridge
│   ├── storage/
│   │   └── storage_service.dart                 # SharedPreferences persistence
│   └── utils/
│       └── date_formatter.dart                  # Relative date utility
│
└── models/
    ├── html_template.dart                       # Template model & registry
    ├── history_item.dart                        # History item model
    ├── console_log.dart                         # Console log model & levels
    └── editor_settings.dart                     # User settings model
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (v3.19 or later recommended)
- [Dart SDK](https://dart.dev/get-dart) (v3.3 or later)

### Installation & Run

1. **Clone the repository:**
   ```bash
   git clone https://github.com/YOUR_USERNAME/flutter-html-viewer.git
   cd flutter-html-viewer
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   ```bash
   # Run on connected device or emulator
   flutter run

   # Or specify a target platform:
   flutter run -d chrome       # Web
   flutter run -d windows      # Windows Desktop
   flutter run -d android      # Android Device/Emulator
   flutter run -d ios          # iOS Simulator
   ```

---

## 🧪 Testing & Verification

Run the full automated test suite:

```bash
# Run unit & widget tests
flutter test

# Run static analysis
flutter analyze
```

---

## 📦 Dependencies

| Package | Purpose |
| :--- | :--- |
| [`provider`](https://pub.dev/packages/provider) | Reactive state management |
| [`webview_flutter`](https://pub.dev/packages/webview_flutter) | Cross-platform WebView rendering engine |
| [`shared_preferences`](https://pub.dev/packages/shared_preferences) | Local persistence for history, code, and settings |
| [`file_picker`](https://pub.dev/packages/file_picker) | File import and export dialogues |

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
