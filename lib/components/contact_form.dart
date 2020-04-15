import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:kevin_app/activity/cameraActivity.dart';
import 'package:kevin_app/contact.dart';
import 'package:kevin_app/ContactDb.dart';

import '../appSettings.dart';

class ContactForm extends StatefulWidget {
  String image;
  Function(String) callback;
  final nameController;
  final phoneController;
  final emailController;
  final instagramController;

  ContactForm(
      {this.image,
      this.callback,
      this.nameController,
      this.emailController,
      this.instagramController,
      this.phoneController});

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

  final ContactDb db = ContactDb();
  String action = "save";
  String image;
  String name;
  String phone;
  String email;
  String instagram;
  int contactId;

  @override
  void initState() {
    super.initState();

    // this.name = widget.nameController.text;
    // this.phone = widget.phoneController.text;
    // this.email = widget.emailController.text;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    // widget.nameController.dispose();
    // widget.phoneController.dispose();

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
    widget.nameController.text = "";
    widget.phoneController.text = "";
    widget.emailController.text = "";
    widget.instagramController.text = "";
    image = "";
  }

  Future<void> _saveContact(Contact contact) async {
    await db.insertContact(contact);

    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Contact has been saved')));
    _resetFormFields();
    contactId++;
    print(contact);
    print(contactId);
    print(contact.email);
    print(contact.instagram);
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    AppSettings appState = AppSettings.of(context);
    return Form(
        key: _formKey,
        child: Container(
          width: 250,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration:
                    InputDecoration(hintText: 'name', icon: Icon(Icons.person)),
                controller: widget.nameController,
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
                // validator: (value) {
                //   if (value.isEmpty) {
                //     return 'Please enter the phone';
                //   }
                //   return null;
                // },
                keyboardType: TextInputType.phone,
                controller: widget.phoneController,
              ),
              TextFormField(
                decoration:
                    InputDecoration(hintText: 'email', icon: Icon(Icons.email)),
                keyboardType: TextInputType.emailAddress,
                controller: widget.emailController,
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: 'instagram', icon: Icon(Icons.casino)),
                keyboardType: TextInputType.text,
                controller: widget.instagramController,
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    appState.camera == true
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 0),
                            child: RaisedButton(
                              color: Theme.of(context).accentColor,
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
                                widget.callback(image);

                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text('Picture has been taken')));
                                print(image.toString());
                              },
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                            ))
                        : Container(),
                    SizedBox(
                      width: 50,
                    ),
                    Expanded(
                      child: Container(
                        // width: 20,
                        // padding:
                        //     EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                        child: RaisedButton(
                          color: Theme.of(context).accentColor,
                          onPressed: () async {
                            // print('SAVIIIING');
                            // print(widget.nameController);
                            if (_formKey.currentState.validate()) {
                              String name = widget.nameController.text;
                              String formattedName =
                                  '${name[0].toUpperCase()}${name.substring(1)}';
                              Contact contact = Contact(
                                  id: contactId,
                                  name: formattedName,
                                  phone: widget.phoneController.text,
                                  email: widget.emailController.text,
                                  instagram: widget.instagramController.text,
                                  image: widget.image);
                              _saveContact(contact);
                              widget.callback("");
                            }
                            // print(await db.contacts());
                          },
                          child: Text(
                            'save',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ) // Build this out in the next steps.
        );
  }
}
