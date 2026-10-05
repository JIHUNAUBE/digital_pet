# Digital Pet

A Flutter-based digital pet application developed as a team project.  
The app allows users to interact with a virtual pet by feeding, playing, and resetting its status.

## Team Members

- Jihun Kim
- C Nguyen

## Features

- Displays a digital pet with a custom pet image
- Tracks the pet's happiness level
- Tracks the pet's hunger level
- Feed button to update the pet's status
- Play button to interact with the pet
- Reset button to restore the initial state
- Dynamic pet messages based on its current condition
- Visual progress indicators for happiness and hunger
- Pet appearance/size changes based on its status

## Technologies Used

- Flutter
- Dart
- Git
- GitHub

## Project Structure

- `lib/main.dart` - Main application UI and digital pet logic
- `assets/pet.png` - Digital pet image
- `test/widget_test.dart` - Flutter widget tests
- `pubspec.yaml` - Flutter dependencies and asset configuration

## How to Run

Make sure Flutter is installed and configured.

Clone the repository:

```bash
git clone https://github.com/JIHUNAUBE/digital_pet.git
```

Navigate to the project directory:

```bash
cd digital_pet
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

To run the web version specifically:

```bash
flutter run -d chrome
```

## Testing

Run the widget tests with:

```bash
flutter test
```

The widget test verifies that the main Digital Pet interface loads correctly, including:

- Digital Pet title
- Pet name (Pip)
- Happiness status
- Hunger status
- Feed button
- Play button
- Reset button

## Code Analysis

Run Flutter's static analyzer with:

```bash
flutter analyze
```

The final project passes Flutter analysis with no issues.

## GitHub Collaboration

The project was developed using separate Git branches and GitHub pull requests.

Team changes were reviewed and integrated into the `main` branch. Git was used throughout development to track changes and coordinate contributions.

## Asset Attribution

The pet image used in this project was added as `assets/pet.png` for the Digital Pet interface.

## Current Pet

**Name:** Pip

Initial status:

- Happiness: 50
- Hunger: 50

Users can interact with Pip using the Feed, Play, and Reset buttons.