import 'package:flutter/material.dart';
import 'package:kevin_app/ContactDb.dart';
import 'dart:async';
import 'dart:io';

import 'package:kevin_app/appSettings.dart';

final ContactDb _db = ContactDb();

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
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content:
                              Text('All your contacts have been deleted')));
                    })
              ],
            );
          });
    }

    // void _completeMessage(String message) {
    //   showDialog(
    //       context: context,
    //       builder: (BuildContext context) {
    //         return AlertDialog(
    //           title: Text(message),
    //           actions: <Widget>[
    //             FlatButton(
    //                 child: Text('close'),
    //                 onPressed: () {
    //                   // Navigator.of(context).pop();
    //                   Navigator.popUntil(context, ModalRoute.withName('/'));
    //                 })
    //           ],
    //         );
    //       });
    // }

    _deleteContacts() async {
      _warningMessage('Are you sure you want to delete all your contacts');
      // _completeMessage('All your contacts have been deleted');
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
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: _deleteContacts,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
