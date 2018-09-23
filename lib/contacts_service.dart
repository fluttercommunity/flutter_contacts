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
  int sourceid;
  var rawContactIsReadOnly;
  var version;
  var dirty;
  var deleted;
  var contactId;
  var aggregationMode;
  var aggregationNeeded;
  var customRingtone;
  var sendToVoicemail;
  var timesContacted;
  var lastTimeContacted;
  var starred;
  var pinned;
  var displayName;
  var displayNameAlt;
  var displayNameSource;
  var phoneticName;
  var phoneticNameStyle;
  var sortKey;
  var phonebookLabel;
  var phonebookBucket;
  var sortKeyAlt;
  var phonebookLabelAlt;
  var phonebookBucketAlt;
  var nameVerified;
  var sync1;
  var sync2;
  var sync3;
  var sync4;
  var syncUid;
  var syncVersion;
  var hasCalendarEvent;
  var modifiedTime;
  var isRestricted;
  var ypSource;
  var methodSelected;
  var customVibrationType;
  var customRingtonePath;
  var messageNotification;
  var messageNotificationPath;
  var costSave;
  var customLedType;
  var backupId;

  RawContact({@required this.rawContactId,
    @required this.accountId,
    this.sourceid,
    this.rawContactIsReadOnly,
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

  RawContact.fromMap(Map map)
      : rawContactId = map['_id'],
        this.accountId = map['account_id'] {
    this.sourceid = map['sourceid'];
    this.rawContactIsReadOnly = map['raw_contact_is_read_only'];
    this.version = map['version'];
    this.dirty = map['dirty'];
    this.deleted = map['deleted'];
    this.contactId = map['contact_id'];
    this.aggregationMode = map['aggregation_mode'];
    this.aggregationNeeded = map['aggregation_needed'];
    this.customRingtone = map['custom_ringtone'];
    this.sendToVoicemail = map['send_to_voicemail'];
    this.timesContacted = map['times_contacted'];
    this.lastTimeContacted = map['last_time_contacted'];
    this.starred = map['starred'];
    this.pinned = map['pinned'];
    this.displayName = map['display_name'];
    this.displayNameAlt = map['display_name_alt'];
    this.displayNameSource = map['display_name_source'];
    this.phoneticName = map['phonetic_name'];
    this.phoneticNameStyle = map['phonetic_name_style'];
    this.sortKey = map['sort_key'];
    this.phonebookLabel = map['phonebook_label'];
    this.phonebookBucket = map['phonebook_bucket'];
    this.sortKeyAlt = map['sort_key_alt'];
    this.phonebookLabelAlt = map['phonebook_label_alt'];
    this.phonebookBucketAlt = map['phonebook_bucket_alt'];
    this.nameVerified = map['name_verified'];
    this.sync1 = map['sync1'];
    this.sync2 = map['sync2'];
    this.sync3 = map['sync3'];
    this.sync4 = map['sync4'];
    this.syncUid = map['sync_uid'];
    this.syncVersion = map['sync_version'];
    this.hasCalendarEvent = map['has_calendar_event'];
    this.modifiedTime = map['modified_time'];
    this.isRestricted = map['is_restricted'];
    this.ypSource = map['yp_source'];
    this.methodSelected = map['method_selected'];
    this.customVibrationType = map['custom_vibration_type'];
    this.customRingtonePath = map['custom_ringtone_path'];
    this.messageNotification = map['message_notification'];
    this.messageNotificationPath = map['message_notification_path'];
    this.costSave = map['cost_save'];
    this.customLedType = map['custom_led_type'];
    this.backupId = map['backup_id'];
  }
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
