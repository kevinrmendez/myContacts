import 'package:flutter/material.dart';
import 'package:kevin_app/activity/Settings.dart';

import 'activity/ContactList.dart';
import 'package:kevin_app/activity/contactActivity.dart';

import 'apikeys.dart';
import 'appSettings.dart';
import 'package:firebase_admob/firebase_admob.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Brightness brightness;
  bool cameraActive;
  bool darkModeActive;
  // This widget is the root of your application.

  @override
  void initState() {
    brightness = Brightness.light;
    darkModeActive = false;
    cameraActive = true;
    super.initState();
  }

  callback({brightness, darkMode, camera}) {
    setState(() {
      if (brightness != null) {
        this.brightness = brightness;
        this.darkModeActive = darkMode;
      } else {
        this.cameraActive = camera;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppSettings(
        brightness: brightness,
        callback: callback,
        camera: cameraActive,
        darkMode: darkModeActive,
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
    FirebaseAdMob.instance
        .initialize(appId: apikeys["addMobBanner"])
        .then((response) {
      myBanner
        ..load()
        ..show(
          anchorOffset: 65.0,
          anchorType: AnchorType.top,
        );
    });

    return MaterialApp(
      title: 'My Contacts',
      theme: ThemeData(
        brightness: AppSettings.of(context).brightness,
        primarySwatch: Colors.blue,
      ),
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

// MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
//   keywords: <String>['flutterio', 'beautiful apps'],
//   contentUrl: 'https://flutter.io',
//   birthday: DateTime.now(),
//   childDirected: false,
//   designedForFamilies: false,
//   gender:
//       MobileAdGender.male, // or MobileAdGender.female, MobileAdGender.unknown
//   testDevices: <String>[], // Android emulators are considered test devices
// );

BannerAd myBanner = BannerAd(
  // Replace the testAdUnitId with an ad unit id from the AdMob dash.
  // https://developers.google.com/admob/android/test-ads
  // https://developers.google.com/admob/ios/test-ads
  adUnitId: BannerAd.testAdUnitId,
  size: AdSize.smartBanner,
  // targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    print("BannerAd event is $event");
  },
);

InterstitialAd myInterstitial = InterstitialAd(
  // Replace the testAdUnitId with an ad unit id from the AdMob dash.
  // https://developers.google.com/admob/android/test-ads
  // https://developers.google.com/admob/ios/test-ads
  adUnitId: InterstitialAd.testAdUnitId,
  // targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    print("InterstitialAd event is $event");
  },
);
