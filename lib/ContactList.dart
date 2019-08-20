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
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FutureBuilder(
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    print(snapshot.data);
                    // if (snapshot.connectionState == ConnectionState.waiting) {

                    // }
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Text('Loading');
                      case ConnectionState.none:
                        return Text('no data');
                      default:
                        return Flexible(
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, int index) {
                              return Card(
                                child: ListTile(
                                  // leading: ClipOval(
                                  //     child: snapshot.data[index].image == "" ||
                                  //             snapshot.data[index].image == null
                                  //         ? Image.asset('assets/meSnow.jpg')
                                  //         : Image.file(File(
                                  //             snapshot.data[index].image))),
                                  leading: CircleAvatar(
                                    backgroundImage: snapshot
                                                    .data[index].image ==
                                                "" ||
                                            snapshot.data[index].image == null
                                        ? AssetImage('assets/meSnow.jpg')
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
                    }
                  },
                  future: getContactList(),
                ),
                // ListView(children: db.contacts() as List<Widget>)
              ],
            ),
          ),
        ));
  }
}
