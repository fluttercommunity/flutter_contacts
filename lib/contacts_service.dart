import 'dart:async';

import 'package:flutter/services.dart';

class ContactsService {
  static const MethodChannel _channel = const MethodChannel('github.com/clovisnicolas/flutter_contacts');

  /**
   * Fetches all contacts, or when specified,
   * the contacts with a name matching [query]
   */
  static Future<Iterable<Contact>> getContacts({String query}) async{
    Iterable<Map> contacts = await _channel.invokeMethod('getContacts', query);
    return contacts.map((m) => new Contact.fromMap(m));
  }

  /**
   * Adds the [contact] to the device contact list
   */
  static Future addContact(Contact contact) => _channel.invokeMethod('addContact', Contact._toMap(contact));
}

class Contact{

  Contact({
    this.givenName, this.middleName, this.prefix,
    this.suffix, this.familyName, this.company, this.jobTitle,
    this.emails, this.phones, this.postalAddresses
  });

  String displayName, givenName, middleName, prefix, suffix, familyName, company, jobTitle;
  Iterable<Item> emails = [];
  Iterable<Item> phones = [];
  Iterable<PostalAddress> postalAddresses = [];

  Contact.fromMap(Map m){
    displayName = m["displayName"];
    givenName = m["givenName"];
    middleName = m["middleName"];
    familyName = m["familyName"];
    prefix = m["prefix"];
    suffix = m["suffix"];
    company = m["company"];
    jobTitle = m["jobTitle"];
    emails = (m["emails"] as Iterable<Map>)?.map((m) => new Item.fromMap(m));
    phones = (m["phones"] as Iterable<Map>)?.map((m) => new Item.fromMap(m));
    postalAddresses = (m["postalAddresses"] as Iterable<Map>)?.map((m) => new PostalAddress.fromMap(m));
  }

  static Map _toMap(Contact contact){
    var emails = [];
    for(Item email in contact.emails ?? []){
      emails.add(Item._toMap(email));
    }
    var phones = [];
    for(Item phone in contact.phones ?? []){
      phones.add(Item._toMap(phone));
    }
    var postalAddresses = [];
    for(PostalAddress address in contact.postalAddresses ?? []){
      postalAddresses.add(PostalAddress._toMap(address));
    }
    return {
      "displayName": contact.displayName,
      "givenName": contact.givenName,
      "middleName": contact.middleName,
      "familyName": contact.familyName,
      "prefix": contact.prefix,
      "suffix": contact.suffix,
      "company" : contact.company,
      "jobTitle": contact.jobTitle,
      "emails" : emails,
      "phones" : phones,
      "postalAddresses" : postalAddresses
    };
  }

}

class PostalAddress{

  PostalAddress({this.label, this.street, this.city, this.postcode, this.region, this.country});
  String label, street, city, postcode, region, country;

  PostalAddress.fromMap(Map m){
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

/**
 * Item class used for contact fields which only have
 * a [label] and a [value] such as emails & phone numbers
 */
class Item{

  Item({this.label, this.value});
  String label, value;

  Item.fromMap(Map m){
    label = m["label"];
    value = m["value"];
  }

  static Map _toMap(Item i) =>  {"label": i.label, "value": i.value};
}
