import 'dart:io';

import 'package:flutter/material.dart';

import '../appSettings.dart';
import '../myThemes.dart';

class ContactImage extends StatelessWidget {
  final double height;
  final String image;
  final BuildContext context;
  const ContactImage({this.height, this.context, this.image});

  @override
  Widget build(context) {
    AppSettings appState = AppSettings.of(context);
    print('MYTHEMEKEYS ${appState.themeKey}');
    return image == "" || image == null
        ? Container(
            height: 100,
            child: appState.themeKey == MyThemeKeys.DARK
                ? Image.asset('assets/person-w.png')
                : Image.asset('assets/person.png'))
        : Container(height: height, child: Image.file(File(image)));
  }
}
