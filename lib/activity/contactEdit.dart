import 'package:flutter/material.dart';
import 'package:kevin_app/utils/admobUtils.dart';

import 'package:kevin_app/activity/contactEditForm.dart';
import 'package:kevin_app/contact.dart';

class ContactEdit extends StatelessWidget {
  final Contact contact;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ContactEdit({@required this.contact});

  @override
  Widget build(BuildContext context) {
    // contact = ModalRoute.of(context).settings.arguments;
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(children: <Widget>[
        ListView(
          children: <Widget>[
            AdmobUtils.admobBanner(),
            ContactEditForm(
              contact: contact,
              context: context,
            )
          ],
        ),
        Positioned(
            top: 85,
            left: 10,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 30,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ))
      ]),
    );
  }
}
