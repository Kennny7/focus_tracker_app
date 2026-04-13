# 

# ```markdown

# \# Focus Tracker App

# 

# > \*\*A cross-platform desktop focus timer that punishes distractions.\*\*  

# > \*No internet, no database, no backend – pure local Flutter.\*

# 

# !\[GitHub release (latest by date)](https://img.shields.io/github/v/release/Kennny7/focus-tracker-app)

# !\[License](https://img.shields.io/github/license/Kennny7/focus-tracker-app)

# !\[Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS-blue)

# 

# \---

# 

# \## Table of Contents

# 

# \- \[Overview](#overview)

# \- \[Key Features](#key-features)

# \- \[Project Structure](#project-structure)

# \- \[Technologies Used](#technologies-used)

# \- \[Workflow Diagram](#workflow-diagram)

# \- \[Prerequisites](#prerequisites)

# \- \[Installation \& First Run](#installation--first-run)

# \- \[Windows](#windows)

# \- \[macOS](#macos)

# \- \[Customisation Guide](#customisation-guide)

# \- \[Change the App Icon](#change-the-app-icon)

# \- \[Replace the Punishment Sound](#replace-the-punishment-sound)

# \- \[Edit the Insults List](#edit-the-insults-list)

# \- \[Building Standalone Executables](#building-standalone-executables)

# \- \[Build .exe (Windows)](#build-exe-windows)

# \- \[Build .app (macOS)](#build-app-macos)

# \- \[How It Works – Deep Dive](#how-it-works--deep-dive)

# \- \[Troubleshooting](#troubleshooting)

# \- \[License](#license)

# \- \[Contributing](#contributing)

# \- \[Roadmap](#roadmap)

# 

# \---

# 

# \## Overview

# 

# The Focus Tracker App is a \*\*distraction-punishing productivity tool\*\* designed for people who struggle to stay focused on their computer. When you minimise the app, switch to another window, or let the timer run out, the app “punishes” you with:

# 

# \- A loud, customisable sound  

# \- A random insult from a built-in list  

# \- \*(Optional)\* resetting the timer to zero  

# 

# It runs entirely offline, stores all data locally, and works identically on Windows and macOS.

# 

# \---

# 

# \## Key Features

# 

# | Feature                     | Description                                                                 |

# |----------------------------|-----------------------------------------------------------------------------|

# | Pomodoro timer             | Focus / short break / long break cycles, fully adjustable.                 |

# | Focus monitoring           | Detects when the app loses focus or is minimised.                          |

# | Punishment system          | Sound + insult popup + timer reset (toggleable “Strict Mode”).             |

# | Grace period (3 sec)       | Gives you time to return before punishment triggers.                       |

# | Statistics dashboard       | Tracks daily, weekly, total focus time and number of punishments.          |

# | Achievements \& streaks     | Unlock badges for consecutive distraction-free sessions.                   |

# | Custom punishment sound    | Pick any MP3/WAV file from your disk.                                      |

# | CSV export                 | Export all focus sessions to a CSV file.                                   |

# | Keyboard shortcuts         | Space = start/pause, Esc = reset.                                          |

# | System tray support        | App stays in tray when closed – left-click to restore, right-click menu.   |

# | Dark / light mode          | Switchable, with persistent preference.                                    |

# | Window opacity control     | Make the window semi-transparent.                                          |

# 

# \---

# 

# \## Project Structure

# 

# <details>

# <summary>Click to expand/collapse the full tree</summary>

# 

# ```

# 

# focus\_tracker\_app/

# ├── assets/

# │   ├── icon.ico

# │   ├── icon.png

# │   └── sounds/

# │       └── punishment.mp3

# ├── lib/

# │   ├── main.dart

# │   ├── models/

# │   │   └── focus\_session.dart

# │   ├── screens/

# │   │   ├── home\_screen.dart

# │   │   └── stats\_screen.dart

# │   ├── services/

# │   │   ├── timer\_service.dart

# │   │   ├── focus\_monitor.dart

# │   │   ├── punishment\_service.dart

# │   │   ├── audio\_service.dart

# │   │   ├── stats\_service.dart

# │   │   └── achievement\_service.dart

# │   ├── utils/

# │   │   ├── constants.dart

# │   │   └── keyboard\_shortcuts.dart

# │   └── widgets/

# │       ├── timer\_display.dart

# │       ├── control\_buttons.dart

# │       ├── duration\_selector.dart

# │       ├── settings\_panel.dart

# │       ├── stats\_dashboard.dart

# │       └── achievement\_badge.dart

# ├── pubspec.yaml

# └── README.md

# 

# ````

# 

# </details>

# 

# \---

# 

# \## Technologies Used

# 

# | Technology                    | Purpose                                                |

# |-----------------------------|--------------------------------------------------------|

# | Flutter (Dart)              | Cross-platform UI framework                            |

# | window\_manager              | Window events, focus detection, opacity                |

# | tray\_manager                | System tray integration                               |

# | audioplayers                | Play sound                                             |

# | shared\_preferences          | Local storage                                          |

# | file\_picker                 | Select custom files                                    |

# | path\_provider               | File system paths                                      |

# | csv                         | Export data                                            |

# | flutter\_local\_notifications | Optional notifications                                 |

# 

# All packages are fully offline. No tracking. No API calls.

# 

# \---

# 

# \## Workflow Diagram

# 

# ```mermaid

# graph TD

#   A\[User starts timer] --> B{App in focus?}

#   B -- Yes --> C\[Timer counts down]

#   C --> D{Time == 0?}

#   D -- Yes --> E\[Record successful session]

#   E --> F\[Switch to break mode]

#   D -- No --> B

#   B -- No --> G\[Start 3s grace period]

#   G --> H{Focus regained within 3s?}

#   H -- Yes --> B

#   H -- No --> I\[Punishment triggered]

#   I --> J{Strict Mode?}

#   J -- Yes --> K\[Play sound + insult + reset]

#   J -- No --> L\[Insult only]

#   K --> M\[Record punished session]

#   L --> M

#   M --> N\[Update stats]

#   N --> B

# ````

# 

# \---

# 

# \## Prerequisites

# 

# \* Flutter SDK

# \* Git (optional)

# 

# \*\*Windows\*\*

# 

# \* Visual Studio 2022 (C++ workload)

# 

# \*\*macOS\*\*

# 

# \* Xcode

# \* CocoaPods

# 

# Enable desktop:

# 

# ```bash

# flutter config --enable-windows-desktop

# flutter config --enable-macos-desktop

# ```

# 

# \---

# 

# \## Installation \& First Run

# 

# \### Windows

# 

# ```bash

# flutter pub get

# flutter run -d windows

# ```

# 

# \### macOS

# 

# ```bash

# flutter pub get

# flutter run -d macos

# ```

# 

# \---

# 

# \## Customisation Guide

# 

# \### Change the App Icon

# 

# Replace:

# 

# \* `assets/icon.ico`

# \* `assets/icon.png`

# 

# Rebuild afterward.

# 

# \---

# 

# \### Replace the Punishment Sound

# 

# Replace:

# 

# ```

# assets/sounds/punishment.mp3

# ```

# 

# Or use in-app selector.

# 

# \---

# 

# \### Edit the Insults List

# 

# File:

# 

# ```

# lib/utils/constants.dart

# ```

# 

# Example:

# 

# ```dart

# static const List<String> insults = \[

# "Your custom insult here",

# ];

# ```

# 

# \---

# 

# \## Building Standalone Executables

# 

# \### Windows

# 

# ```bash

# flutter build windows --release

# ```

# 

# Output:

# 

# ```

# build/windows/runner/Release/

# ```

# 

# \---

# 

# \### macOS

# 

# ```bash

# flutter build macos --release

# ```

# 

# Output:

# 

# ```

# build/macos/Build/Products/Release/

# ```

# 

# \---

# 

# \## How It Works – Deep Dive

# 

# \### Focus Detection

# 

# Uses `window\_manager` to detect:

# 

# \* Focus loss

# \* Minimize events

# 

# Triggers grace period → punishment.

# 

# \---

# 

# \### Punishment Execution

# 

# \* Random insult

# \* Popup dialog

# \* Optional sound + reset

# 

# \---

# 

# \### Statistics \& Achievements

# 

# Stored locally using `SharedPreferences`.

# 

# \---

# 

# \### System Tray

# 

# \* Left click → restore

# \* Right click → menu

# \* Close button → minimize to tray

# 

# \---

# 

# \## Troubleshooting

# 

# | Issue             | Fix                  |

# | ----------------- | -------------------- |

# | No tray icon      | `flutter clean`      |

# | Sound not working | Check file exists    |

# | Keys not working  | Focus window         |

# | Build fails       | Run `flutter doctor` |

# 

# \---

# 

# \## License

# 

# MIT License.

# 

# \---

# 

# \## Contributing

# 

# 1\. Fork

# 2\. Branch

# 3\. Commit

# 4\. Push

# 5\. PR

# 

# \---

# 

# \## Roadmap

# 

# \* \[ ] Idle detection

# \* \[ ] Webcam tracking

# \* \[ ] JSON insult import

# \* \[ ] Cloud sync (optional)

# \* \[ ] Advanced punishments

# 

# \---

# 

# \## Support

# 

# Open an issue:

# \[https://github.com/Kennny7/focus\_tracker\_app/issues](https://github.com/Kennny7/focus\_tracker\_app/issues)

# 

# \---

# 

# \*\*Stay focused — or pay the price.\*\*

