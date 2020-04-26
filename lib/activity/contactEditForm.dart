import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kevin_app/activity/ContactList2.dart';
import 'package:kevin_app/activity/Settings.dart';
import 'package:kevin_app/main.dart';
import 'package:kevin_app/state/appSettings.dart';
import 'package:kevin_app/state/appState.dart';
import 'package:kevin_app/utils/colors.dart';
import 'package:kevin_app/utils/widgetUitls.dart';
import 'package:scidart/numdart.dart';
import 'package:kevin_app/components/contactImage.dart';
import 'package:kevin_app/utils/utils.dart';
import 'package:share/share.dart';

import 'package:kevin_app/contact.dart';
import 'package:kevin_app/ContactDb.dart';
import 'package:kevin_app/utils/admobUtils.dart';

class ContactEditForm extends StatefulWidget {
  final BuildContext context;
  final Contact contact;
  final int index;
  final List<String> category = <String>[
    "general",
    "family",
    "friend",
    "coworker"
  ];
  ContactEditForm({@required this.contact, this.context, this.index});

  @override
  ContactEditFormState createState() {
    return ContactEditFormState();
  }
}

class ContactEditFormState extends State<ContactEditForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  List<String> category;

  final ContactDb db = ContactDb();
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final instagramController = TextEditingController();

  String name;
  String phone;
  String email;
  Contact contact;
  int favorite;
  Future<List<Contact>> contacts;

  String dropdownValue;

  Widget _dropDown() {
    return DropdownButton(
      value: dropdownValue,
      icon: Icon(Icons.arrow_drop_down),
      items: category.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(color: GREY),
          ),
        );
      }).toList(),
      onChanged: (String value) {
        setState(() {
          dropdownValue = value;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    this.contact = widget.contact;
    this.name = widget.contact.name;
    this.phone = widget.contact.phone.toString();
    this.email = widget.contact.email;
    this.favorite = widget.contact.favorite;

    this.nameController.text = this.name;
    this.phoneController.text = this.phone;
    this.emailController.text = this.email;

    this.contact = widget.contact;

    category = <String>[
      translatedText("group_default", widget.context),
      translatedText("group_family", widget.context),
      translatedText("group_friend", widget.context),
      translatedText("group_coworker", widget.context),
    ];
    dropdownValue = contact.category;
  }

  Future<void> _updateContact(Contact contact) async {
    contact.name = nameController.text;
    contact.phone = phoneController.text;
    contact.email = emailController.text;
    contact.favorite = this.favorite;
    contact.category = this.dropdownValue;

    // print('after update id');
    // print(contact);
    await db.updateContact(contact);

    contacts = db.contacts();
    List contactsDb = await db.contacts();

    contactService.updateContacts(contactsDb);
    _showMessage(translatedText("message_dialog_change_contact", context));
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

    _showMessage(translatedText("message_dialog_contact_deleted", context));
  }

  void _showMessage(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(message),
            actions: <Widget>[
              FlatButton(
                  child: Text(
                    translatedText("button_close", context),
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Home()),
                      (Route<dynamic> route) => false,
                    );
                  })
            ],
          );
        });
  }

  Widget _buildForm() {
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
                        hintText: translatedText("hintText_name", context),
                        icon: Icon(Icons.person)),
                    controller: nameController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return translatedText(
                            "hintText_name_verification", context);
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
                        hintText: translatedText("hintText_phone", context),
                        icon: Icon(Icons.phone)),
                    validator: (value) {
                      if (value.isEmpty) {
                        return translatedText(
                            "hintText_phone_verification", context);
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
                        hintText: translatedText("hintText_email", context),
                        icon: Icon(Icons.email)),
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.group,
                        color: GREY,
                        size: 25,
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        translatedText("hintText_group", context),
                        style: TextStyle(
                          color: GREY,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      _dropDown()
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.star,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        translatedText("hintText_favorite", context),
                        style: TextStyle(color: Colors.grey),
                      ),
                      Switch(
                        onChanged: (bool value) {
                          this.favorite = boolToInt(value);
                        },
                        value: intToBool(this.favorite),
                        // value: false,
                      ),
                    ],
                  ),
                  _buildFormButtons()
                ],
              ),
            ) // Build this out in the next steps.
            ),
      ],
    );
  }

  Widget _buildFormButtons() {
    List<Widget> _buttons = [
      RaisedButton(
        color: Theme.of(context).primaryColor,
        onPressed: () async {
          _updateContact(contact);
        },
        child: Text(
          translatedText("button_save", context),
          style: TextStyle(color: Colors.white),
        ),
      ),
      SizedBox(
        width: 20,
      ),
      RaisedButton(
        color: Theme.of(context).primaryColor,
        child: Text(
          translatedText("button_delete", context),
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          await _deleteContact(contact);
          contactService.remove(contact);
        },
      ),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buttons,
    );
  }

  Widget _buildPreviewText() {
    return _buildBoldText(this.name);
  }

  Widget _buildBoldText(String text) {
    return Container(
      padding: EdgeInsets.only(bottom: 15),
      width: MediaQuery.of(context).size.width * 0.8,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor),
      ),
    );
  }

  Widget _buildShareButton() {
    return Container(
      width: 100,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        child: Icon(
          Icons.share,
          color: Colors.white,
        ),
        onPressed: () {
          Share.share(
              "Contact Details: name: ${contact.name}, phone: ${contact.phone}, email: ${contact.phone}");
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // contact = ModalRoute.of(context).settings.arguments;
    // Build a Form widget using the _formKey created above.
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
              vertical:
                  widget.contact.image == null || widget.contact.image == ""
                      ? 15
                      : 5),
          child: Column(
            children: <Widget>[
              _buildPreviewText(),
              Hero(
                child: CircleAvatar(
                  radius:
                      widget.contact.image == null || widget.contact.image == ""
                          ? MediaQuery.of(context).size.width * .17
                          : MediaQuery.of(context).size.width * .3,
                  backgroundColor: Theme.of(context).primaryColor,
                  backgroundImage:
                      widget.contact.image == "" || widget.contact.image == null
                          ? AssetImage('assets/person-icon-w-s3p.png')
                          : FileImage(File(widget.contact.image)),
                ),
                tag: widget.contact.name + widget.index.toString(),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            contact.phone != ""
                ? WidgetUtils.urlButtons(
                    color: Theme.of(context).primaryColor,
                    url: "tel:${contact.phone.toString()}",
                    icon: Icon(
                      Icons.phone,
                      color: Colors.white,
                    ))
                : const SizedBox(),
            contact.email != ""
                ? WidgetUtils.urlButtons(
                    color: Theme.of(context).primaryColor,
                    url: 'mailto:${contact.email}',
                    icon: Icon(
                      Icons.email,
                      color: Colors.white,
                    ))
                : const SizedBox(),
            _buildShareButton()
          ],
        ),
        _buildForm(),
        SizedBox(
          height: 30,
        )
      ],
    );
  }
}
