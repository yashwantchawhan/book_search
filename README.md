# book_search
A Flutter-based mobile application that allows users to search, view, and bookmark books.
It also provides a dashboard to display device and sensor information and control the device flashlight.

### Core Features
- **Home Screen**: View all bookmarked books stored offline.
- **Search Screen**: Search for new books using the OpenLibrary API.
- **Book Details**: Displays book information & Allows saving or deleting the book as a bookmark.
- **Dashboard Screen**: 
    - Displays device information (battery level, device name, OS version) via a platform channel.
    - Displays gyroscope sensor information.
    - Allows turning the flashlight on/off from the sensor screen.
- **Responsive Design**: Works on both iOS and Android devices

### Screenshots


https://github.com/user-attachments/assets/f5242dfd-00e6-4ba7-8a32-9df3928fa010



### Technical Features
- **State Management**: Clean state management with flutter_bloc
- **Image Caching**: Efficient image loading and caching
- **Error Handling**: Graceful fallback for errors (e.g., no results, API errors).
- **Offline Support**: Bookmarks are stored in a local SQLite database via sqflite.
- **Deep Link Support**:  Supports deep links for /, /search, /details, /dashboard routes — making the navigation loosely coupled and scalable.
- **Testing**: Unit tests, widget tests, and integration tests

### Directory Structure
```
lib/
├── main.dart                      # Entry point of the application

├── application/                   # App shell & initialization
│   └── app.dart                   # Application class: initializes & starts the app

├── di/                            # Dependency Injection setup
│   ├── app_setup.dart             # Registers all shared services & singletons
│   └── dependency_provider.dart   # Provides dependencies through Provider

├── navigation/                    # App navigation & deeplink handling
│   ├── app_deeplink_handler.dart  # Handles deeplink navigation
│   ├── app_router.dart            # Routes to screens based on deeplink
│   └── nav_bar_screen.dart        # BottomNavigationBar setup

packages/                          # Modularized feature & library code

├── features/                     # Feature modules (user-facing functionality)
│   ├── book_details/             # Book Details Screen
│   │   ├── data/                 # Repository & data source for details
│   │   ├── domain/               # Domain models / use cases (if any)
│   │   ├── presentation/         # Presentation layer
│   │   │   ├── bloc/             # BLoC, Events, States
│   │   │   └── widgets/          # UI widgets for Book Details
│
│   ├── dashboard/                # Dashboard Screen
│   │   ├── data/                 # Repositories & platform data
│   │   ├── domain/               # Domain logic (e.g., services)
│   │   └── presentation/         # UI for sensors, device info, flashlight
│   │       ├── bloc/             # BLoC for dashboard
│   │       └── widgets/          # Dashboard widgets
│
│   ├── home/                     # Home Screen
│   │   ├── data/                 # Bookmarks repository
│   │   ├── domain/               # Domain models / services
│   │   └── presentation/         # Bookmarks UI
│   │       ├── bloc/             # Bookmarks BLoC
│   │       └── widgets/          # Widgets for Home screen
│
│   └── search/                  # Search Screen
│       ├── data/                # Search repository
│       ├── domain/              # Domain models / use cases
│       └── presentation/        # Search UI
│           ├── bloc/            # Search BLoC, Events, States
│           └── widgets/         # Search screen widgets

├── libraries/                    # Shared libraries & utilities
│   ├── core/                     # App core services & utilities
│   │   ├── local_db/             # Local database (SQLite helpers, DAOs)
│   │   ├── navigation/           # Common navigation utilities
│   │   └── remote/               # API service clients
│
│   └── design/                    # Design system
│       ├── design_system/         # Shared UI components
       

├── plugin/                        # Native platform channels
│   └── device_information/        # Communicates with Android/iOS native code
│       └── (e.g., method_channel)

tests/                             # Unit, widget, and integration tests
├── features/
│   ├── book_details/
│   │   └── presentation/
│   │       ├── bloc_test.dart
│   │       └── widget_test.dart
│   ├── home/
│   │   └── presentation/
│   │       ├── bloc_test.dart
│   │       └── widget_test.dart
│   ├── search/
│   │   └── presentation/
│   │       ├── bloc_test.dart
│   │       └── widget_test.dart
│   ├── dashboard/
│   │   └── presentation/
│   │       ├── bloc_test.dart
│   │       └── widget_test.dart


```

## Platform-Specific Setup

### Android
- **Minimum SDK:** API 21 (Android 5.0 Lollipop)
- **Target SDK:** API 34 (Android 14)
- **Compile SDK:** API 34 or higher

### iOS
- **Minimum iOS version:** 12.0

## Installation & Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd book_search
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

## Testing approach
- Unit Tests: For models, repositories, services.
- Widget Tests: For screens and key UI components.
- Integration Tests: For DB & repository interaction.

## Third-Party Libraries Used
| Library                      | Why?                                 |
|------------------------------|--------------------------------------|
| `sqflite` / `sqflite_common_ffi` | Local database (SQLite)           |
| `mocktail`                   | Mocking in unit & widget tests      |
| `bloc_test`                  | Bloc/Cubit testing                  |
| `provider` (optional)        | Lightweight state management        |
| `cached_network_image`       | Caching images efficiently          |

## Design Decisions & Challenges
- Why modular architecture?
    - Promotes separation of concerns.
    - Easy to maintain, test & scale.
    - Clean boundary between features & layers.
- Why Deep Links?
    - Decouples navigation from widget tree.
    - Makes features work independently.
    - Improves flexibility & future scalability.
