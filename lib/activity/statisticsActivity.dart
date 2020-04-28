import 'package:flutter/material.dart';
import 'package:kevin_app/contact.dart';
import 'package:kevin_app/state/appState.dart';
import 'package:kevin_app/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class StatisticsActivity extends StatefulWidget {
  const StatisticsActivity({Key key}) : super(key: key);

  @override
  _StatisticsActivityState createState() => _StatisticsActivityState();
}

class _StatisticsActivityState extends State<StatisticsActivity> {
  _checkContactsDuplicates() {
    List<Contact> list = contactService.current;
    Contact contact;
    int duplicatesCounter = 0;
    list.forEach((current) {
      if (contact == null) {
        contact = current;
      } else {
        if (contact.name == current.name &&
            contact.phone == current.phone &&
            contact.email == current.email &&
            contact.favorite == current.favorite &&
            contact.category == current.category) {
          duplicatesCounter++;
        } else {
          contact = current;
        }
      }
    });
    print("DUPLICATES: $duplicatesCounter");
    int duplicatesNumber = duplicatesCounter;
    contactService.updateContactsDuplicate(duplicatesNumber);
  }

  @override
  void initState() {
    super.initState();
    _checkContactsDuplicates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(translatedText("app_title_about", context))),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('total contacts:'),
                Text(contactService.current.length.toString())
              ],
            ),
            Row(
              children: <Widget>[
                Text('total duplicate contacts:'),
                Text(contactService.currentContactsDuplicates.toString())
              ],
            ),
          ],
        ),
      ),
    );
  }
}
