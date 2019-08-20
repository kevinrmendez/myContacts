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
                              // return Container(
                              //   decoration: BoxDecoration(
                              //       border: Border(
                              //     bottom: BorderSide(
                              //         width: 2, color: Colors.grey[200]),
                              //   )),
                              //   child: Row(
                              //     children: <Widget>[
                              //       ClipRRect(
                              //         borderRadius: BorderRadius.circular(50),
                              //         child: Image.asset(
                              //           'assets/meSnow.jpg',
                              //           height: 60,
                              //         ),
                              //       ),
                              //       Text(
                              //         snapshot.data[index].name,
                              //         style: TextStyle(
                              //             color: Colors.blue[300],
                              //             fontSize: 30),
                              //       ),
                              //       Container(
                              //         padding: EdgeInsets.all(10),
                              //         child: Text(
                              //           snapshot.data[index].phone.toString(),
                              //           style: TextStyle(fontSize: 30),
                              //         ),
                              //       )
                              //     ],
                              //   ),
                              // );
                              return Card(
                                child: ListTile(
                                  leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.asset('assets/meSnow.jpg')),
                                  title: Text(
                                      'name: ${snapshot.data[index].name}'),
                                  subtitle: Text(
                                      'phone: ${snapshot.data[index].phone.toString()}'),
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
