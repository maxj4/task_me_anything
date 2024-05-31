# basic_flutter_template

A basic Flutter project to serve as a starting point for new Apps. This template is set up with several useful dependencies.

Currently included packages:
- [intl](https://pub.dev/packages/intl)
- [go_router](https://pub.dev/packages/go_router)
- [provider](https://pub.dev/packages/provider)
- [Shared preferences](https://pub.dev/packages/shared_preferences)
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)

## Internationalization (i18n & l10n)

This template uses the [intl](https://pub.dev/packages/intl) package for translations.
The translation files are located at `lib/l10n/`. Currently German (`de`) and English (`en`) are supported. To add more languages, just add a corresponding `app_<language_code>.arb` file and add the language code to the `CFBundleLocalizations` to the `info.plist` file (iOS-specific). Remember to run `flutter pub get` after you've added new translation keys or files to make sure everything is generated.

With the given extension on `BuildContext` (see `lib/utils/extensions/buildcontext/loc.dart`) you can then use your translation keys as follows:

```dart
Text(context.loc.helloWorld('Flutter'))
```

## Navigation (go_router)

[go_router](https://pub.dev/packages/go_router) is used for navigation. It is set up in `lib/router_config.dart`. The routes are stored in `lib/constants.dart`. For an example of nested navigation see the comments in `lib/router_config.dart`. 

## State Management (provider)

[provider](https://pub.dev/packages/provider) is used for simple state management. Two `providers` are currently implemented: `ThemeProvider` and `LocaleProvider` for easy toggling of the theme and locale. 

## Persistent Storage (Shared preferences)

For persistance of simple data (i.e. key-value pairs) [Shared preferences](https://pub.dev/packages/shared_preferences) are used. Is is used in `ThemeProvider` and `LocaleProvider` to store the selected values across app restarts.

## Notifications (flutter_local_notifications)

> [!NOTE]  
> This is currently only implemented for Android! Any contributions/PRs enabling this for iOS and other platforms would be highly appreciated.

[flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) are used to display notifications on the device. The `NotificationService` initializes the NotificationPlugin and sends/shows notifications. 