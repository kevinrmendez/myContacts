import 'package:flutter/material.dart';
import 'package:kevin_app/ContactDb.dart';
import 'package:kevin_app/components/expandableThemeSettings.dart';
import 'package:kevin_app/contact.dart';
import 'package:kevin_app/main.dart';
import 'package:kevin_app/myThemes.dart';
import 'dart:async';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

import 'package:contacts_service/contacts_service.dart' as a;
import 'package:kevin_app/ContactDb.dart';

import 'package:kevin_app/appSettings.dart';

import 'aboutActivity .dart';

final ContactDb _db = ContactDb();
final snackBar = (text) => SnackBar(content: Text(text));

PermissionStatus _permissionStatus;

class Settings extends StatefulWidget {
  @override
  SettingsState createState() {
    return SettingsState();
  }
}

class SettingsState extends State<Settings> {
  bool changeTheme;
  bool activateCamera;
  bool importedContacts;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final ContactDb db = ContactDb();
  // ThemeData _theme;
  // MyThemeKeys themekey;
  // bool isExpanded;

  // Future<int> themekeyprefs;

  // Future<Null> getSharePreferences() async {
  //   prefs = await SharedPreferences.getInstance();
  // }

  @override
  void initState() {
    changeTheme = false;
    activateCamera = true;
    importedContacts = (prefs.getBool('importedContacts') ?? false);
    // isExpanded = false;
    super.initState();
    // Prefs.init();
    // getSharePreferences();
    // themekeyprefs = Prefs.getIntF('themekey') ?? 0;
    // themekey = MyThemeKeys.values[themekeyprefs];
  }

  @override
  Widget build(BuildContext context) {
    //WARNING MESSAGE BEFORE DELETING CONTACTS
    void _warningMessage(String message) {
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
                    }),
                FlatButton(
                    child: Text('ok'),
                    onPressed: () async {
                      await _db.deleteAllContacts();

                      Navigator.pop(context);
                    })
              ],
            );
          });
    }

    _deleteContacts() async {
      _warningMessage('Are you sure you want to delete all your contacts');
    }

    Future<PermissionStatus> _checkPermission() async {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.contacts);
      return permission;
    }

    _requestPermission() async {
      // await PermissionHandler()
      //     .shouldShowRequestPermissionRationale(PermissionGroup.contacts);
      // await PermissionHandler().openAppSettings();
      _permissionStatus = await _checkPermission();
      if (_permissionStatus != PermissionStatus.granted) {
        return await PermissionHandler()
            .requestPermissions([PermissionGroup.contacts]);
      }
    }

    _importContactsFromService() async {
      Iterable<a.Contact> contacts = await a.ContactsService.getContacts();
      contacts.map((value) {});

      return contacts;
    }

    _importContacts() {
      print('CONTACTS');
      _requestPermission().then((value) {
        _importContactsFromService().then((contacts) {
          List contactList = contacts.toList();
          contactList.forEach((contact) {
            List phones = contact.phones.toList();
            List emails = contact.emails.toList();
            String email = emails.length > 0 ? emails[0].value : "";
            String phone = phones.length > 0 ? phones[0].value : "";
            String name = contact.displayName;

            Contact newContact =
                Contact(name: name, email: email, phone: phone);

            db.insertContact(newContact);

            print(email);
            print(contact.displayName);
            print(phone);
            // print(phone);
          });
          // contactList.map((contact) {
          //   if (contact == null) {
          //     print('NULL');
          //   } else {
          //     print(contact.toString());
          //   }
          // });
        }).then((onValue) {
          _scaffoldKey.currentState.showSnackBar(snackBar(
              'All your contacts from your phone have been imported!'));
          setState(() {
            importedContacts = true;
            prefs.setBool('importedContacts', importedContacts);
          });
        });
      });
    }

    AppSettings appState = AppSettings.of(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Builder(
        builder: (context) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text('About'),
                    trailing: IconButton(
                      icon: Icon(Icons.info),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AboutActivity()),
                        );
                      },
                    ),
                  ),
                  // SwitchListTile(
                  //   value: appState.darkMode,
                  //   title: Text('dark mode'),
                  //   onChanged: (value) {
                  //     setState(() {
                  //       changeTheme = value;
                  //       if (value == false) {
                  //         // widget.onChangeTheme(Brightness.light);

                  //         AppSettings.of(context).callback(
                  //             brightness: Brightness.light, darkMode: value);
                  //       } else {
                  //         AppSettings.of(context).callback(
                  //             brightness: Brightness.dark, darkMode: value);

                  //         // widget.onChangeTheme(Brightness.dark);
                  //       }
                  //     });

                  //     print(value);
                  //   },
                  // ),
                  SwitchListTile(
                    value: appState.camera,
                    title: Text('camera'),
                    onChanged: (value) {
                      setState(() {
                        activateCamera = value;
                        AppSettings.of(context).callback(camera: value);
                      });
                    },
                  ),
                  ListTile(
                    title: Text('delete contacts'),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                  'Are you sure you want to delete all your contacts'),
                              actions: <Widget>[
                                FlatButton(
                                    child: Text('close'),
                                    onPressed: () {
                                      // Navigator.of(context).pop();
                                      Navigator.popUntil(
                                          context, ModalRoute.withName('/'));
                                    }),
                                FlatButton(
                                    child: Text('ok'),
                                    onPressed: () async {
                                      bool isDataDeleted =
                                          await _db.deleteAllContacts();
                                      if (isDataDeleted) {
                                        _scaffoldKey.currentState.showSnackBar(
                                            snackBar(
                                                'All your contacts have been deleted!'));
                                        setState(() {
                                          importedContacts = false;
                                          prefs.setBool('importedContacts',
                                              importedContacts);
                                        });
                                      }

                                      Navigator.pop(context);
                                    })
                              ],
                            );
                          });
                    },
                    trailing: Icon(Icons.delete),
                  ),
                  importedContacts == false
                      ? ListTile(
                          title: Text('import contacts'),
                          onTap: () async {
                            _importContacts();
                          },
                          trailing: Icon(Icons.import_contacts),
                        )
                      : const SizedBox(),
                  ExpandableThemeSettings(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
