# Aram Archive

A Flutter application for managing Boxes and Books with PDF support, using SQLite for local offline storage.

## Features

- 📦 **Boxes** — Create, edit, and delete named boxes to organize your books
- 📖 **Books** — Add books with name, page count, and optional PDF attachment
- ❤️ **Favorites** — Mark books as favorites and view them in one place
- 🔍 **Search** — Search across both box names and book names
- 📄 **PDF Viewer** — Attach and open PDF files for each book
- 💾 **Offline** — All data stored locally using SQLite (no internet required)

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (>=3.10.0)
- Android Studio or VS Code with Flutter extension

### Installation

```bash
flutter pub get
flutter run
```

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
