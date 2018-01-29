import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Iterable<Contact> _contacts;

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  initPlatformState() async {
    var contacts = await ContactsService.getAllContacts();
    setState(() {_contacts = contacts;});
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(appBar: new AppBar(title: new Text('Contacts plugin example')),
        body: new SafeArea(
          child: new ListView.builder(
            itemCount: _contacts?.length ?? 0,
            itemBuilder: (BuildContext context, int index){
              Contact c = _contacts?.elementAt(index);
              return new ListTile(
                onTap: (){Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new _ContactDetails(c)));},
                leading : new CircleAvatar(child: new Text(c.displayName?.substring(0,2) ?? "")),
                title: new Text(c.displayName ?? ""),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ContactDetails extends StatelessWidget{

  _ContactDetails(this._contact);
  final Contact _contact;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text(_contact.displayName ?? "")),
        body: new SafeArea(
          child: new ListView(
            children: <Widget>[
              new ListTile(title: new Text("Name"),trailing: new Text(_contact.givenName ?? "")),
              new ListTile(title: new Text("Family name"),trailing: new Text(_contact.familyName ?? "")),
              new ListTile(title: new Text("Company"),trailing: new Text(_contact.company ?? "")),
              new ListTile(title: new Text("Job"),trailing: new Text(_contact.jobTitle ?? "")),
              new _AddressesTile(_contact.postalAddresses),
              new ItemsTile("Phones", _contact.phones),
              new ItemsTile("Emails", _contact.emails)
            ],
          ),
        )
    );
  }
}

class _AddressesTile extends StatelessWidget{

  _AddressesTile(this._addresses);
  final Iterable<PostalAddress> _addresses;

  Widget build(BuildContext context){
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new ListTile(title : new Text("Addresses")),
          new Column(
              children: _addresses.map((a) => new Padding(
                padding : const EdgeInsets.symmetric(horizontal: 16.0),
                child: new Column(
                  children: <Widget>[
                    new ListTile(title : new Text("Street"), trailing: new Text(a.street)),
                    new ListTile(title : new Text("Postcode"), trailing: new Text(a.postcode)),
                    new ListTile(title : new Text("City"), trailing: new Text(a.city)),
                    new ListTile(title : new Text("Region"), trailing: new Text(a.region)),
                    new ListTile(title : new Text("Country"), trailing: new Text(a.country)),
                  ],
                ),
              )).toList()
          )
        ]
    );
  }
}

class ItemsTile extends StatelessWidget{

  ItemsTile(this._title, this._items);
  Iterable<Item> _items;
  String _title;

  @override
  Widget build(BuildContext context) {
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new ListTile(title : new Text(_title)),
          new Column(
              children: _items.map((i) => new Padding(
                  padding : const EdgeInsets.symmetric(horizontal: 16.0),
                  child: new ListTile(title: new Text(i.label ?? ""), trailing: new Text(i.value ?? "")))).toList()
          )
        ]
    );
  }
}

