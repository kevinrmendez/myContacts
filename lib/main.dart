import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:admob_flutter/admob_flutter.dart';

import 'package:kevin_app/activity/homeActivity.dart';
import 'package:kevin_app/activity/setupActivity.dart';
import 'package:kevin_app/models/contact.dart';
import 'package:kevin_app/db/contactDb.dart';
import 'package:kevin_app/state/appSettings.dart';
import 'package:kevin_app/utils/myThemes.dart';
import 'package:kevin_app/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'apikeys.dart';
import 'app_localizations.dart';

ContactDb db = ContactDb();
List<Contact> contactsfromDb;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

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
  Color color;
  bool showSetupScreen;
  // Color accentColor;

  @override
  void initState() {
    super.initState();

    themekeyIndex = (prefs.getInt('themeKey') ?? 0);
    themekey = MyThemeKeys.values[themekeyIndex];
    brightness = Brightness.light;
    theme = MyThemes.getThemeFromKey(themekey);
    color = Color((prefs.getInt('color') ?? 4280391411));
    print("THEME: $theme");
    showSetupScreen = (prefs.getBool('showSetupScreen') ?? true);

    //init local notifications
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        AndroidInitializationSettings("ic_launcher");
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    //TODO: FIX CONTACT ID  TO STOP DUPLICATE NOTIFICATION
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotificationBirthday);
  }

  Future onSelectNotificationBirthday(String payload) async {
    var contactIdString = payload.split(" ");
    var contactId = int.parse(contactIdString[0]);
    print(contactId);
    var dialogDescription = payload.substring(1);
    showDialog(
        context: context,
        builder: (_) => Dialog(
              child: Container(
                height: MediaQuery.of(context).size.height * .3,
                child: Column(
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        width: MediaQuery.of(context).size.width,
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          translatedText(
                              "dialog_birthday_reminder_title", context),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * .8,
                          child: Text(
                            " $dialogDescription",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RaisedButton(
                          color: Theme.of(context).accentColor,
                          child: Text(
                            translatedText("button_close", context),
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          onPressed: () {
                            flutterLocalNotificationsPlugin.cancel(contactId);
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            ));
    flutterLocalNotificationsPlugin.cancel(contactId);
  }

  // callback({theme, themeKey}) {
  //   setState(() {
  //     this.themekey = themeKey;
  //     this.theme = MyThemes.getThemeFromKey(themekey);
  //   });
  // }
  callback({color, showSetupScreen}) {
    if (color != null) {
      setState(() {
        this.color = color;
      });
    }
    if (showSetupScreen != null) {
      setState(() {
        this.showSetupScreen = showSetupScreen;
      });
    }
    // setState(() {
    //   this.color = color;

    // });
  }

  @override
  Widget build(BuildContext context) {
    return AppSettings(
        callback: callback,
        // theme: theme,
        // themeKey: themekey,
        // primaryColor: color,
        // accentColor: color[200],
        color: color,
        showSetupScreen: showSetupScreen,
        // accentColor: accentColor,
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
      initialRoute: AppSettings.of(context).showSetupScreen ? '/setup' : '/',
      routes: {
        '/': (context) => Home(),
        '/setup': (context) => SetupActivity(),
      },
      navigatorKey: navigatorKey,
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('es', 'MX'),
        const Locale('es', 'AR'),
        const Locale('es', 'ES'),
        const Locale('es', 'GT'),
        const Locale('hi', 'IN'),
        const Locale('fr', 'FR'),
        const Locale('pt', 'BR'),
        const Locale('pt', 'PT'),
        const Locale('de', 'DE'),
        const Locale('it', 'IT'),
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
      // theme: AppSettings.of(context).theme,
      theme: ThemeData(
          fontFamily: "Open Sans",
          primaryColor: AppSettings.of(context).color,
          accentColor: AppSettings.of(context).color),
      // home: WillPopScope(
      //   onWillPop: _onWillPop,
      //   child: Home(),
      // ),
      // home: WillPopScope(
      //   onWillPop: _onWillPop,
      //   child:
      //       AppSettings.of(context).showSetupScreen ? SetupActivity() : Home(),
      //       // Home(),
      // ),
    );
  }
}
