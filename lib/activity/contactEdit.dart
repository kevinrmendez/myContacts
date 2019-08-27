import 'package:flutter/material.dart';

import 'package:kevin_app/contact.dart';
import 'package:kevin_app/ContactDb.dart';

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
  String name;
  String phone;
  String email;
  Contact contact;
  Future<List<Contact>> contacts;

  callback({String name, String phone, String email}) {
    setState(() {
      this.name = name;
      this.phone = phone;
      this.email = email;
    });
  }

  @override
  void initState() {
    super.initState();
    this.contact = widget.contact;
    this.name = widget.contact.name;
    this.phone = widget.contact.phone.toString();
    this.email = widget.contact.email;

    this.nameController.text = this.name;
    this.phoneController.text = this.phone;
    this.emailController.text = this.email;

    this.contact = widget.contact;
  }

  Future<void> _updateContact(Contact contact) async {
    contact.name = nameController.text;
    contact.phone = int.parse(phoneController.text);
    contact.email = emailController.text;
    print('after update id');
    print(contact);
    await db.updateContact(contact);
    contacts = db.contacts();
    widget.callback(contacts);
    _showMessage('contact information changed');
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

  Future<void> _deleteContact(Contact contact) async {
    await db.deleteContact(contact.id);
    // List<Contact> contacts = await db.contacts();
    // print('Contacts AFTER DELETE $contacts');
    contacts = db.contacts();
    widget.callback(contacts);
    _showMessage('contact deleted');
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
          color: Colors.blue[300],
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
          child: Text('delete '),
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

  Widget _buildPreviewText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          this.name,
          style: TextStyle(fontSize: 30),
        ),
        Text(
          this.phone,
          style: TextStyle(fontSize: 30),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text(
            this.email,
            style: TextStyle(fontSize: 30),
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalLayout(Orientation orientation) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildPreviewText(),
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
        _buildPreviewText(),
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
