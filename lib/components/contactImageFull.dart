import 'dart:io';

import 'package:flutter/material.dart';

import '../appSettings.dart';

class ContactImageFull extends StatelessWidget {
  final String image;
  final BuildContext context;
  const ContactImageFull({this.context, this.image});

  @override
  Widget build(context) {
    AppSettings appState = AppSettings.of(context);
    print('MYTHEMEKEYS ${appState.themeKey}');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        image == null || image == ""
            ? Container(
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width * 0.35,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage('assets/person-icon-w-s3p.png'))))
            : Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    // shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover, image: FileImage(File(image)))))
      ],
    );
    // child: Image.file(File(image)));
  }
}
