import 'package:flutter/material.dart';
import 'package:kevin_app/activity/Settings.dart';

import 'activity/ContactList.dart';
import 'package:kevin_app/activity/contactActivity.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'apikeys.dart';
import 'appSettings.dart';
import 'myThemes.dart';

void main() {
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
  bool darkModeActive;
  MyThemeKeys themekey;
  ThemeData theme;
  // This widget is the root of your application.

  @override
  void initState() {
    themekey = MyThemeKeys.BLUE;
    brightness = Brightness.light;
    darkModeActive = false;
    cameraActive = true;
    theme = ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        brightness: Brightness.light);
    super.initState();
  }

  callback({brightness, darkMode, camera, theme, themeKey}) {
    setState(() {
      if (brightness != null) {
        this.brightness = brightness;
        this.darkModeActive = darkMode;
      } else if (camera != null) {
        this.cameraActive = camera;
      } else {
        this.theme = theme;
        this.themekey = themeKey;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppSettings(
        brightness: brightness,
        callback: callback,
        theme: theme,
        camera: cameraActive,
        darkMode: darkModeActive,
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
  // This widget is the root of your application.

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Contacts',
      // theme: ThemeData(
      //   brightness: AppSettings.of(context).brightness,
      //   primarySwatch: Colors.blue,
      // ),
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
