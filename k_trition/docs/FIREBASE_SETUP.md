# Firebase status

**Firebase is not used by the current app.** There is no Firebase project setup, sign-in, API key, server, or cloud synchronization to configure.

The app's data layer uses a local SQLite database through Drift. Each device or browser origin stores its own data. The dashboard is not connected to that database yet, so its prototype entries are currently cleared when the app restarts.

For local database details, see the [database guide](DATABASE_GUIDE.md). Do not follow old Firebase setup instructions unless the team explicitly decides to add Firebase in a future version.
