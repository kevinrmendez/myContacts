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
  final emailController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final ContactDb db = ContactDb();
  Contact contact;
  String name;
  String email;
  String phone;
  String image;

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
  }

  Future<void> _updateContact(Contact contact) async {
    contact.name = nameController.text;
    contact.phone = int.parse(phoneController.text);
    contact.email = emailController.text;
    print('after update id');
    print(contact);
    await db.updateContact(contact);
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
    _showMessage('contact deleted');
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
    emailController.text = "";
    image = "";
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
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
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                  key: _formKey,
                  child: Container(
                    width: 250,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                this.name = value;
                              });
                            },
                            decoration: InputDecoration(
                                hintText: 'name', icon: Icon(Icons.person)),
                            controller: nameController,
                          ),
                          TextFormField(
                            onChanged: (value) {
                              setState(() {
                                this.phone = value;
                              });
                            },
                            decoration: InputDecoration(
                                hintText: 'phone number',
                                icon: Icon(Icons.phone)),
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
                            // validator: (value) {
                            //   if (value.isEmpty) {
                            //     return 'Please enter the email';
                            //   }
                            //   return null;
                            // },
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
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
                                  // print('before update id');
                                  // print(contact.id);
                                  await _updateContact(contact);
                                  // _showSnackBar('contact has been updated');
                                  // List<Contact> contacts = await db.contacts();
                                  // print('CONTACT LIST AFTER UPDATE $contacts');
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
                            child: Text('delete contact'),
                            onPressed: () async {
                              await _deleteContact(contact);

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
        ],
      ),
    );
  }
}
