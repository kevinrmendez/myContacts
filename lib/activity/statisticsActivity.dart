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
  List<Contact> contactList;
  int contactListLength = 0;
  int favoirteQuantity = 0;

  _checkFavoriteContacts() {
    contactList.forEach((contact) {
      if (contact.favorite == 1) {
        favoirteQuantity++;
      }
    });
  }

  _getCategoryContactsQuantity(String category) {
    int counter = 0;
    contactList.forEach((contact) {
      if (contact.category == category) {
        counter++;
      }
    });
    return counter;
  }

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
    contactList = contactService.current;
    contactListLength = contactService.current.length;
    _checkContactsDuplicates();
    _checkFavoriteContacts();
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
                Icon(Icons.person),
                Text('total contacts:'),
                Text(contactListLength.toString())
              ],
            ),
            Row(
              children: <Widget>[
                Icon(Icons.people),
                Text('total duplicate contacts:'),
                Text(contactService.currentContactsDuplicates.toString())
              ],
            ),
            Row(
              children: <Widget>[
                Icon(Icons.people),
                Text('favorite contacts:'),
                Text(favoirteQuantity.toString())
              ],
            ),
          ],
        ),
      ),
    );
  }
}
