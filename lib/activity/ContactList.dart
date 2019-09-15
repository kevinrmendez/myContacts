import 'package:flutter/material.dart';
import 'package:kevin_app/ContactDb.dart';
import 'dart:async';
import 'dart:io';

import '../apikeys.dart';
import '../contact.dart';
import 'contactDetails.dart';

import 'package:admob_flutter/admob_flutter.dart';

int _counter = 0;
AdmobInterstitial interstitialAd = AdmobInterstitial(
  adUnitId: getInterstitialAdUnitId(),
);

getInterstitialAdUnitId() {
  return apikeys["contactListAdd"];
  // return apikeys["addInterstellarTest"];
}

void _showAd() {
  if (_counter % 4 == 0) {
    interstitialAd.load();
    interstitialAd.show();
  }
  _counter++;
}

class ContactList extends StatefulWidget {
  @override
  _ContactListState createState() {
    return _ContactListState();
  }
}

class _ContactListState extends State<ContactList> {
  final ContactDb db = ContactDb();
  Future<List<Contact>> contacts;

  Future getContactList() async {
    return await contacts;
  }

  callback(value) {
    setState(() {
      contacts = value;
    });
  }

  @override
  void initState() {
    contacts = db.contacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact List'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                // print(snapshot.data);
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                  default:
                    if (snapshot.data.length > 0) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, int index) {
                            return Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      snapshot.data[index].image == "" ||
                                              snapshot.data[index].image == null
                                          ? AssetImage('assets/person-big.png')
                                          : FileImage(
                                              File(snapshot.data[index].image)),
                                ),
                                // : Container()),
                                title:
                                    Text('name: ${snapshot.data[index].name}'),
                                subtitle: Text(
                                    'phone: ${snapshot.data[index].phone.toString()}'),
                                trailing: Icon(Icons.keyboard_arrow_right),
                                onTap: () {
                                  // Navigator.pushNamed(
                                  //     context, '/contactDetails',
                                  //     arguments: snapshot.data[index]);
                                  _showAd();

                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    // Contact contact = new Contact(
                                    //   name: snapshot.data[index].name,
                                    //   phone: snapshot.data[index].phone,
                                    //   image: snapshot.data[index].image,
                                    // );
                                    // contact.id = snapshot.data[index].id;
                                    print('CONTACTS ${snapshot.data[index]}');
                                    return ContactDetails(
                                        contact: snapshot.data[index],
                                        callback: callback);
                                  }));
                                },
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Expanded(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 200,
                                // margin: EdgeInsets.only(top: 40),
                                child: Text(
                                  'Your contact list is empty',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.blue[300]),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                child: Text(
                                  'go back to the main menu and add your contacts',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 17),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                }
              },
              future: getContactList(),
            ),
            // ListView(children: db.contacts() as List<Widget>)
          ],
        ),
      ),
    );
  }
}
