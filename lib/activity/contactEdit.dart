import 'package:flutter/material.dart';
import 'package:kevin_app/activity/cameraActivity.dart';
import 'package:kevin_app/contact.dart';
import 'package:kevin_app/activity/ContactList.dart';
import 'package:kevin_app/ContactDb.dart';

import 'package:camera/camera.dart';

class ContactEdit extends StatefulWidget {
  final Contact contact;
  ContactEdit({@required this.contact});

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
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final ContactDb db = ContactDb();
  Contact contact;
  String name;
  String phone;
  String image;

  @override
  void initState() {
    super.initState();
    this.contact = widget.contact;
    this.name = widget.contact.name;
    this.nameController.text = this.name;
    this.phone = widget.contact.phone.toString();
    this.phoneController.text = this.phone;
  }

  Future<void> _updateContact(Contact contact) async {
    contact.name = nameController.text;
    contact.phone = int.parse(phoneController.text);
    print('after update id');
    print(contact);
    await db.updateContact(contact);
    // Scaffold.of(context)
    //     .showSnackBar(SnackBar(content: Text('Contact has been updated')));
  }

  Future<void> _deleteContact(Contact contact) async {
    await db.deleteContact(contact.id);
    List<Contact> contacts = await db.contacts();

    print('Contacts AFTER DELETE $contacts');
    // Scaffold.of(context)
    //     .showSnackBar(SnackBar(content: Text('Contact has been deleted')));
    // Navigator.pushNamed(context, '/');
  }

  Future _alertDialog(String text) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(text),
          );
        });
  }

  void _resetFormFields() {
    nameController.text = "";
    phoneController.text = "";
    image = "";
  }

  @override
  Widget build(BuildContext context) {
    // contact = ModalRoute.of(context).settings.arguments;
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        title: Text('My Contacts'),
      ),
      body: Column(
        children: <Widget>[
          Form(
              key: _formKey,
              child: Container(
                width: 250,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(this.name),
                      Text(this.phone),
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            this.name = value;
                          });
                        },
                        decoration: InputDecoration(hintText: 'name'),
                        controller: nameController,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            this.phone = value;
                          });
                        },
                        decoration: InputDecoration(hintText: 'phone number'),
                        keyboardType: TextInputType.phone,
                        controller: phoneController,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: RaisedButton(
                          color: Colors.blue[300],
                          onPressed: () async {
                            if (nameController.text == "") {
                              _alertDialog('name is missing');
                            } else if (phoneController.text == "") {
                              _alertDialog('phone number is missing');
                            } else {
                              contact = widget.contact;
                              print('before update id');
                              print(contact.id);
                              await _updateContact(contact);
                              List<Contact> contacts = await db.contacts();
                              print('CONTACT LIST AFTER UPDATE $contacts');
                              _resetFormFields();
                            }
                          },
                          child: Text(
                            "save",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      RaisedButton(
                        child: Text('delete'),
                        onPressed: () async {
                          await _deleteContact(contact);
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('contact deleted'),
                                  actions: <Widget>[
                                    FlatButton(
                                        child: Text('close'),
                                        onPressed: () {
                                          // Navigator.of(context).pop();
                                          Navigator.popUntil(context,
                                              ModalRoute.withName('/'));
                                          // Navigator.pushNamed(context, '/');
                                        })
                                  ],
                                );
                              });
                          // Navigator.pushNamed(context, '/');
                        },
                      )
                    ],
                  ),
                ),
              ) // Build this out in the next steps.
              ),
        ],
      ),
    );
  }
}
