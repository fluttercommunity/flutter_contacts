import 'dart:async';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class ContactsService {
  static const MethodChannel _channel =
      MethodChannel('github.com/clovisnicolas/flutter_contacts');

  /// Fetches all contacts, or when specified, the contacts with a name
  /// matching [query]
  static Future<Iterable<Contact>> getContacts({String query}) async {
    Iterable contacts = await _channel.invokeMethod('getContacts', query);
    return contacts.map((m) => Contact.fromMap(m));
  }

  /// Adds the [contact] to the device contact list
  static Future addContact(Contact contact) =>
      _channel.invokeMethod('addContact', Contact._toMap(contact));

  /// Deletes the [contact] if it has a valid identifier
  static Future deleteContact(Contact contact) =>
      _channel.invokeMethod('deleteContact', Contact._toMap(contact));
}

class Contact {
  Contact(
      {this.givenName,
      this.middleName,
      this.prefix,
      this.suffix,
      this.familyName,
      this.company,
      this.jobTitle,
      this.emails,
      this.phones,
      this.postalAddresses,
      this.avatar});

  String identifier,
      displayName,
      givenName,
      middleName,
      prefix,
      suffix,
      familyName,
      company,
      jobTitle;
  Iterable<Item> emails = [];
  Iterable<Item> phones = [];
  Iterable<PostalAddress> postalAddresses = [];
  Uint8List avatar;

  Contact.fromMap(Map m) {
    identifier = m["identifier"];
    displayName = m["displayName"];
    givenName = m["givenName"];
    middleName = m["middleName"];
    familyName = m["familyName"];
    prefix = m["prefix"];
    suffix = m["suffix"];
    company = m["company"];
    jobTitle = m["jobTitle"];
    emails = (m["emails"] as Iterable)?.map((m) => Item.fromMap(m));
    phones = (m["phones"] as Iterable)?.map((m) => Item.fromMap(m));
    postalAddresses = (m["postalAddresses"] as Iterable)
        ?.map((m) => PostalAddress.fromMap(m));
    avatar = m["avatar"];
  }

  static Map _toMap(Contact contact) {
    var emails = [];
    for (Item email in contact.emails ?? []) {
      emails.add(Item._toMap(email));
    }
    var phones = [];
    for (Item phone in contact.phones ?? []) {
      phones.add(Item._toMap(phone));
    }
    var postalAddresses = [];
    for (PostalAddress address in contact.postalAddresses ?? []) {
      postalAddresses.add(PostalAddress._toMap(address));
    }
    return {
      "identifier": contact.identifier,
      "displayName": contact.displayName,
      "givenName": contact.givenName,
      "middleName": contact.middleName,
      "familyName": contact.familyName,
      "prefix": contact.prefix,
      "suffix": contact.suffix,
      "company": contact.company,
      "jobTitle": contact.jobTitle,
      "emails": emails,
      "phones": phones,
      "postalAddresses": postalAddresses,
      "avatar": contact.avatar
    };
  }

  Map toMap() {
    return Contact._toMap(this);
  }

  /// Updates this [Contact] with data from [contact].
  void mergeWith(Contact contact) {}

  /// "Adding" two contacts together is basically applying the data
  /// from the missing field.
  /// If you would like to merge the contacts, use the [merge] function.
  operator +(Contact contact) =>
      Contact(
          givenName: this.givenName ?? contact.givenName,
          middleName: this.middleName ?? contact.middleName,
          prefix: this.prefix ?? contact.prefix,
          suffix: this.suffix ?? contact.suffix,
          familyName: this.familyName ?? contact.familyName,
          company: this.company ?? contact.company,
          jobTitle: this.jobTitle ?? contact.jobTitle,
          emails: this.emails == null
              ? contact.emails
              : Iterable.castFrom(
              this.emails.toSet().union(contact.emails.toSet())),
          phones: this.phones == null
              ? contact.phones
              : Iterable.castFrom(
              this.phones.toSet().union(contact.phones.toSet())),
          postalAddresses: this.postalAddresses == null
              ? contact.postalAddresses
              : Iterable.castFrom(this
              .postalAddresses
              .toSet()
              .union(contact.postalAddresses.toSet())),
          avatar: this.avatar ?? contact.avatar);

  /// Returns true if all items in this contact are identical.
  @override
  bool operator ==(other) {
    if (other is! Contact) return false;

    Map otherMap = (other as Contact).toMap(); // ignore: test_types_in_equals
    Map thisMap = this.toMap();

    for (var key in otherMap.keys) {
      if (otherMap[key] is! Iterable) {
        if (thisMap[key] != otherMap[key]) {
          return false;
        }
      } else if (otherMap[key] is Iterable) {
        var equal = DeepCollectionEquality.unordered()
            .equals(thisMap[key], otherMap[key]);
        if (!equal) {
          return false;
        }
      }
    }
    return true;
  }

  @override
  int get hashCode {
    return this.hashCode;
  }

  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
}

class RawContact {
  final int rawContactId;
  final int accountId;
  final sourceid;
  final rawContactIsReadOnly;
  final version;
  final dirty;
  final deleted;
  final contactId;
  final aggregationMode;
  final aggregationNeeded;
  final customRingtone;
  final sendToVoicemail;
  final timesContacted;
  final lastTimeContacted;
  final starred;
  final pinned;
  final displayName;
  final displayNameAlt;
  final displayNameSource;
  final phoneticName;
  final phoneticNameStyle;
  final sortKey;
  final phonebookLabel;
  final phonebookBucket;
  final sortKeyAlt;
  final phonebookLabelAlt;
  final phonebookBucketAlt;
  final nameVerified;
  final sync1;
  final sync2;
  final sync3;
  final sync4;
  final syncUid;
  final syncVersion;
  final hasCalendarEvent;
  final modifiedTime;
  final isRestricted;
  final ypSource;
  final methodSelected;
  final customVibrationType;
  final customRingtonePath;
  final messageNotification;
  final messageNotificationPath;
  final costSave;
  final customLedType;
  final backupId;

  RawContact({@required this.rawContactId,
    @required this.accountId,
    this.sourceid,
    this.rawContactIsReadOnly = 0,
    this.version,
    this.dirty,
    this.deleted,
    this.contactId,
    this.aggregationMode,
    this.aggregationNeeded,
    this.customRingtone,
    this.sendToVoicemail,
    this.timesContacted,
    this.lastTimeContacted,
    this.starred,
    this.pinned,
    this.displayName,
    this.displayNameAlt,
    this.displayNameSource,
    this.phoneticName,
    this.phoneticNameStyle,
    this.sortKey,
    this.phonebookLabel,
    this.phonebookBucket,
    this.sortKeyAlt,
    this.phonebookLabelAlt,
    this.phonebookBucketAlt,
    this.nameVerified,
    this.sync1,
    this.sync2,
    this.sync3,
    this.sync4,
    this.syncUid,
    this.syncVersion,
    this.hasCalendarEvent,
    this.modifiedTime,
    this.isRestricted,
    this.ypSource,
    this.methodSelected,
    this.customVibrationType,
    this.customRingtonePath,
    this.messageNotification,
    this.messageNotificationPath,
    this.costSave,
    this.customLedType,
    this.backupId});
}

class PostalAddress {
  PostalAddress(
      {this.label,
      this.street,
      this.city,
      this.postcode,
      this.region,
      this.country});

  String label, street, city, postcode, region, country;

  PostalAddress.fromMap(Map m) {
    label = m["label"];
    street = m["street"];
    city = m["city"];
    postcode = m["postcode"];
    region = m["region"];
    country = m["country"];
  }

  static Map _toMap(PostalAddress address) => {
        "label": address.label,
        "street": address.street,
        "city": address.city,
        "postcode": address.postcode,
        "region": address.region,
        "country": address.country
      };
}

/// Item class used for contact fields which only have a [label] and
/// a [value], such as emails and phone numbers
class Item {
  Item({this.label, this.value});

  String label, value;

  Item.fromMap(Map m) {
    label = m["label"];
    value = m["value"];
  }

  static Map _toMap(Item i) => {"label": i.label, "value": i.value};
}
