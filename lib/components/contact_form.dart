import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kevin_app/activity/cameraActivity.dart';
import 'package:kevin_app/contact.dart';
import 'package:kevin_app/activity/ContactList.dart';
import 'package:kevin_app/ContactDb.dart';

import 'package:camera/camera.dart';

class ContactForm extends StatefulWidget {
  StreamController streamController;

  ContactForm({this.streamController});

  @override
  ContactFormState createState() {
    return ContactFormState();
  }
}

class ContactFormState extends State<ContactForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final ContactDb db = ContactDb();
  String action = "save";
  String image;
  int contactId;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    phoneController.dispose();
    widget.streamController.close();
    super.dispose();
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
    widget.streamController.add("");
  }

  Future<void> _deleteContact() async {
    String name = nameController.text;
    int id = await db.getId(name);
    if (id == null) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('No contact named $name has been added')));
    } else {
      print(id);
      await db.deleteContact(id);
    }
  }

  Future<void> _saveContact(Contact contact) async {
    await db.insertContact(contact);

    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Contact has been $action')));
    _resetFormFields();
    contactId++;
    print(contact);
    print(contactId);
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
        key: _formKey,
        child: Container(
          width: 250,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration:
                    InputDecoration(hintText: 'name', icon: Icon(Icons.person)),
                controller: nameController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the name';
                  }
                  return null;
                },
              ),
              TextFormField(
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
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: RaisedButton(
                    onPressed: () async {
                      final cameras = await availableCameras();
                      final firstCamera = cameras.first;
                      image = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CameraActivity(
                                  camera: firstCamera,
                                )),
                      );
                      widget.streamController.sink.add(image);
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Picture has been taken')));
                      print(image.toString());
                    },
                    child: Icon(Icons.camera_alt),
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: RaisedButton(
                  color: Colors.blue[300],
                  onPressed: () async {
                    // if (action == 'delete') {
                    // } else {
                    //   if (nameController.text == "") {
                    //     _alertDialog('name is missing');
                    //   } else if (phoneController.text == "") {
                    //     _alertDialog('phone number is missing');
                    //   } else {
                    //     Contact contact = Contact(
                    //         id: contactId,
                    //         name: nameController.text,
                    //         phone: int.parse(phoneController.text),
                    //         image: image);
                    //   }
                    if (_formKey.currentState.validate()) {
                      Contact contact = Contact(
                          id: contactId,
                          name: nameController.text,
                          phone: int.parse(phoneController.text),
                          image: image);
                      _saveContact(contact);

                      // print(image);
                    }

                    // print(await db.contacts());
                  },
                  child: Text(
                    action,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ) // Build this out in the next steps.
        );
  }
}
