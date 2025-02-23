# Home Asset Management

![Flutter](https://img.shields.io/badge/Flutter-3.29.0-blue.svg)

A Flutter application designed for efficient home asset management. This app helps users track, organize, and manage their household items and assets with a modern, user-friendly interface.

## Deployed Version

The deployed version can be found at https://home-asset-management.web.app/

## Platform Support

- iOS
- Android
- Web

## Features

- **Home Tracking:** Easily add, edit, and remove homes
- **Home Asset Tracking:** Easily add, edit, and remove home assets
- **Search:** Quickly find assets using the search page
- **Local Storage:** Secure offline storage using Hive database
- **Clean Architecture:** Modular and maintainable codebase structure

### Supported Asset Types

The application currently supports tracking of the following home assets:

- Refrigerators
- Air Conditioners
- HVAC Systems
- Solar Panels
- EV Chargers
- Batteries

## Getting Started

To run Home Asset Management, ensure that your Flutter environment is set to version 3.29.0.

### Prerequisites

- Flutter Version 3.29.0
- IDE with Flutter support (preferred VS Code)

### Installation

1. **Clone the Repository:**

```bash
git clone https://github.com/marchesotti/home_asset_management.git
```

2. **Navigate to the Project Directory:**

```bash
cd home_asset_management
```

3. **Install Dependencies:**

```bash
flutter pub get
```

4. **Generate Required Files:**

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Running the App

- **Using Flutter directly:**

```bash
flutter run
```

## Project Structure

The project follows Clean Architecture principles, separating concerns into distinct layers and modules:

```
lib/
├── core/             # Core functionality and shared components
│   ├── controller/   # Base controller implementations
│   ├── di/           # Dependency injection setup
│   ├── entities/     # Core business entities
│   ├── errors/       # Error handling and exceptions
│   ├── helpers/      # Utility functions and helper classes
│   ├── use-case/     # Base use case implementations
│   ├── widgets/      # Shared UI components
│   └── consts/       # Constants and configuration
│
├── modules/          # Feature modules
│   ├── homes/        # Home management feature
│   └── assets/       # Asset management feature
│
└── main.dart         # Application entry point
```

### Core Layer

- **controller/**: Contains base controller classes that handle business logic and state management
- **di/**: Manages dependency injection using GetIt, ensuring proper service locator setup
- **entities/**: Defines core business objects and data structures
- **errors/**: Centralizes error handling and custom exceptions
- **helpers/**: Houses utility functions and helper classes for common operations
- **use-case/**: Implements base use case patterns following clean architecture
- **widgets/**: Provides reusable UI components shared across modules
- **consts/**: Stores application-wide constants and configuration

### Feature Modules

Each feature module follows a similar structure adhering to clean architecture principles:

- **homes/**: Manages home-related functionality

  - Data layer (repositories, models)
  - Domain layer (use cases, entities)
  - Presentation layer (screens, widgets)

- **assets/**: Handles asset management features
  - Data layer (repositories, models)
  - Domain layer (use cases, entities)
  - Presentation layer (screens, widgets)

This architecture ensures:

- Clear separation of concerns
- High maintainability and testability
- Scalable codebase structure
- Easy feature additions and modifications

## Technical Decisions

### State Management and Architecture

- **Clean Architecture**: Adopted to ensure separation of concerns and maintainability
  - Clear boundaries between data, domain, and presentation layers
  - Independent business logic that's framework-agnostic
  - Easier to test and modify individual components

### Data Persistence

- **Hive Database**: Chosen for local storage due to its:
  - High performance with native implementation
  - Simple key-value storage perfect for asset data
  - Zero dependencies on platform-specific code
  - Ability to work offline seamlessly

### Dependency Management

- **GetIt**: Selected for dependency injection because it:
  - Provides simple and flexible service location
  - Supports lazy singleton initialization
  - Facilitates easier testing through dependency injection
  - Reduces boilerplate compared to other DI solutions

### Error Handling

- **Dartz**: Implemented for functional error handling
  - Uses Either type for better error management
  - Provides clear distinction between success and failure cases

## CI/CD Pipeline

The CI/CD pipeline is implemented using GitHub Actions, providing automated testing and building. Each push or pull request to the main branch triggers the following sequence of workflows:

### Static Analysis (`analyze.yml`)

This workflow ensures code quality standards are maintained:

1. **Environment Setup**

   - Uses Ubuntu latest runner
   - Sets up Flutter 3.29.0

2. **Dependency Management**

   - Runs `flutter pub get`
   - Validates dependency tree
   - Ensures all dependencies are resolved

3. **Code Analysis**
   - Executes `flutter analyze`
   - Checks for potential errors
   - Enforces style guidelines
   - Validates code against Flutter best practices

### Testing Pipeline (`test.yml`)

Comprehensive testing workflow to maintain code reliability:

1. **Test Environment Preparation**

   - Configures test environment
   - Sets up Flutter test framework
   - Prepares test dependencies

2. **Test Execution**

   - Runs unit tests for business logic
   - Executes widget tests for UI components
   - Performs integration tests for feature workflows

### Build Process (`build.yml`)

Multi-platform build workflow:

1. **Android Build**

   - Platform: Ubuntu Latest
   - Steps:
     ```
     - Setup Flutter
     - Build release APK
     ```

2. **iOS Build**

   - Platform: macOS Latest
   - Steps:
     ```
     - Setup Flutter
     - Build iOS
     ```

3. **Web Build**

   - Platform: Ubuntu Latest
   - Steps:
     ```
     - Setup Flutter
     - Build web
     - Save the build artifact
     ```

4. **Deploy**
   - Platform: Ubuntu Latest
   - Steps:
     ```
     - Get the build artifact
     - Deploy to Firebase Hosting
     ```

## Testing

Run the test suite using:

```bash
flutter test
```

For test coverage:

```bash
flutter test --coverage
lcov --remove coverage/lcov.info 'lib/**/*.g.dart' -o coverage/lcov.info
lcov --list coverage/lcov.info
```
