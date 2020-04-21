import 'package:flutter/material.dart';
import 'package:kevin_app/components/contactImageFull.dart';
import 'package:kevin_app/utils/colors.dart';
import 'package:scidart/numdart.dart';
import 'package:kevin_app/appSettings.dart';
import 'package:kevin_app/components/contactImage.dart';
import 'package:kevin_app/utils/utils.dart';

import 'package:kevin_app/contact.dart';
import 'package:kevin_app/ContactDb.dart';
import 'package:kevin_app/utils/admobUtils.dart';

import '../myThemes.dart';

class ContactEdit extends StatefulWidget {
  final Contact contact;
  final Function callback;
  final List<String> category = <String>[
    "general",
    "family",
    "friend",
    "coworker"
  ];
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
  Contact contact;
  int favorite;
  Future<List<Contact>> contacts;

  String dropdownValue;

  callback({String name, String phone, String email, int favorite}) {
    setState(() {
      this.name = name;
      this.phone = phone;
      this.email = email;
      this.favorite = favorite;
    });
  }

  Widget _dropDown() {
    return DropdownButton(
      value: contact.category,
      icon: Icon(Icons.arrow_drop_down),
      items: widget.category.map<DropdownMenuItem<String>>((String value) {
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
    _showMessage('contact information changed');
    widget.callback(contacts);
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
                  child: Text(
                    'close',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  onPressed: () {
                    // Navigator.of(context).pop();
                    Navigator.popUntil(context, ModalRoute.withName('/'));
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
                        hintText: translatedText("hintText_phone", context),
                        icon: Icon(Icons.phone)),
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
                        'group',
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
      Padding(
        padding: const EdgeInsets.only(top: 0),
        child: RaisedButton(
          color: Theme.of(context).primaryColor,
          onPressed: () async {
            _updateContact(contact);
          },
          child: Text(
            translatedText("button_save", context),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      SizedBox(
        width: 20,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 5),
        child: RaisedButton(
          color: Theme.of(context).primaryColor,
          child: Text(
            translatedText("button_delete", context),
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            await _deleteContact(contact);
          },
        ),
      )
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buttons,
    );
  }

  Widget _buildPreviewText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // _buildText(this.name, orientation),
        _buildBoldText(this.name),
        _buildText(this.phone),
        Padding(
          padding: EdgeInsets.only(bottom: 0),
          child: _buildText(this.email),
        ),
      ],
    );
  }

  Widget _buildText(String text) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 22),
      ),
    );
  }

  Widget _buildBoldText(String text) {
    AppSettings appState = AppSettings.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      width: MediaQuery.of(context).size.width * 0.8,
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

  @override
  Widget build(BuildContext context) {
    // contact = ModalRoute.of(context).settings.arguments;
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(translatedText("app_title_contactEdit", context)),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              AdmobUtils.admobBanner(),
              // _buildPreviewText(),
              Container(
                padding: EdgeInsets.only(top: 5),
                child: Container(
                  // padding: EdgeInsets.symmetric(vertical: 40),
                  child: ContactImageFull(
                    image: contact.image,
                  ),
                ),
              ),
              _buildForm(),
            ],
          )
        ],
      ),
    );
  }
}
