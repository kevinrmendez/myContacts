import 'package:flutter/material.dart';

import 'package:kevin_app/components/contact_form.dart';

import 'ContactList.dart';

class ContactActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Kevin APP',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Add contact'),
                ContactForm(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: RaisedButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ContactList()),
                      );
                    },
                    child: Text('Contact List'),
                  ),
                ),
                // FutureBuilder(
                //   builder: (context,AsyncSnapshot snapshot) {
                //     switch (snapshot.connectionState) {
                //       case ConnectionState.none:
                //           return Text('no camera available');
                //         break;
                //       default:
                //         return RaisedButton(onPressed: ,)
                //     }
                //   },
                // ),
              ],
            ),
          ),
        ));
  }
}
