import 'package:flutter/material.dart';
import 'package:kevin_app/ContactDb.dart';
import 'dart:async';

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Contacts'),
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
                              return Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                  bottom: BorderSide(
                                      width: 2, color: Colors.grey[200]),
                                )),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      snapshot.data[index].name,
                                      style: TextStyle(
                                          color: Colors.blue[300],
                                          fontSize: 30),
                                    ),
                                    Text(snapshot.data[index].phone.toString())
                                  ],
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
