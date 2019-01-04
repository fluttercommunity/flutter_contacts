# contacts_service

[![pub package](https://img.shields.io/pub/v/contacts_service.svg)](https://pub.dartlang.org/packages/contacts_service)
[![Build Status](https://travis-ci.org/fluttercommunity/flutter_contacts.svg?branch=master)](https://travis-ci.org/fluttercommunity/flutter_contacts)
[![Coverage Status](https://coveralls.io/repos/github/clovisnicolas/flutter_contacts/badge.svg?branch=master)](https://coveralls.io/github/clovisnicolas/flutter_contacts?branch=master)

A Flutter plugin to access and manage the device's contacts.

## Usage

To use this plugin, add `contacts_service` as a [dependency in your `pubspec.yaml` file](https://flutter.io/platform-plugins/).

Make sure you add the following permissions to your Android Manifest:

```xml
<uses-permission android:name="android.permission.READ_CONTACTS" />
<uses-permission android:name="android.permission.WRITE_CONTACTS" />
```

On iOS, make sure to set `NSContactsUsageDescription` in the `Info.plist` file

```xml
<key>NSContactsUsageDescription</key>
<string>This app requires contacts access to function properly.</string>
```

To check and request user permission to access contacts, I recommend using the following plugin: [flutter_simple_permissions](https://github.com/AppleEducate/flutter_simple_permissions)

If you do not request user permission or have it granted, the application will fail. For testing purposes, you can manually set the permissions for your test app in Settings for your app on the device that you are using. For Android, go to "Settings" - "Apps" - select your test app - "Permissions" - then turn "on" the slider for contacts. 

## Example

``` dart
// Import package
import 'package:contacts_service/contacts_service.dart';

// Get all contacts
Iterable<Contact> contacts = await ContactsService.getContacts();

// Get contacts matching a string
Iterable<Contact> johns = await ContactsService.getContacts(query : "john");

// Add a contact
// The contact must have a firstName / lastName to be successfully addded
await ContactsService.addContact(newContact);

//Delete a contact
await ContactsService.deleteContact(contact);

```

![Example](doc/example.gif "Example screenshot")

## Todo

- [ ] update contact
- [ ] add withThumbnails optional parameter in getContacts method

## Contributions

Contributions are welcome! If you find a bug or want a feature, please fill an issue.

If you want to contribute code please create a pull request.

## Credits

Heavily inspired from rt2zz's react native [plugin](https://github.com/rt2zz/react-native-contacts) 
