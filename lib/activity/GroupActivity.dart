import 'package:flutter/material.dart';
import 'package:kevin_app/ContactDb.dart';
import 'package:kevin_app/activity/ContactListGroup.dart';
import 'package:kevin_app/activity/Settings.dart';
import 'package:kevin_app/utils/utils.dart';
import 'package:strings/strings.dart';
import 'dart:async';

import '../contact.dart';

class GroupActivity extends StatefulWidget {
  @override
  _GroupActivityState createState() {
    return _GroupActivityState();
  }
}

class _GroupActivityState extends State<GroupActivity> {
  final ContactDb db = ContactDb();
  Future<List<Contact>> contacts;
  List<String> category;

  @override
  void initState() {
    super.initState();
  }

  void _menuSelected(choice) {
    switch (choice) {
      case 'settings':
        {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Settings()),
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    category = <String>[
      translatedText("group_default", context),
      translatedText("group_family", context),
      translatedText("group_friend", context),
      translatedText("group_coworker", context),
    ];
    return Scaffold(
      body: Container(
        child: ListView.builder(
            itemCount: category.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  // index % 10 == 0 ? AdmobUtils.admobBanner() : SizedBox(),
                  Card(
                    child: ListTile(
                      // leading:
                      title: Text(
                        '${capitalize(category[index])}',
                        style: TextStyle(fontSize: 20),
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        print("GROUP: ${category[index]}");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ContactListGroup(category: category[index])),
                        );
                        // }));
                      },
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
