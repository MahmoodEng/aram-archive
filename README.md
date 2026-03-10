# Aram Archive

A Flutter application for managing Boxes and Books with PDF support, using SQLite for local offline storage.

## Features

- 📦 **Boxes** — Create, edit, and delete named boxes to organize your books
- 📖 **Books** — Add books with name, page count, and optional PDF attachment
- ❤️ **Favorites** — Mark books as favorites and view them in one place
- 🔍 **Search** — Search across both box names and book names
- 📄 **PDF Viewer** — Attach and open PDF files for each book
- 💾 **Offline** — All data stored locally using SQLite (no internet required)

---

## 🖥️ How to Open and Run in VS Code

Follow these steps to get the app running on your device or emulator directly inside VS Code.

### Step 1 — Install Flutter SDK

1. Go to <https://docs.flutter.dev/get-started/install> and follow the guide for your OS (Windows / macOS / Linux).
2. After installation, open a terminal and verify:

   ```bash
   flutter doctor
   ```

   Fix any issues reported by `flutter doctor` before continuing (especially the Android SDK and emulator setup).

### Step 2 — Install VS Code Extensions

1. Open **VS Code**.
2. Press `Ctrl+Shift+X` (or `Cmd+Shift+X` on Mac) to open the Extensions panel.
3. Search for and install:
   - **Flutter** (publisher: Dart Code) — also installs the Dart extension automatically.

   > Tip: When you open this project, VS Code may show a pop-up *"Do you want to install the recommended extensions?"* — click **Install** to add them automatically (they are listed in `.vscode/extensions.json`).

### Step 3 — Clone / Open the Project

If you have already cloned the repository:

```bash
git clone https://github.com/MahmoodEng/aram-archive.git
cd aram-archive
```

Then open the folder in VS Code:

```bash
code .
```

Or use **File → Open Folder…** inside VS Code and select the `aram-archive` folder.

### Step 4 — Install Dependencies

Open the integrated terminal in VS Code (`Ctrl+` `` ` ``) and run:

```bash
flutter pub get
```

This downloads all packages listed in `pubspec.yaml`.

### Step 5 — Start a Device or Emulator

You need a running target to display the app. Choose one:

| Option | How to start |
|---|---|
| **Android Emulator** | Open Android Studio → Device Manager → ▶ Start an AVD, *or* run `flutter emulators --launch <id>` |
| **Physical Android phone** | Enable *Developer Options* → *USB Debugging* on the phone, then plug it in via USB |
| **Chrome (web preview)** | No setup needed — Flutter supports web out of the box |

After starting your device, check VS Code's status bar at the bottom. Click the device picker (it shows *"No Device"* or a device name) and select your emulator/phone.

### Step 6 — Run the App

**Option A — Using the Run button (easiest)**

1. Open `lib/main.dart` in the editor.
2. Press **F5** (or go to **Run → Start Debugging**).
3. Choose **"Aram Archive (debug)"** from the launch configuration dropdown.
4. The app builds and opens on your selected device. 🎉

**Option B — Using the terminal**

```bash
flutter run
```

Add `--release` for a production build, or `-d chrome` to run in the browser.

### Step 7 — Hot Reload & Hot Restart

While the app is running:

| Action | Shortcut |
|---|---|
| **Hot Reload** (keeps state) | `r` in terminal, or `Ctrl+F5` in VS Code |
| **Hot Restart** (resets state) | `R` in terminal, or the restart button in the debug toolbar |
| **Stop** | `q` in terminal, or the red stop button |

---

## ⚡ Quick Local Setup (TL;DR)

```bash
# 1. Clone and enter the project
git clone https://github.com/MahmoodEng/aram-archive.git
cd aram-archive

# 2. Install dependencies
flutter pub get

# 3. Run on a connected device / emulator
flutter run

# 4. Run tests
flutter test
```

---

## 🛠️ Troubleshooting Local Setup

### `flutter` command not found
Flutter is not on your PATH.  
→ Follow the [Flutter install guide](https://docs.flutter.dev/get-started/install) for your OS and make sure the `flutter/bin` directory is added to your PATH.

### `flutter doctor` shows issues
Run `flutter doctor -v` for detailed output and fix each ❌ item before running the app.  
Common fixes:

| Problem | Fix |
|---|---|
| Android toolchain missing | Install [Android Studio](https://developer.android.com/studio) and accept SDK licences with `flutter doctor --android-licenses` |
| No connected devices | Start an Android emulator via Android Studio → Device Manager, or connect a physical phone with USB debugging enabled |
| CocoaPods not installed (macOS) | Run `sudo gem install cocoapods` |

### `flutter pub get` fails
- Check your internet connection.
- If behind a proxy, set `http_proxy` / `https_proxy` environment variables.
- Delete `.dart_tool/` and `pubspec.lock`, then retry.

### App builds but crashes immediately
Run in verbose mode to see the full error:
```bash
flutter run --verbose
```

### "Waiting for another flutter command to release the startup lock"
Another Flutter process is hanging. Kill it:
```bash
# macOS / Linux
killall dart

# Windows (PowerShell)
Stop-Process -Name dart
```

### Hot reload not working
- Make sure you saved the file (`Ctrl+S`).
- Hot reload does **not** apply changes to `main()`, global variables, or `initState()` — use **hot restart** (`R`) for those.

---

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   ├── box_model.dart           # Box data model
│   └── book_model.dart          # Book data model
├── database/
│   └── database_helper.dart     # SQLite CRUD operations
├── providers/
│   ├── box_provider.dart        # Box state management
│   └── book_provider.dart       # Book state management
├── pages/
│   ├── home_page.dart           # Home: list of boxes
│   ├── box_detail_page.dart     # Box detail: list of books
│   ├── search_page.dart         # Search boxes and books
│   └── favorites_page.dart      # Favorite books list
└── widgets/
    ├── box_card.dart            # Box card widget
    └── book_card.dart           # Book card widget
```

## Dependencies

| Package | Purpose |
|---|---|
| `sqflite` | Local SQLite database |
| `path_provider` | File system paths |
| `file_picker` | PDF file selection |
| `open_file` | Open PDF files |
| `provider` | State management |
| `intl` | Date formatting |
