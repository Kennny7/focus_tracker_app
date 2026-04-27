# Focus Tracker App

> **A cross-platform desktop focus timer that punishes distractions.**  
> *No internet, no database, no backend – pure local Flutter.*

![GitHub release (latest by date)](https://img.shields.io/github/v/release/Kennny7/focus_tracker_app)
![License](https://img.shields.io/github/license/Kennny7/focus_tracker_app)
![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS-blue)
![Stars](https://img.shields.io/github/stars/Kennny7/focus_tracker_app?style=social)
![Issues](https://img.shields.io/github/issues/Kennny7/focus_tracker_app)

---

## Table of Contents

- [Overview](#overview)
- [Screenshots](#screenshots)
- [Key Features](#key-features)
- [Project Structure](#project-structure)
- [Technologies Used](#technologies-used)
- [Workflow Diagram](#workflow-diagram)
- [Prerequisites](#prerequisites)
- [Installation & First Run](#installation--first-run)
  - [Windows](#windows)
  - [macOS](#macos)
- [Customisation Guide](#customisation-guide)
- [Building Standalone Executables](#building-standalone-executables)
- [How It Works – Deep Dive](#how-it-works--deep-dive)
- [Troubleshooting](#troubleshooting)
- [License](#license)
- [Contributing](#contributing)
- [Roadmap](#roadmap)
- [Support](#support)

---

## Overview

The Focus Tracker App is a **distraction-punishing productivity tool** designed for people who struggle to stay focused on their computer.

When you:
- Minimise the app
- Switch to another window
- Let the timer run out

The app punishes you with:
- 🔊 Loud sound  
- 💬 Random insult  
- 🔁 Optional timer reset  

**Fully offline. Fully local. Zero tracking.**

---

## Screenshots

> Add screenshots here after first build

```

/assets/screenshots/home.png
/assets/screenshots/stats.png

```

---

## Key Features

| Feature | Description |
|--------|-------------|
| Pomodoro timer | Custom focus/break cycles |
| Focus monitoring | Detects minimize & focus loss |
| Punishment system | Sound + insult + reset |
| Grace period | 3-second recovery window |
| Statistics dashboard | Track productivity |
| Achievements | Streak-based rewards |
| Custom sound | User-selected punishment audio |
| CSV export | Export session logs |
| Shortcuts | Space / Esc controls |
| System tray | Background operation |
| Themes | Dark / Light |
| Opacity | Adjustable transparency |

---

## Project Structure

<details>
<summary>Click to expand</summary>

```

focus_tracker_app/
├── assets/
│ ├── icon.ico
│ ├── icon.png
│ └── sounds/
│ └── punishment.mp3
├── lib/
│ ├── main.dart
│ ├── models/
│ │ └── focus_session.dart
│ ├── screens/
│ │ ├── home_screen.dart
│ │ └── stats_screen.dart
│ ├── services/
│ │ ├── timer_service.dart
│ │ ├── focus_monitor.dart
│ │ ├── punishment_service.dart
│ │ ├── audio_service.dart
│ │ ├── stats_service.dart
│ │ └── achievement_service.dart
│ ├── utils/
│ │ ├── constants.dart
│ │ └── keyboard_shortcuts.dart
│ └── widgets/
│ ├── timer_display.dart
│ ├── control_buttons.dart
│ ├── duration_selector.dart
│ ├── settings_panel.dart
│ ├── stats_dashboard.dart
│ └── achievement_badge.dart
├── pubspec.yaml
├── LICENSE.md
└── README.md

```
</details>

---

## Technologies Used

| Technology 					| Purpose                                 |
|-------------------------------|-----------------------------------------|
| Flutter (Dart) 				| Cross-platform UI framework    		  |
| window_manager 				| Window events, focus detection, opacity |
| tray_manager 					| System tray integration 				  |
| audioplayers 					| Play sound 							  |
| shared_preferences 			| Local storage 						  |
| file_picker 					| Select custom files 					  |
| path_provider 				| File system paths 					  |
| csv 							| Export data 							  |
| flutter_local_notifications 	| Optional notifications 				  |

All packages are fully offline. No tracking. No API calls.

---

## Workflow Diagram

```mermaid
graph TD
  A[Start Timer] --> B{In Focus?}
  B -- Yes --> C[Countdown]
  C --> D{Finished?}
  D -- Yes --> E[Success]
  D -- No --> B
  B -- No --> G[Grace Period]
  G --> H{Recovered?}
  H -- Yes --> B
  H -- No --> I[Punishment]
````

---

## Prerequisites

* Flutter SDK
* Git

### Windows

* Visual Studio 2022 (C++)

### macOS

* Xcode
* CocoaPods

```bash
flutter config --enable-windows-desktop
flutter config --enable-macos-desktop
```

---

## Installation & First Run

### Windows

```bash
flutter pub get
flutter run -d windows
```

### macOS

```bash
flutter pub get
flutter run -d macos
```

---

## Installation (Desktop)

---

<details>
<summary><strong>Windows</strong> (click to expand)</summary>

<br>

### Windows

1. Download the latest `FocusTracker-windows.zip` from the Releases page  
2. Extract the ZIP file  
3. Open the extracted folder  
4. Run `FocusTracker.exe`  

> If Windows shows a security warning:  
> - Click **More info**  
> - Click **Run anyway**

</details>

---

<details>
<summary><strong>macOS</strong> (click to expand)</summary>

<br>

### macOS

1. Download the latest `FocusTracker-macos.zip` from the Releases page  
2. Extract the ZIP file  
3. Drag `FocusTracker.app` to your Applications folder (recommended)  
4. Right-click the app and select **Open**  
5. Click **Open** in the security prompt  

> This step is required because the app is not signed with an Apple Developer certificate.

</details>

---

<details>
<summary><strong>macOS Troubleshooting</strong> (click to expand)</summary>

<br>

### macOS (Troubleshooting)

If you see an error like:  
> "FocusTracker.app is damaged or can’t be opened"

Run the following command in Terminal:

```bash
xattr -cr /Applications/FocusTracker.app
```

Then try opening the app again.

</details>

---
## Customisation Guide

### App Icon

Replace:

* assets/icon.ico
* assets/icon.png

### Sound

Replace:

```
assets/sounds/punishment.mp3
```

### Insults

Edit:

```
lib/utils/constants.dart
```

---

## Building Standalone Executables

### Windows

```bash
flutter build windows --release
```

### macOS

```bash
flutter build macos --release
```

---

## How It Works – Deep Dive

### Focus Detection

Uses window_manager for:

* Focus loss
* Minimize detection

### Punishment

* Random insult
* Dialog popup
* Optional sound + reset

### Storage

* Local via SharedPreferences

### Tray

* Runs in background
* Click to restore

---

## Troubleshooting

| Issue        | Fix            |
| ------------ | -------------- |
| No tray icon | flutter clean  |
| No sound     | Check file     |
| Keys fail    | Focus window   |
| Build error  | flutter doctor |

---

## License

MIT License

---

## Contributing

1. Fork
2. Create branch
3. Commit
4. Push
5. Pull Request

---

## Roadmap

* [ ] Idle detection
* [ ] Webcam tracking
* [ ] JSON imports
* [ ] Cloud sync
* [ ] Advanced punishments

---

## Support

[https://github.com/Kennny7/focus_tracker_app/issues](https://github.com/Kennny7/focus_tracker_app/issues)

---

**Stay focused — or pay the price.**


