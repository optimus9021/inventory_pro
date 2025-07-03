# inventory_pro

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Custom Fields

The app allows you to define custom item fields that are stored locally using SQLite.
The app allows you to define custom item fields that are persisted locally in
SQLite. Field metadata is stored in a `fields` table while each item's values
are kept in an `items` table as JSON for a flexible schema.

1. Open **Field Settings** from the home screen.
2. Enter a field name and an optional validation regex, then tap **Add Field**.
3. Open **Add Item** to see a form generated from your saved field definitions.

4. Submitted item data is stored in the `items` collection using the dynamic
   keys you configured.

## Dashboard

Launch the app to view the new dashboard which lists saved items and links to
the item form and field settings. Layouts adapt between narrow and wide screens
so the app works well on mobile, desktop and web.