# contacts_service

[![pub package](https://img.shields.io/pub/v/contacts_service.svg)](https://pub.dartlang.org/packages/contacts_service)
A Flutter plugin to access and manage the device's contacts.


## Usage
To use this plugin, add `contacts_service` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

Make sure you add the following permissions to your Android Manifest
```
<uses-permission android:name="android.permission.READ_CONTACTS" />
<uses-permission android:name="android.permission.WRITE_CONTACTS" />
```

On iOS, make sure to set *NSContactsUsageDescription* in your Info.plist
```
<key>NSContactsUsageDescription</key>
<string>This app requires contacts access to function properly.</string>
```

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
<img src="doc/example.gif" width="300">


## Todo
- [ ] update contact
- [ ] get contact thumbnail


## Contributions

Contributions are welcome! If you find a bug or want a feature, please fill an issue.

If you want to contribute code please create a pull request.

## Credits

Heavily inspired from rt2zz's react native [plugin](https://github.com/rt2zz/react-native-contacts) 
