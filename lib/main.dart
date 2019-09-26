import 'package:flutter/material.dart';
import 'package:kevin_app/activity/Settings.dart';

import 'activity/ContactList.dart';
import 'package:kevin_app/activity/contactActivity.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'apikeys.dart';
import 'appSettings.dart';
import 'myThemes.dart';

import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs;
void main() async {
  prefs = await SharedPreferences.getInstance();

  Admob.initialize(getAppId());
  runApp(MyApp());
}

String getAppId() {
  return apikeys["ca-app-pub-7306861253247220~8235596983"];
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Brightness brightness;
  bool cameraActive;
  MyThemeKeys themekey;
  ThemeData theme;
  int themekeyIndex;
  int contactsListLength;

  @override
  void initState() {
    themekeyIndex = (prefs.getInt('themeKey') ?? 0);
    themekey = MyThemeKeys.values[themekeyIndex];
    brightness = Brightness.light;
    cameraActive = true;
    contactsListLength = 0;
    theme = MyThemes.getThemeFromKey(themekey);
    super.initState();
  }

  callback({camera, theme, themeKey}) {
    setState(() {
      if (camera != null) {
        this.cameraActive = camera;
      } else {
        this.themekey = themeKey;
        this.theme = MyThemes.getThemeFromKey(themekey);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppSettings(
        callback: callback,
        theme: theme,
        camera: cameraActive,
        themeKey: themekey,
        child: _Home());
  }
}

class _Home extends StatefulWidget {
  final List<Widget> _activities = [
    ContactActivity(),
    ContactList(),
    Settings()
  ];

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<_Home> {
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyContacts',
      debugShowCheckedModeBanner: false,
      theme: AppSettings.of(context).theme,
      home: Scaffold(
          body: widget._activities[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: onTabTapped,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), title: Text('home')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.contacts), title: Text('contactList')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), title: Text('settings')),
              ])),
    );
  }
}
