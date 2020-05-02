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
      padding: EdgeInsets.only(top: image == null || image == "" ? 0 : 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          image == null || image == ""
              // ? CircleAvatar(
              //     radius: image == null || image == ""
              //         ? MediaQuery.of(context).size.width * .17
              //         : MediaQuery.of(context).size.width * .3,
              //     backgroundColor: Theme.of(context).primaryColor,
              //     backgroundImage: image == "" || image == null
              //         ? AssetImage('assets/person-icon-w-s3p.png')
              //         : FileImage(File(image)),
              //   )
              ? Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  color: Theme.of(context).primaryColor,
                  child: Center(
                    child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.only(
                          //     bottomLeft: Radius.circular(20),
                          //     bottomRight: Radius.circular(20)),
                          image: DecorationImage(
                              image: AssetImage('assets/person-icon-w-s3p.png'),
                              fit: BoxFit.scaleDown),
                        )),
                  ),
                )
              : Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.only(
                    //     bottomLeft: Radius.circular(20),
                    //     bottomRight: Radius.circular(20)),
                    image: DecorationImage(
                        image: FileImage(File(image)), fit: BoxFit.cover),
                  ))
        ],
      ),
    );
    // child: Image.file(File(image)));
  }
}
