import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

void main() => runApp(new DemoApp());

class DemoApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      routes: <String, WidgetBuilder>{
        '/add': (BuildContext context) => new _AddContactPage()
      },
      home: new MyApp()
    );
  }
}

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
    var contacts = await ContactsService.getContacts();
    setState(() {_contacts = contacts;});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Contacts plugin example')),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: (){Navigator.of(context).pushNamed("/add");}
      ),
      body: new SafeArea(
        child: _contacts != null?
          new ListView.builder(
            itemCount: _contacts?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              Contact c = _contacts?.elementAt(index);
              return new ListTile(
                onTap: () { Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new _ContactDetails(c)));},
                leading: (c.avatar != null && c.avatar.length > 0) ?
                new CircleAvatar(backgroundImage: new MemoryImage(c.avatar)):
                new CircleAvatar(child:  new Text(c.displayName?.length > 1 ? c.displayName?.substring(0, 2) : "")),
                title: new Text(c.displayName ?? ""),
              );
            },
          ):
          new Center(child: new CircularProgressIndicator()),
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
        appBar: new AppBar(
          title: new Text(_contact.displayName ?? ""),
          actions: <Widget>[new FlatButton(child:new Icon(Icons.delete), onPressed: (){ContactsService.deleteContact(_contact);})]
        ),
        body: new SafeArea(
          child: new ListView(
            children: <Widget>[
              new ListTile(title: new Text("Name"),trailing: new Text(_contact.givenName ?? "")),
              new ListTile(title: new Text("Middle name"),trailing: new Text(_contact.middleName ?? "")),
              new ListTile(title: new Text("Family name"),trailing: new Text(_contact.familyName ?? "")),
              new ListTile(title: new Text("Prefix"),trailing: new Text(_contact.prefix ?? "")),
              new ListTile(title: new Text("Suffix"),trailing: new Text(_contact.suffix ?? "")),
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
  final Iterable<Item> _items;
  final String _title;

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

class _AddContactPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AddContactPageState();
}

class _AddContactPageState extends State<_AddContactPage>{

  Contact contact = new Contact();
  PostalAddress address = new PostalAddress(label: "Home");
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Add a contact"),
        actions: <Widget>[
          new FlatButton(
            onPressed: (){
              _formKey.currentState.save();
              contact.postalAddresses = [address];
              ContactsService.addContact(contact);
              Navigator.of(context).pop();
            },
            child: new Icon(Icons.save, color: Colors.white)
          )
        ],
      ),
      body: new Container(
        padding: new EdgeInsets.all(12.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            children: <Widget>[
              new TextFormField(decoration: const InputDecoration(labelText: 'First name'), onSaved: (v) => contact.givenName = v),
              new TextFormField(decoration: const InputDecoration(labelText: 'Middle name'), onSaved: (v) => contact.middleName = v),
              new TextFormField(decoration: const InputDecoration(labelText: 'Last name'), onSaved: (v) => contact.familyName = v),
              new TextFormField(decoration: const InputDecoration(labelText: 'Prefix'), onSaved: (v) => contact.prefix = v),
              new TextFormField(decoration: const InputDecoration(labelText: 'Suffix'), onSaved: (v) => contact.suffix = v),
              new TextFormField(
                  decoration: const InputDecoration(labelText: 'Phone'),
                  onSaved: (v) => contact.phones = [new Item(label: "mobile", value: v)],
                  keyboardType: TextInputType.phone
              ),
              new TextFormField(
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  onSaved: (v) => contact.emails = [new Item(label: "work", value: v)],
                  keyboardType: TextInputType.emailAddress
              ),
              new TextFormField(decoration: const InputDecoration(labelText: 'Company'), onSaved: (v) => contact.company = v),
              new TextFormField(decoration: const InputDecoration(labelText: 'Job'), onSaved: (v) => contact.jobTitle = v),
              new TextFormField(decoration: const InputDecoration(labelText: 'Street'), onSaved: (v) => address.street = v),
              new TextFormField(decoration: const InputDecoration(labelText: 'City'), onSaved: (v) => address.city = v),
              new TextFormField(decoration: const InputDecoration(labelText: 'Region'), onSaved: (v) => address.region = v),
              new TextFormField(decoration: const InputDecoration(labelText: 'Postal code'), onSaved: (v) => address.postcode = v),
              new TextFormField(decoration: const InputDecoration(labelText: 'Country'), onSaved: (v) => address.country = v),
            ],
          )
        ),
      ),
    );
  }
}

