import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kevin_app/ContactDb.dart';
import 'package:kevin_app/components/expandableExportSettings.dart';
import 'package:kevin_app/components/expandableThemeSettings.dart';
import 'package:kevin_app/contact.dart';
import 'package:kevin_app/main.dart';

import 'dart:async';

import 'package:permission_handler/permission_handler.dart';

import 'package:contacts_service/contacts_service.dart' as a;
import 'package:kevin_app/ContactDb.dart';

import 'package:kevin_app/appSettings.dart';
import 'package:url_launcher/url_launcher.dart';

import 'aboutActivity .dart';

final ContactDb _db = ContactDb();
final snackBar = (text) => SnackBar(content: Text(text));

class Settings extends StatefulWidget {
  final PermissionHandler _permissionHandler = PermissionHandler();

  Future<bool> _requestContactPermission() async {
    var result =
        await _permissionHandler.requestPermissions([PermissionGroup.contacts]);

    if (result[PermissionGroup.contacts] == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  @override
  SettingsState createState() {
    return SettingsState();
  }
}

class SettingsState extends State<Settings> {
  bool importedContacts;
  bool importedContactsProgress;
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
    importedContacts = (prefs.getBool('importedContacts') ?? false);
    importedContactsProgress = false;
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
              title: Text(
                message,
              ),
              actions: <Widget>[
                FlatButton(
                    child: Text(
                      'close',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    onPressed: () {
                      // Navigator.of(context).pop();
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    }),
                FlatButton(
                    child: Text(
                      'ok',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
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
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'importing contacts...',
              ),
              content: Container(
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
            );
          });

      _importContactsFromService().then((contacts) {
        setState(() {
          importedContactsProgress = true;
        });

        List contactList = contacts.toList();
        contactList.forEach((contact) {
          List phones = contact.phones.toList();
          List emails = contact.emails.toList();
          String email = emails.length > 0 ? emails[0].value : "";
          String phone = phones.length > 0 ? phones[0].value : "";
          String name = contact.displayName;

          if (contact != null) {
            Contact newContact =
                Contact(name: name, email: email, phone: phone);

            db.insertContact(newContact);

            print(email);
            print(contact.displayName);
            print(phone);
          }
        });
      }).then((onValue) {
        setState(() {
          importedContacts = true;
          prefs.setBool('importedContacts', importedContacts);
          importedContactsProgress = false;
        });
        _scaffoldKey.currentState.showSnackBar(
            snackBar('All your contacts from your phone have been imported!'));
        Navigator.pop(context);
      }).catchError((e) {
        print('ERROR');
        print(e);
      });
    }

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
                  ListTile(
                    title: Text('Ad-Free'),
                    onTap: () async {
                      String url =
                          "https://play.google.com/store/apps/details?id=com.kevinrmendez.bad_jokes";
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    trailing: Icon(Icons.remove_circle),
                  ),
                  ListTile(
                    title: Text('Delete contacts'),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                  'Are you sure you want to delete all your contacts?'),
                              actions: <Widget>[
                                FlatButton(
                                    child: Text(
                                      'close',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    onPressed: () {
                                      // Navigator.of(context).pop();
                                      Navigator.popUntil(
                                          context, ModalRoute.withName('/'));
                                    }),
                                FlatButton(
                                    child: Text(
                                      'ok',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
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
                  ListTile(
                    title: Text('Delete duplicate contacts'),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                  'Are you sure you want to delete all your contacts duplicates?'),
                              actions: <Widget>[
                                FlatButton(
                                    child: Text(
                                      'close',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    onPressed: () {
                                      // Navigator.of(context).pop();
                                      Navigator.popUntil(
                                          context, ModalRoute.withName('/'));
                                    }),
                                FlatButton(
                                    child: Text(
                                      'ok',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    onPressed: () async {
                                      // bool isDataDeleted =
                                      await _db.deleteDuplicateContacts();
                                      // if (isDataDeleted) {
                                      //   _scaffoldKey.currentState.showSnackBar(
                                      //       snackBar(
                                      //           'All your contacts have been deleted!'));
                                      //   setState(() {
                                      //     importedContacts = false;
                                      //     prefs.setBool('importedContacts',
                                      //         importedContacts);
                                      //   });
                                      // }
                                      _scaffoldKey.currentState.showSnackBar(
                                          snackBar(
                                              'All your contacts duplicate have been deleted!'));

                                      Navigator.pop(context);
                                    })
                              ],
                            );
                          });
                    },
                    trailing: Icon(Icons.content_cut),
                  ),
                  importedContacts == false
                      ? ListTile(
                          title: Text('Import contacts'),
                          onTap: () async {
                            var permissionStatus = await widget
                                ._permissionHandler
                                .checkPermissionStatus(
                                    PermissionGroup.contacts);

                            if (permissionStatus == PermissionStatus.granted) {
                              _importContacts();
                            } else {
                              widget._requestContactPermission();
                            }
                          },
                          trailing: Icon(Icons.import_contacts),
                        )
                      : const SizedBox(),
                  ExpandableExportSettings(),
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
