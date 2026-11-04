# Team workflow

Use feature branches and small pull requests so teammates can work in parallel. This reduces merge conflicts, but cannot eliminate them.

## Set up the project

Clone the repository, then open a terminal in the `k_trition` folder:

```sh
flutter pub get
flutter test
flutter run -d chrome --web-port=7357
```

Install Flutter and Chrome first. Check that Flutter is available by running `flutter --version`. If the `flutter` command is not on your `PATH`, run the `flutter` executable from your Flutter SDK's `bin` folder instead. Use your platform's terminal and path syntax. Android and iOS targets require their respective toolchains.

When using the database in a browser, its storage is scoped to the origin (host and port). Keep using port `7357` when testing browser database persistence. The current dashboard itself is a prototype and keeps its entries in memory; the repository's persistent database is implemented separately and has not been connected to that screen.

## Branch and pull request workflow

Run Git commands from the repository root. Start a feature branch from the latest `main`:

```sh
git status
git switch main
git pull --ff-only origin main
git switch -c feature/short-description
```

Before switching branches, commit your work or save it with `git stash push -u -m "Save unfinished work"`. Restore a stash only on the branch where you created it.

Stage only files related to your change. Review the staged diff before committing:

```sh
git add path/to/your/files
git diff --cached
git commit -m "Describe the change"
git push -u origin feature/short-description
```

Open a pull request from your feature branch to `main`. Ask a teammate to review it and wait for required checks before merging. Do not force-push `main`, overwrite another person's changes, or accept all conflict resolutions without reviewing them.

To bring newer `main` changes into an existing feature branch, first make sure your work is committed or safely stashed, then run:

```sh
git fetch origin
git merge origin/main
```

## Coordinate changes

- Database changes belong in `lib/data/`, the Drift schema, catalog/import files, and related tests. Coordinate schema changes with the database owner.
- Screen changes belong in the relevant feature area. The current dashboard is implemented in `lib/features/dashboard/dashboard_screen.dart`.
- Coordinate shared edits to `pubspec.yaml`, `pubspec.lock`, `main.dart`, app themes, and navigation.
- Commit `pubspec.lock` and generated `database.g.dart` when required. Do not hand-edit generated files or routinely run `pub upgrade`.
- After changing the database schema, regenerate Drift code with `dart run build_runner build` from `k_trition/`; update the schema version and add migration tests when the schema has shipped.
- Git shares source code and the bundled public food catalog, not private user databases. Each device or browser origin has separate local data.

## Check changes before a pull request

Run from the `k_trition` folder:

```sh
flutter analyze
flutter test
flutter build web
```

## Optional browser database check

This runs the repository against a separate browser database and does not use the dashboard:

```sh
flutter run -d chrome -t tool/database_smoke_check.dart --web-port=7358
```

Look in the Flutter terminal for `DATABASE_CHECK_PASSED`. The check creates and reads a water record, then removes it. It does not need Firebase or a login.
