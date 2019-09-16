import 'package:flutter/material.dart';
import 'package:kevin_app/ContactDb.dart';
import 'dart:async';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

import 'package:contacts_service/contacts_service.dart';

import 'package:kevin_app/appSettings.dart';

import 'aboutActivity .dart';

final ContactDb _db = ContactDb();

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

  @override
  void initState() {
    changeTheme = false;
    activateCamera = true;
    super.initState();
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

    _importContacts() async {
      Iterable<Contact> contacts = await ContactsService.getContacts();
      return contacts;
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

    AppSettings appState = AppSettings.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
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
                SwitchListTile(
                  value: appState.darkMode,
                  title: Text('dark mode'),
                  onChanged: (value) {
                    setState(() {
                      changeTheme = value;
                      if (value == false) {
                        // widget.onChangeTheme(Brightness.light);

                        AppSettings.of(context).callback(
                            brightness: Brightness.light, darkMode: value);
                      } else {
                        AppSettings.of(context).callback(
                            brightness: Brightness.dark, darkMode: value);

                        // widget.onChangeTheme(Brightness.dark);
                      }
                    });

                    print(value);
                  },
                ),
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
                    _deleteContacts();
                  },
                  trailing: Icon(Icons.delete),
                ),
                // ListTile(
                //   title: Text('import contacts'),
                //   onTap: () async {
                // if (_permissionStatus == null) {
                //   _permissionStatus = await _checkPermission();
                // } else {
                //   if (_permissionStatus == PermissionStatus.granted) {
                //     _importContacts();
                //   } else {
                //     _requestPermission();
                //   }
                // }
                // _requestPermission().then((value) {
                //   _importContacts().then((contacts) {
                //     // print(contacts);
                //     contacts.map((contact) {
                //       if (contact == null) {
                //         print('NULL');
                //       } else {
                //         print(contact.toString());
                //       }
                //     });
                //   });
                // });
                //   },
                //   trailing: Icon(Icons.delete),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
