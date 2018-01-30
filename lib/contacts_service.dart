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
}

class Contact{

  String displayName, givenName, middleName, prefix, suffix, familyName, company, jobTitle;
  Iterable<Item> emails;
  Iterable<Item> phones;
  Iterable<PostalAddress> postalAddresses;

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
}

class PostalAddress{

  String label, street, city, postcode, region, country;

  PostalAddress.fromMap(Map m){
    label = m["label"];
    street = m["street"];
    city = m["city"];
    postcode = m["postcode"];
    region = m["region"];
    country = m["country"];
  }
}

/**
 * Item class used for contact fields which only have
 * a [label] and a [value] such as emails & phone numbers
 */
class Item{

  String label, value;

  Item.fromMap(Map m){
    label = m["label"];
    value = m["value"];
  }
}
