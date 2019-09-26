import 'package:flutter/material.dart';
import 'package:kevin_app/appSettings.dart';

import 'package:kevin_app/contact.dart';
import 'package:kevin_app/ContactDb.dart';

import '../myThemes.dart';

class ContactEdit extends StatefulWidget {
  final Contact contact;
  final Function callback;
  ContactEdit({@required this.contact, this.callback});

  @override
  ContactEditState createState() {
    return ContactEditState();
  }
}

class ContactEditState extends State<ContactEdit> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final ContactDb db = ContactDb();
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final instagramController = TextEditingController();

  String name;
  String phone;
  String email;
  String instagram;
  Contact contact;
  Future<List<Contact>> contacts;

  callback({String name, String phone, String email, String instagram}) {
    setState(() {
      this.name = name;
      this.phone = phone;
      this.email = email;
      this.instagram = instagram;
    });
  }

  @override
  void initState() {
    super.initState();
    this.contact = widget.contact;
    this.name = widget.contact.name;
    this.phone = widget.contact.phone.toString();
    this.email = widget.contact.email;
    this.instagram = widget.contact.instagram;

    this.nameController.text = this.name;
    this.phoneController.text = this.phone;
    this.emailController.text = this.email;
    this.instagramController.text = this.instagram;

    this.contact = widget.contact;
  }

  Future<void> _updateContact(Contact contact) async {
    contact.name = nameController.text;
    contact.phone = phoneController.text;
    contact.email = emailController.text;
    contact.instagram = instagramController.text;

    print('after update id');
    print(contact);
    await db.updateContact(contact);
    contacts = db.contacts();
    widget.callback(contacts);
    _showMessage('contact information changed');
  }

  Future<void> _deleteContact(Contact contact) async {
    List<Contact> contactList;
    AppSettings appState = AppSettings.of(context);
    await db.deleteContact(contact.id);
    // List<Contact> contacts = await db.contacts();
    // print('Contacts AFTER DELETE $contacts');
    contacts = db.contacts();
    contactList = await contacts;

    int contactsLength = contactList.length;

    widget.callback(
        contacts: contacts, names: contactList, filteredNames: contactList);
    _showMessage('contact deleted');
  }

  void _showMessage(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(message),
            actions: <Widget>[
              FlatButton(
                  child: Text('close'),
                  onPressed: () {
                    // Navigator.of(context).pop();
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  })
            ],
          );
        });
  }

  Widget _buildForm(Orientation orientation) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Form(
            key: _formKey,
            child: Container(
              width: 250,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        this.name = value;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: 'name', icon: Icon(Icons.person)),
                    controller: nameController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter the name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        this.phone = value;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: 'phone number', icon: Icon(Icons.phone)),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter the phone';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        this.email = value;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: 'email', icon: Icon(Icons.email)),
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        print(value);
                        this.instagram = value;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: 'instagram', icon: Icon(Icons.casino)),
                    keyboardType: TextInputType.text,
                    controller: instagramController,
                  ),
                  _buildFormButtons(orientation)
                ],
              ),
            ) // Build this out in the next steps.
            ),
      ],
    );
  }

  Widget _buildFormButtons(Orientation orientation) {
    List<Widget> _buttons = [
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: RaisedButton(
          color: Theme.of(context).primaryColor,
          onPressed: () async {
            _updateContact(contact);
          },
          child: Text(
            'save',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: RaisedButton(
          color: Theme.of(context).primaryColor,
          child: Text(
            'delete ',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            await _deleteContact(contact);
          },
        ),
      )
    ];

    if (orientation == Orientation.portrait) {
      return Column(
        children: _buttons,
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _buttons,
      );
    }
  }

  Widget _buildPreviewText(Orientation orientation) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // _buildText(this.name, orientation),
        _buildBoldText(this.name, orientation),
        _buildText(this.phone, orientation),
        Padding(
          padding: EdgeInsets.only(bottom: 0),
          child: _buildText(this.email, orientation),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: _buildText(this.instagram, orientation),
        ),
      ],
    );
  }

  Widget _buildText(String text, Orientation orientation) {
    return Container(
      width: orientation == Orientation.portrait
          ? MediaQuery.of(context).size.width * 0.8
          : MediaQuery.of(context).size.width * 0.5,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 22),
      ),
    );
  }

  Widget _buildBoldText(String text, Orientation orientation) {
    AppSettings appState = AppSettings.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      width: orientation == Orientation.portrait
          ? MediaQuery.of(context).size.width * 0.8
          : MediaQuery.of(context).size.width * 0.5,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: appState.themeKey == MyThemeKeys.DARK
                ? Colors.white
                : Theme.of(context).primaryColor),
      ),
    );
  }

  Widget _buildVerticalLayout(Orientation orientation) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildPreviewText(orientation),
            _buildForm(orientation),
          ],
        )
      ],
    );
  }

  Widget _buildHorizontalLayout(Orientation orientation) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _buildPreviewText(orientation),
        _buildForm(orientation),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // contact = ModalRoute.of(context).settings.arguments;
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Edit Contact'),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        var orientation = MediaQuery.of(context).orientation;
        return orientation == Orientation.portrait
            ? _buildVerticalLayout(orientation)
            : _buildHorizontalLayout(orientation);
      }),
    );
  }
}
