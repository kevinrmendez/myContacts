import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kevin_app/activity/ContactList2.dart';
import 'package:kevin_app/activity/FavoriteContactList.dart';
import 'package:kevin_app/activity/GroupActivity.dart';
import 'package:kevin_app/activity/Settings.dart';
import 'package:kevin_app/activity/contactActivity.dart';
import 'package:kevin_app/app_localizations.dart';
import 'package:kevin_app/state/appState.dart';
import 'package:kevin_app/utils/admobUtils.dart';
import 'package:kevin_app/utils/colors.dart';
import 'package:kevin_app/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  final List<Widget> _activities = [
    ContactActivity(),
    ContactList2(),
    FavoriteContactList(),
    GroupActivity()
  ];

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int _currentIndex = 0;

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
  void initState() {
    super.initState();
    //init local notifications
    // flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // var initializationSettingsAndroid =
    //     AndroidInitializationSettings("ic_launcher");
    // var initializationSettingsIOS = IOSInitializationSettings();
    // var initializationSettings = InitializationSettings(
    //     initializationSettingsAndroid, initializationSettingsIOS);
    // //TODO: FIX CONTACT ID  TO STOP DUPLICATE NOTIFICATION
    // flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //     onSelectNotification: onSelectNotificationBirthday);
  }

  // Future onSelectNotificationBirthday(String payload) async {
  //   var contactIdString = payload.split(" ");
  //   print('hola');
  //   var contactId = int.parse(contactIdString[0]);
  //   print(contactId);
  //   var dialogDescription = payload.substring(1);
  //   print("CONTACTNOASDFDS");

  //   Contact contact = await db.getContactById(contactId);
  //   print("CONTACTNOTI: $contact");
  //   showDialog(
  //       context: context,
  //       builder: (_) => Dialog(
  //             child: Container(
  //               height: MediaQuery.of(context).size.height * .3,
  //               child: Column(
  //                 children: <Widget>[
  //                   Container(
  //                       padding: EdgeInsets.symmetric(vertical: 14),
  //                       width: MediaQuery.of(context).size.width,
  //                       color: Theme.of(context).primaryColor,
  //                       child: Text(
  //                         translatedText(
  //                             "dialog_birthday_reminder_title", context),
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(color: Colors.white, fontSize: 22),
  //                       )),
  //                   SizedBox(
  //                     height: 30,
  //                   ),
  //                   Column(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: <Widget>[
  //                       Container(
  //                         width: MediaQuery.of(context).size.width * .8,
  //                         child: Text(
  //                           " $dialogDescription",
  //                           textAlign: TextAlign.center,
  //                           style: TextStyle(fontSize: 18),
  //                         ),
  //                       ),
  //                       SizedBox(
  //                         height: 20,
  //                       ),
  //                       RaisedButton(
  //                         color: Theme.of(context).accentColor,
  //                         child: Text(
  //                           translatedText("button_close", context),
  //                           style: TextStyle(fontSize: 18, color: Colors.white),
  //                         ),
  //                         onPressed: () {
  //                           flutterLocalNotificationsPlugin.cancel(contactId);
  //                           Navigator.of(context).pop();
  //                         },
  //                       )
  //                     ],
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ));
  //   flutterLocalNotificationsPlugin.cancel(contactId);
  // }

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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: StreamBuilder(
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
              body: StreamBuilder<Object>(
                  initialData: 0,
                  stream: contactService.streamIndex,
                  builder: (context, snapshot) {
                    return widget._activities[snapshot.data];
                  }),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: GREY),
                  ),
                ),
                height: 120,
                child: Stack(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: 120,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: BottomNavigationBar(
                            elevation: 0,
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
                            ]),
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: AdmobUtils.admobBanner()),
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }
}
