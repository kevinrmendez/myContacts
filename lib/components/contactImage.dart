import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kevin_app/utils/colors.dart';

class ContactImage extends StatelessWidget {
  final String image;
  final BuildContext context;
  const ContactImage({this.context, this.image});

  @override
  Widget build(context) {
    var containerHeight = MediaQuery.of(context).size.height * .32;
    var containerWidth = MediaQuery.of(context).size.width;
    return Container(
      // color: Colors.pink,
      padding: EdgeInsets.only(top: image == null || image == "" ? 30 : 0),
      width: containerWidth,
      height: containerHeight,
      child: Stack(
        children: <Widget>[
          image == null || image == ""
              ? Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height * .2,
                    width: MediaQuery.of(context).size.height * .2,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: GREY,
                            offset: const Offset(3.0, 3.0),
                            blurRadius: 5.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(200))),
                    child: Container(
                        decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/person-icon-w-s3p.png'),
                          fit: BoxFit.scaleDown),
                    )),
                  ),
                )
              : Container(
                  height: containerHeight,
                  // height: 300,
                  width: containerWidth,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(File(image)), fit: BoxFit.cover),
                  ))
        ],
      ),
    );
    // child: Image.file(File(image)));
  }
}
