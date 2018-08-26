import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const MethodChannel channel =
      MethodChannel('github.com/clovisnicolas/flutter_contacts');
  final List<MethodCall> log = <MethodCall>[];
  channel.setMockMethodCallHandler((MethodCall methodCall) async {
    log.add(methodCall);
    if (methodCall.method == 'getContacts') {
      return [
        {'givenName': 'givenName1'},
        {
          'givenName': 'givenName2',
          'postalAddresses': [
            {'label': 'label'}
          ],
          'emails': [
            {'label': 'label'}
          ]
        },
      ];
    }
    return null;
  });

  tearDown(() {
    log.clear();
  });

  test('should get contacts', () async {
    final Iterable contacts = await ContactsService.getContacts();
    expect(contacts.length, 2);
    expect(contacts, everyElement(isInstanceOf<Contact>()));
    expect(contacts.toList()[0].givenName, 'givenName1');
    expect(contacts.toList()[1].postalAddresses.toList()[0].label, 'label');
    expect(contacts.toList()[1].emails.toList()[0].label, 'label');
  });

  test('should add contact', () async {
    await ContactsService.addContact(Contact(
      givenName: 'givenName',
      emails: [Item(label: 'label')],
      phones: [Item(label: 'label')],
      postalAddresses: [PostalAddress(label: 'label')],
    ));
    expectMethodCall(log, 'addContact');
  });

  test('should delete contact', () async {
    await ContactsService.deleteContact(Contact(
      givenName: 'givenName',
      emails: [Item(label: 'label')],
      phones: [Item(label: 'label')],
      postalAddresses: [PostalAddress(label: 'label')],
    ));
    expectMethodCall(log, 'deleteContact');
  });
}

void expectMethodCall(List<MethodCall> log, String methodName) {
  expect(log, <Matcher>[
    isMethodCall(
      methodName,
      arguments: <String, dynamic>{
        'identifier': null,
        'displayName': null,
        'givenName': 'givenName',
        'middleName': null,
        'familyName': null,
        'prefix': null,
        'suffix': null,
        'company': null,
        'jobTitle': null,
        'emails': [
          {'label': 'label', 'value': null}
        ],
        'phones': [
          {'label': 'label', 'value': null}
        ],
        'postalAddresses': [
          {
            'label': 'label',
            'street': null,
            'city': null,
            'postcode': null,
            'region': null,
            'country': null
          }
        ],
        'avatar': null
      },
    ),
  ]);
}
