# Flutter client demo for a Shelf Postgres server

In order for this to work, you need to have a the following things already set up:

- A Postgres server running with a correctly configured database.
- The Shelf server running on localhost port 8080.

Follow the directions in the tutorial for help.

## Updating the platform folders

If the platform you are running on is not working, try deleting the platform folder and then running `flutter create.` again. However, after doing so, you'll need to make the following platform specific changes:

### macOS

Allow internet permission.

- https://stackoverflow.com/questions/61196860/how-to-enable-flutter-internet-permission-for-macos-desktop-app