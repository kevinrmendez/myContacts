import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../apikeys.dart';
import '../contact.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactDetailsParallax extends StatelessWidget {
  final Contact contact;
  final Function callback;

  ScrollController _controller = ScrollController();

  ContactDetailsParallax({this.contact, this.callback}) {}

  Widget _buildUrlButton({String url, Icon icon, BuildContext context}) {
    return Container(
      width: 100,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        child: icon,
        onPressed: () async {
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        },
      ),
    );
  }

  Widget _buildContactName(String text, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      // width: MediaQuery.of(context).size.width * 0.8,
      child: Text(text,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height * .5,
                floating: true,
                pinned: true,
                leading: SizedBox(),
                backgroundColor: Color.fromRGBO(255, 255, 255, 0),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(0),
                  child: SizedBox(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    collapseMode: CollapseMode.parallax,
                    title: SizedBox(),
                    background: ContactPictureParallax(
                      image: contact.image,
                    )),
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildContactName(contact.name, context),
                contact.favorite == 1
                    ? SizedBox()
                    : Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Icon(
                          Icons.star,
                          size: 30,
                        ),
                      ),
                SizedBox(
                  height: 70,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ContactPictureParallax extends StatelessWidget {
  final String image;
  ContactPictureParallax({this.image});

  @override
  Widget build(BuildContext context) {
    // AppState appState = AppState.of(context);
    return Container(
        height: MediaQuery.of(context).size.height * .5,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            // shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.cover,
                image: image == null || image == ""
                    ? AssetImage('assets/person-icon-w-s3p.png')
                    : FileImage(File(image)))),
        child: SizedBox());
  }
}
