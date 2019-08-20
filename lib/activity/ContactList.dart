import 'package:flutter/material.dart';
import 'package:kevin_app/ContactDb.dart';
import 'dart:async';
import 'dart:io';

import 'contactDetails.dart';

class ContactList extends StatelessWidget {
  final ContactDb db = ContactDb();

  Future getContactList() async {
    return await db.contacts();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Kevin APP',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text('YOUR CONTACTS'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              FutureBuilder(
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  // print(snapshot.data);
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return CircularProgressIndicator();
                    case ConnectionState.none:
                      return Text('no data');
                    default:
                      if (snapshot.data.length > 0) {
                        return Flexible(
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, int index) {
                              return Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: snapshot
                                                    .data[index].image ==
                                                "" ||
                                            snapshot.data[index].image == null
                                        ? AssetImage('assets/person-w.png')
                                        : FileImage(
                                            File(snapshot.data[index].image)),
                                  ),
                                  // : Container()),
                                  title: Text(
                                      'name: ${snapshot.data[index].name}'),
                                  subtitle: Text(
                                      'phone: ${snapshot.data[index].phone.toString()}'),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ContactDetails(
                                                name: snapshot.data[index].name,
                                                phone: snapshot
                                                    .data[index].phone
                                                    .toString(),
                                                image:
                                                    snapshot.data[index].image,
                                              )),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 200,
                              margin: EdgeInsets.only(top: 40),
                              child: Text(
                                'Your contact list is empty',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 40),
                              child: Text(
                                'go back to the main menu and add your contacts',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 17),
                              ),
                            )
                          ],
                        );
                      }
                  }
                },
                future: getContactList(),
              ),
              // ListView(children: db.contacts() as List<Widget>)
            ],
          ),
        ));
  }
}
