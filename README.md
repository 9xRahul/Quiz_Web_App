# Quiz App

A beautiful, interactive Flutter Quiz Application.

## Features
- Multiple choice questions
- Explanations for answers
- Score tracking
- Clean, modern UI

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

- Flutter SDK (latest version)
- Dart SDK
- An IDE (VS Code, Android Studio, etc.)

### Installation

1. Clone the repo:
   ```sh
   git clone https://github.com/your_username/quiz_app.git
   ```
2. Navigate to the project directory:
   ```sh
   cd quiz_app
   ```
3. Install dependencies:
   ```sh
   flutter pub get
   ```
4. Run the app:
   ```sh
   flutter run
   ```

## Project Structure
- `lib/main.dart` - Entry point of the application
- `lib/bloc/` - contains bussines logic componets and states for the app
- `lib/repositories/` - handles ofline and online data featching for repos
- `lib/widgets/` - Contains UI components (e.g., question cards, option buttons)
- `lib/services/` - Contains backend or logic services (e.g., shared preferences)

## Dependencies
- `shared_preferences` - For local storage

## License
Distributed under the MIT License.
