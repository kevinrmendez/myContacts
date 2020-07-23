import 'package:flutter/material.dart';
import 'package:kevin_app/app_localizations.dart';
import 'package:contacts_service/contacts_service.dart' as a;
import 'package:kevin_app/models/contact.dart';

import 'package:kevin_app/main.dart';
import 'package:kevin_app/state/appState.dart';
import 'package:kevin_app/utils/widgetUitls.dart';

String translatedText(text, BuildContext context) {
  return AppLocalizations.of(context).translate(text);
}

_importContactsFromService() async {
  Iterable<a.Contact> contacts = await a.ContactsService.getContacts();
  contacts.map((value) {});

  return contacts;
}

importContacts(BuildContext context) {
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
        Contact newContact =
            Contact(name: name, email: email, phone: phone, category: category);

        db.insertContact(newContact);

        contactService.add(newContact);
      }
    });
  }).then((onValue) {
    print(onValue);

    // setState(() {
    //   importedContacts = true;
    //   prefs.setBool('importedContacts', importedContacts);
    //   importedContactsProgress = false;
    // });
    // scaffoldKey.currentState.showSnackBar(
    //     snackBar(translatedText("snackbar_contact_import", context)));
    Navigator.pop(context);
  }).catchError((e) {
    print('ERROR');
    print(e);
  });
}
