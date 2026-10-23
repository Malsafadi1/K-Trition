# Team workflow: database + UI branches

No workflow can guarantee zero merge conflicts. Keeping database changes and UI work on separate feature branches, using one schema owner, and merging small reviewed pull requests reduces them.

## Push this database work (repository root)

Your local database changes are not committed or pushed automatically. From the class workspace:

```sh
cd "/Users/mahmoudalsafadi/Desktop/comp_489:90/K-Trition"
git switch -c feature/local-database
git add k_trition .github
git diff --cached --stat
git commit -m "Add local USDA database and UI-ready repository"
git push -u origin feature/local-database
```

If that branch already exists, use `git switch feature/local-database`. Review staged files before committing. The scoped `git add` intentionally leaves the unrelated root `.DS_Store` change out. Do not use `git add .` if you have unrelated changes.

On GitHub, open a pull request from `feature/local-database` to `main`, ask a teammate to review it, and wait for the checks to pass before merging. This is code review, not database-data synchronization.

## Teammates: get the database

After the pull request has been merged:

```sh
git clone https://github.com/Malsafadi1/K-Trition.git
cd K-Trition/k_trition
flutter pub get
flutter test
flutter run -d chrome --web-port=7357
```

Before merging, teammates can test the feature branch instead:

```sh
git clone --branch feature/local-database https://github.com/Malsafadi1/K-Trition.git
```

Everyone needs their own Flutter installation (tested here with 3.47.7). Never add the Flutter SDK itself to this repo. In Mahmoud's existing class workspace, use `../../flutter/bin/flutter` in place of `flutter` from the Flutter project directory. The app still displays the starter roadmap because UI integration is intentionally pending. The database tests actually exercise SQLite.

## Teammates: update an existing clean checkout

From the repository root, first run `git status`. Commit your own work on your feature branch before switching branches. Then:

```sh
git switch main
git pull --ff-only origin main
git switch -c feature/food-ui
cd k_trition
flutter pub get
```

Use separate names for each person's branch (e.g. `feature/food-ui`, `feature/water-goals-ui`). If you cannot commit unfinished work, stash it with `git stash push -u -m "Save unfinished work"`; restore only on its original branch with `git stash pop`. Restoring a stash can itself need conflict resolution.

To incorporate newer main changes into an existing feature branch, with a clean working tree:

```sh
git fetch origin
git merge origin/main
```

Resolve conflicts by discussing overlapping changes, then rerun tests. Do not force-push main, delete a teammate's work, or choose “accept all” without reviewing what it removes.

## Ownership to minimize conflicts

- Database owner: `lib/data/`, `schema.drift`, catalog/import scripts and schema migrations.
- UI owners: their screen/feature folders; use the public NutritionRepository API.
- Coordinate shared edits to `pubspec.yaml`, `pubspec.lock`, `main.dart`, themes and navigation.
- Commit `database.g.dart` and `pubspec.lock`. Do not hand-edit generated database code or run `pub upgrade` as part of routine setup.
- If SQL changes, the database owner runs `dart run build_runner build`, commits SQL + generated code + migration tests together.
- GitHub shares public food fixtures and code, not each person's private meal/water database.

## Checks before each pull request

```sh
flutter analyze
flutter test
flutter build web
```

For an optional real browser database check:

```sh
flutter run -d chrome -t tool/database_smoke_check.dart --web-port=7358
```

Look for `DATABASE_CHECK_PASSED` in the terminal. This uses a separate check database. No cloud setup or Firebase login is required.
