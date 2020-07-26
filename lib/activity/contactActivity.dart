import 'package:flutter/material.dart';
import 'package:kevin_app/bloc/group_service.dart';
import 'package:kevin_app/components/contactImage.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:kevin_app/components/group_dropdown.dart';
import 'package:kevin_app/main.dart';
import 'package:kevin_app/models/contact.dart';
import 'package:kevin_app/models/group.dart';

import 'package:kevin_app/state/appState.dart';
import 'package:kevin_app/utils/colors.dart';
import 'package:kevin_app/utils/utils.dart';
import 'package:kevin_app/utils/widgetUitls.dart';

class ContactActivity extends StatefulWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  ContactActivityState createState() => ContactActivityState();
}

class ContactActivityState extends State<ContactActivity>
    with WidgetsBindingObserver {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  List<String> category;

  String action = "save";
  String name;
  String phone;
  String email;
  int contactId;
  Group dropdownValue;
  String image = "";

  AppLifecycleState appState;
  AppLifecycleState appLifecycleState;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  callbackDropDown(value) {
    setState(() {
      dropdownValue = value;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState appLifecycleState) {
    appState = appLifecycleState;
    print(appLifecycleState);
  }

  Future<void> _saveContact(Contact contact) async {
    await db.insertContact(contact);

    Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(translatedText("snackbar_contact_save", context))));
    _resetFormFields();
    // contactId++;
  }

  void _resetFormFields() {
    nameController.text = "";
    phoneController.text = "";
    emailController.text = "";

    image = "";
    setState(() {
      dropdownValue = null;
    });
  }

  callback(value) {
    setState(() {
      image = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      body: Center(
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                ContactImage(
                  image: image,
                ),
                Positioned(
                  bottom: 3,
                  child: WidgetUtils.buildCamera(image, context, callback),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Align(
                alignment: Alignment.center,
                child: Form(
                    key: widget._formKey,
                    child: Container(
                      width: 250,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                                hintText:
                                    translatedText("hintText_name", context),
                                icon: Icon(
                                  Icons.person,
                                  color: DarkGreyColor,
                                )),
                            controller: nameController,
                            onChanged: (value) {
                              name = value;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return translatedText(
                                    "hintText_name_verification", context);
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                hintText:
                                    translatedText("hintText_phone", context),
                                icon: Icon(
                                  Icons.phone,
                                  color: DarkGreyColor,
                                )),
                            keyboardType: TextInputType.phone,
                            controller: phoneController,
                            onChanged: (value) {
                              phone = value;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                hintText:
                                    translatedText("hintText_email", context),
                                icon: Icon(
                                  Icons.email,
                                  color: DarkGreyColor,
                                )),
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            onChanged: (value) {
                              email = value;
                            },
                          ),
                          GroupDropDown(
                            dropDownValue: dropdownValue,
                            callback: callbackDropDown,
                          ),
                          Container(
                            // padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                WidgetUtils.textButton(
                                    context: context,
                                    title:
                                        translatedText("button_save", context),
                                    onPress: () async {
                                      if (widget._formKey.currentState
                                          .validate()) {
                                        // String name = nameController.text;
                                        String formattedName =
                                            '${name[0].toUpperCase()}${name.substring(1)}';
                                        Contact contact = Contact(
                                            // id: contactId,
                                            name: formattedName,
                                            phone: phone,
                                            email: email,
                                            category: dropdownValue == null
                                                ? ""
                                                : dropdownValue.name,
                                            image: image);
                                        _saveContact(contact);
                                        print("CONTACTID: ${contact.id}");
                                        contactService.add(contact);
                                        // widget.callback("");
                                      }
                                      // print(await db.contacts());
                                    })
                              ],
                            ),
                          ),
                        ],
                      ),
                    ) // Build this out in the next steps.
                    )),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
