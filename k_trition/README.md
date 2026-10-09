# K-Trition

Group Flutter project: a nutrition tracker for Kalamazoo College students.

## Current state

This is the starting point, not the completed MVP. It includes a Material 3 app, a simple home screen showing the planned features, feature folders, a smoke test, and GitHub CI. No meal tracking, calculations, water logging, goal setting, editing/deleting, or database is implemented yet.

Our eight MVP requirements and proposed data design are in [docs/MVP.md](docs/MVP.md).

## Run

Install Flutter and its Dart SDK, then from this repository:

```sh
flutter pub get
flutter run -d chrome
```

In the original class workspace, Flutter is in the sibling SDK folder, so you can use:

```sh
../flutter/bin/flutter pub get
../flutter/bin/flutter run -d chrome
```

For a phone or simulator, run `flutter devices` and then `flutter run -d DEVICE_ID`. Android/iOS require their platform toolchains.

## Project structure

- `lib/main.dart`: entry point
- `lib/app/`: app theme and setup
- `lib/features/dashboard/`: starter home screen and future daily progress
- `lib/features/foods/`: future food catalog
- `lib/features/meals/`: future meal logging and calculations
- `lib/features/water/`: future water tracking
- `lib/features/goals/`: future goal settings
- `lib/data/`: future persistent local database layer
- `docs/`: MVP scope and proposed design
- `test/`: tests

## Group workflow

1. Pick one unchecked MVP feature and create a feature branch.
2. Discuss its data/UI design before implementation.
3. Implement a small change, run checks, and open a pull request.
4. Have another group member review it before merging.

Keep generated builds, credentials, and personal nutrition data out of Git.

## Check the project

```sh
flutter analyze
flutter test
```

The GitHub Actions workflow runs these checks for pushes and pull requests.

## Put it on GitHub

Create an empty GitHub repository without an initial README, license, or .gitignore. From **this k_trition folder**, run:

```sh
git init
git add .
git commit -m "Start K-Trition Flutter MVP"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
git push -u origin main
```

Replace the URL with your repository's URL. Upload only this project folder, not the parent class workspace or the sibling `flutter` SDK.
