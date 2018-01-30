# contacts_service

[![pub package](https://img.shields.io/pub/v/contacts_service.svg)](https://pub.dartlang.org/packages/contacts_service)
A Flutter plugin to access and manage the device's contacts.


## Usage
To use this plugin, add `contacts_service` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

Make sure you add the following permissions to your Android Manifest
```
<uses-permission android:name="android.permission.READ_CONTACTS" />
```

## Example
``` dart
// Import package
import 'package:contacts_service/contacts_service.dart';

// Get all contacts
Iterable<Contact> contacts = await ContactsService.getContacts();

// Get contacts matching a string
Iterable<Contact> johns = await ContactsService.getContacts(query : "john");
```
<img src="doc/example.gif" width="300">


## Todo
- [ ] add contact
- [ ] delete contact
- [ ] update contact

## Credits

Heavily inspired from rt2zz's react native [plugin](https://github.com/rt2zz/react-native-contacts) 
