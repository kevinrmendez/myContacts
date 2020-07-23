import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kevin_app/components/contactEditForm.dart';
import 'package:kevin_app/components/contactImage.dart';
import 'package:kevin_app/utils/admobUtils.dart';

import 'package:kevin_app/models/contact.dart';

class ContactEdit extends StatelessWidget {
  final Contact contact;
  final int index;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ContactEdit({@required this.contact, this.index});
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // contact = ModalRoute.of(context).settings.arguments;
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(children: <Widget>[
        ListView(
          controller: scrollController,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                ContactEditForm(
                    contact: contact,
                    context: context,
                    index: index,
                    scrollController: scrollController),
                // Positioned(bottom: 0, child: AdmobUtils.admobBanner())
              ],
            ),
            AdmobUtils.admobBanner()
          ],
        ),
      ]),
    );
  }
}
