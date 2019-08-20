import 'package:flutter/material.dart';
import 'package:kevin_app/contact.dart';
import 'package:kevin_app/ContactList.dart';
import 'package:kevin_app/ContactDb.dart';

import 'package:kevin_app/cameraActivity.dart';
import 'package:camera/camera.dart';

class ContactForm extends StatefulWidget {
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

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
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
                decoration: InputDecoration(hintText: 'name'),
                controller: nameController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              action == "save"
                  ? TextFormField(
                      decoration: InputDecoration(hintText: 'phone number'),
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                    )
                  : Container(),
              DropdownButton(
                value: action,
                items: [
                  DropdownMenuItem(
                    value: 'save',
                    child: Text('save'),
                  ),
                  DropdownMenuItem(
                    value: 'delete',
                    child: Text('delete'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    action = value;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: RaisedButton(
                  onPressed: () async {
                    print(action);

                    if (action == 'delete') {
                      String name = nameController.text;
                      int id = await db.getId(name);
                      if (id == null) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content:
                                Text('No contact named $name has been added')));
                      } else {
                        print(id);
                        await db.deleteContact(id);
                      }
                    } else {
                      Contact contact = Contact(
                          name: nameController.text,
                          phone: int.parse(phoneController.text),
                          image: image);
                      await db.insertContact(contact);
                      print(contact);
                      print(image);
                    }
                    nameController.text = "";
                    phoneController.text = "";
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('Contact has been $action')));

                    print(await db.contacts());
                  },
                  child: Text(action),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: action == "save"
                    ? RaisedButton(
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
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('Picture has been taken')));
                          print(image.toString());
                        },
                        child: Text('Take picture'),
                      )
                    : Container(),
              )
            ],
          ),
        ) // Build this out in the next steps.
        );
  }
}
