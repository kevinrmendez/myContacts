import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kevin_app/activity/ContactList2.dart';
import 'package:kevin_app/activity/FavoriteContactList.dart';
import 'package:kevin_app/activity/GroupActivity.dart';
import 'package:kevin_app/contact.dart';
import 'package:kevin_app/contactDb.dart';
import 'package:kevin_app/state/appSettings.dart';
import 'package:kevin_app/state/appState.dart';
import 'package:kevin_app/utils/admobUtils.dart';
import 'package:kevin_app/utils/myThemes.dart';
import 'package:kevin_app/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:kevin_app/activity/Settings.dart';

import 'package:kevin_app/activity/contactActivity.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'activity/ContactList.dart';
import 'apikeys.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

ContactDb db = ContactDb();
List<Contact> contactsfromDb;

SharedPreferences prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  prefs = await SharedPreferences.getInstance();
  contactsfromDb = await db.contacts();

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
  MyThemeKeys themekey;
  ThemeData theme;
  int themekeyIndex;

  @override
  void initState() {
    themekeyIndex = (prefs.getInt('themeKey') ?? 0);
    themekey = MyThemeKeys.values[themekeyIndex];
    brightness = Brightness.light;
    theme = MyThemes.getThemeFromKey(themekey);
    print("THEME: $theme");
    super.initState();
  }

  callback({theme, themeKey}) {
    setState(() {
      this.themekey = themeKey;
      this.theme = MyThemes.getThemeFromKey(themekey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppSettings(
        callback: callback,
        theme: theme,
        themeKey: themekey,
        child: AppWrapper()

        // _Home()

        );
  }
}

class AppWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

    final navigatorKey = GlobalKey<NavigatorState>();
    return MaterialApp(
      navigatorKey: navigatorKey,
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('es', 'MX'),
        const Locale('hi', 'IN'),
      ],
      localizationsDelegates: [
        // A class which loads the translations from JSON files
        AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },
      title: "MyContacts",
      debugShowCheckedModeBanner: false,
      theme: AppSettings.of(context).theme,
      home: WillPopScope(
        onWillPop: _onWillPop,
        child: Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  final List<Widget> _activities = [
    ContactActivity(),
    ContactList2(),
    FavoriteContactList(),
    GroupActivity()
    // Settings()
  ];

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
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
    contactService.changeIndex(index);
    // setState(() {
    //   _currentIndex = index;
    // });
  }

  Widget _bottomMenuTitle(String text) {
    return Text(AppLocalizations.of(context).translate(text));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return StreamBuilder(
      stream: contactService.streamIndex,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Scaffold(
            appBar: AppBar(
              title: Text(translatedText("app_title", context)),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Settings()),
                      );
                    })
              ],
            ),
            body: widget._activities[contactService.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.shifting,
                selectedItemColor: Color(0xFF6A6A6C),
                unselectedItemColor: Colors.grey,
                selectedLabelStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
                unselectedLabelStyle: TextStyle(
                  color: Colors.grey,
                ),
                showUnselectedLabels: true,
                currentIndex: contactService.currentIndex,
                onTap: onTabTapped,
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.home,
                        // color: Theme.of(context).primaryColor,
                      ),
                      title: _bottomMenuTitle("menu_home")),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.contacts),
                      title: _bottomMenuTitle("menu_contactList")),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.star),
                      title: _bottomMenuTitle("menu_favorite")),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.group),
                      title: _bottomMenuTitle("menu_groups")),
                  // BottomNavigationBarItem(
                  //     icon: Icon(Icons.settings),
                  //     title: _bottomMenuTitle("menu_settings")),
                ]));
      },
    );
  }
}
