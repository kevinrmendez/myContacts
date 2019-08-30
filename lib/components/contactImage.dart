import 'dart:io';

import 'package:flutter/material.dart';

import '../appSettings.dart';

class ContactImage extends StatelessWidget {
  final double height;
  final String image;
  final BuildContext context;
  const ContactImage({this.height, this.context, this.image});

  @override
  Widget build(context) {
    AppSettings appState = AppSettings.of(context);
    return image == "" || image == null
        ? Container(
            height: 80,
            child: appState.brightness == Brightness.light
                ? Image.asset('assets/person.png')
                : Image.asset('assets/person-w.png'))
        : Container(height: height, child: Image.file(File(image)));
  }
}
