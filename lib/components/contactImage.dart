import 'dart:io';

import 'package:flutter/material.dart';

import '../appSettings.dart';
import '../myThemes.dart';

class ContactImage extends StatelessWidget {
  final double height;
  final String image;
  final Orientation orientation;
  final BuildContext context;
  const ContactImage({this.height, this.context, this.image, this.orientation});

  @override
  Widget build(context) {
    AppSettings appState = AppSettings.of(context);
    print('MYTHEMEKEYS ${appState.themeKey}');
    return Column(
      mainAxisAlignment: orientation == Orientation.portrait
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
            height: orientation == Orientation.portrait
                ? MediaQuery.of(context).size.width * 0.3
                : 120,
            width: orientation == Orientation.portrait
                ? MediaQuery.of(context).size.width * 0.3
                : 120,
            // height: MediaQuery.of(context).size.width * 0.4,
            // width: MediaQuery.of(context).size.width * 0.4,
            child: Container(
                // constraints: BoxConstraints(
                //     maxWidth: 250,
                //     maxHeight: 250,
                //     minWidth: 200,
                //     minHeight: 200),
                // height: height,
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
