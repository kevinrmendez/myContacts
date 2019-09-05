import 'package:flutter/material.dart';
import 'package:kevin_app/ContactDb.dart';
import 'dart:async';
import 'dart:io';

import 'package:kevin_app/appSettings.dart';

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
    AppSettings appState = AppSettings.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 30,
          ),
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
