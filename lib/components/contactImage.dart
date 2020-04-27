import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kevin_app/state/appSettings.dart';

class ContactImage extends StatelessWidget {
  final String image;
  final BuildContext context;
  const ContactImage({this.context, this.image});

  @override
  Widget build(context) {
    AppSettings appState = AppSettings.of(context);
    print('MYTHEMEKEYS ${appState.themeKey}');

    return Container(
      padding: EdgeInsets.symmetric(
          vertical: image == null || image == "" ? 40 : 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: image == null || image == ""
                ? MediaQuery.of(context).size.width * .17
                : MediaQuery.of(context).size.width * .3,
            backgroundColor: Theme.of(context).primaryColor,
            backgroundImage: image == "" || image == null
                ? AssetImage('assets/person-icon-w-s3p.png')
                : FileImage(File(image)),
          ),
        ],
      ),
    );
    // child: Image.file(File(image)));
  }
}
