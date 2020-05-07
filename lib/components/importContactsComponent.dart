import 'package:flutter/material.dart';
import 'package:kevin_app/contact.dart';
import 'package:kevin_app/main.dart';
import 'package:kevin_app/state/appSettings.dart';
import 'package:contacts_service/contacts_service.dart' as a;
import 'package:kevin_app/state/appState.dart';
import 'package:kevin_app/utils/utils.dart';
import 'package:kevin_app/utils/widgetUitls.dart';

class ImportContactsComponent extends StatefulWidget {
  @override
  _ImportContactsComponentState createState() =>
      _ImportContactsComponentState();
}

class _ImportContactsComponentState extends State<ImportContactsComponent> {
  bool isContactedImported;

  _buildButton({String title, Function onPressed}) {
    return Container(
      width: 200,
      child: RaisedButton(
          elevation: 10,
          color: Colors.white,
          child: Text(
            title,
            style: TextStyle(color: Colors.blue, fontSize: 22),
          ),
          onPressed: onPressed),
    );
  }

  _importContactsFromService() async {
    Iterable<a.Contact> contacts = await a.ContactsService.getContacts();
    contacts.map((value) {});

    return contacts;
  }

  _importContacts() {
    print('CONTACTS');
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => WidgetUtils.dialog(
            title: translatedText("dialog_title_importing", context),
            context: context,
            height: MediaQuery.of(context).size.height * .35,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * .8,
                  child: Text(
                    translatedText(
                      "dialog_description_importing",
                      context,
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,

                      // fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  constraints: BoxConstraints(maxHeight: 30, maxWidth: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator()),
                    ],
                  ),
                ),
              ],
            )));

    _importContactsFromService().then((contacts) {
      // setState(() {
      //   importedContactsProgress = true;
      // });

      List contactList = contacts.toList();
      contactList.forEach((contact) {
        List phones = contact.phones.toList();
        List emails = contact.emails.toList();
        String email = emails.length > 0 ? emails[0].value : "";
        String phone = phones.length > 0 ? phones[0].value : "";
        String name = contact.displayName == null || contact.displayName == ""
            ? translatedText("text_empty_name", context)
            : contact.displayName;
        String category = translatedText("group_default", context);

        if (contact != null) {
          Contact newContact = Contact(
              name: name, email: email, phone: phone, category: category);

          db.insertContact(newContact);

          print(email);
          print(contact.displayName);
          print(phone);
          print(category);
          contactService.add(newContact);
        }
      });
    }).then((onValue) {
      print(onValue);
      setState(() {
        // importedContacts = true;
        // prefs.setBool('importedContacts', importedContacts);
        // importedContactsProgress = false;
        isContactedImported = true;
      });
      // _scaffoldKey.currentState.showSnackBar(
      //     snackBar(translatedText("snackbar_contact_import", context)));
      Navigator.pop(context);
    }).catchError((e) {
      print('ERROR');
      print(e);
      isContactedImported = false;
    });
  }

  @override
  void initState() {
    super.initState();
    isContactedImported = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Welcome to",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40),
        ),
        Text(
          "MyContacts",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/person-icon-w-s3p.png'))),
          ),
        ),
        // CircularProgressIndicator(backgroundColor: Colors.white),
        Column(
          children: <Widget>[
            isContactedImported
                ? Container(
                    width: MediaQuery.of(context).size.width * .7,
                    child: Column(children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text(
                          "Your contacts have been imported",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              // fontWeight: FontWeight.bold,
                              fontSize: 28),
                        ),
                      ),
                      _buildButton(
                        title: "continue",
                        onPressed: () async {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => Home()),
                              (Route<dynamic> route) => false);
                          AppSettings.of(context)
                              .callback(showSetupScreen: false);
                          prefs.setBool('showSetupScreen', false);
                        },
                      )
                    ]),
                  )
                : _buildButton(
                    title: "import Contacts",
                    onPressed: () {
                      _importContacts();
                      //TODO: change state after contacts
                      // Future.delayed(const Duration(milliseconds: 700), () {
                      //   setState(() {
                      //     isContactedImported = true;
                      //   });
                      //   // Scaffold.of(context).showSnackBar(widget.snackBar);

                      //   // _requestPermissions();
                      // });
                    },
                  ),
            isContactedImported
                ? SizedBox()
                : _buildButton(
                    title: "skip",
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                          (Route<dynamic> route) => true);
                      AppSettings.of(context).callback(showSetupScreen: false);
                      prefs.setBool('showSetupScreen', true);

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => Home()),
                      // );
                    },
                  ),
          ],
        )
      ],
    );
  }
}
