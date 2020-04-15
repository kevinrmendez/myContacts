import 'dart:io';

import 'package:flutter/material.dart';

import '../appSettings.dart';

class ContactImage extends StatelessWidget {
  final String image;
  final BuildContext context;
  const ContactImage({this.context, this.image});

  @override
  Widget build(context) {
    AppSettings appState = AppSettings.of(context);
    print('MYTHEMEKEYS ${appState.themeKey}');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
            height: MediaQuery.of(context).size.width * 0.4,
            width: MediaQuery.of(context).size.width * 0.4,
            child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: image == null || image == ""
                            ? AssetImage('assets/person-icon-w-s3p.png')
                            : FileImage(File(image)))))),
      ],
    );
    // child: Image.file(File(image)));
  }
}
