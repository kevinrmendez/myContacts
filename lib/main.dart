import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kevin_app/utils/admobUtils.dart';
import 'package:url_launcher/url_launcher.dart';

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
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

  Admob.initialize(getAppId());
  runApp(MyApp());
}

String getAppId() {
  return apikeys["appId"];
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

  @override
  void initState() {
    themekeyIndex = (prefs.getInt('themeKey') ?? 0);
    themekey = MyThemeKeys.values[themekeyIndex];
    brightness = Brightness.light;
    cameraActive = true;
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

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
              'Do you want to close the app?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: new Text(
                'Please share us your feedback before leaving the app, we would love hearing from you'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
              FlatButton(
                onPressed: () async {
                  // Navigator.of(context).pop(false);
                  String url =
                      "https://play.google.com/store/apps/details?id=com.kevinrmendez.contact_app";
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: new Text('review app'),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'MyContacts',
      debugShowCheckedModeBanner: false,
      theme: AppSettings.of(context).theme,
      home: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            body: widget._activities[_currentIndex],
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.shifting,
                selectedItemColor: Theme.of(context).primaryColor,
                unselectedItemColor: Colors.grey,
                selectedLabelStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
                unselectedLabelStyle: TextStyle(
                  color: Colors.grey,
                ),
                showUnselectedLabels: true,
                currentIndex: _currentIndex,
                onTap: onTabTapped,
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.home,
                        // color: Theme.of(context).primaryColor,
                      ),
                      title: Text(
                        'home',
                        // style: TextStyle(color: Colors.grey),
                      )),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.contacts), title: Text('contactList')),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.favorite), title: Text('favorite')),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings), title: Text('settings')),
                ])),
      ),
    );
  }
}
