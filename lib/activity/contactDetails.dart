import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kevin_app/activity/contactEdit.dart';
import 'package:kevin_app/components/contactImage.dart';
import 'package:kevin_app/components/contactImageFull.dart';
import 'package:kevin_app/myThemes.dart';
import 'package:kevin_app/utils/admobUtils.dart';
import 'package:kevin_app/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../appSettings.dart';
import '../contact.dart';
import 'package:kevin_app/apikeys.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:share/share.dart';

class ContactDetails extends StatelessWidget {
  final Contact contact;
  final Function callback;

  ContactDetails({this.contact, this.callback}) {}

  @override
  Widget build(BuildContext context) {
    Widget _buildUrlButton({String url, Icon icon}) {
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

    Widget _buildShareButton() {
      return Container(
        width: 100,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: RaisedButton(
          color: Theme.of(context).primaryColor,
          child: Icon(
            Icons.share,
            color: Colors.white,
          ),
          onPressed: () {
            Share.share(
                "Contact Details: name: ${contact.name}, phone: ${contact.phone}, email: ${contact.phone}");
          },
        ),
      );
    }

    Widget _buildButtons() {
      return Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Wrap(
          alignment: WrapAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildShareButton(),
            contact.phone != ""
                ? _buildUrlButton(
                    url: "tel:${contact.phone.toString()}",
                    icon: Icon(
                      Icons.phone,
                      color: Colors.white,
                    ))
                : const SizedBox(),
            contact.email != ""
                ? _buildUrlButton(
                    url: 'mailto:${contact.email}',
                    icon: Icon(
                      Icons.email,
                      color: Colors.white,
                    ))
                : const SizedBox(),
          ],
        ),
      );
    }

    Widget _buildDetailstext(
        {MainAxisAlignment mainAlignment = MainAxisAlignment.center,
        CrossAxisAlignment crossAlignment = CrossAxisAlignment.start}) {
      return Column(
        mainAxisAlignment: mainAlignment,
        crossAxisAlignment: crossAlignment,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 5, left: 30, top: 12),
            child: contact.phone != ""
                ? Wrap(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(Icons.phone,
                              color: Theme.of(context).accentColor)),
                      Text(
                        contact.phone.toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
          contact.email != ""
              ? Container(
                  margin: EdgeInsets.only(bottom: 5, left: 30),
                  child: Wrap(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(Icons.email,
                              color: Theme.of(context).accentColor)),
                      Text(
                        contact.email,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                )
              : Container(),
          _buildButtons(),
        ],
      );
    }

    Widget _buildFavorite() {
      return contact.favorite == 0
          ? SizedBox()
          : Container(
              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: Icon(
                Icons.star,
                size: 30,
                color: Theme.of(context).accentColor,
              ),
            );
    }

    Widget _buildContactName(context) {
      return Container(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
        // width: MediaQuery.of(context).size.width * 0.8,
        child: Text(
          contact.name,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        ),
      );
    }

    // final Contact contact = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Details'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(child: AdmobUtils.admobBanner()),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildContactName(context),
                  _buildFavorite()
                ],
              ),
              contact.category == translatedText("group_default", context) ||
                      contact.category == null
                  ? SizedBox()
                  : Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        contact.category,
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
              ContactImageFull(
                image: contact.image,
              ),
              _buildDetailstext(mainAlignment: MainAxisAlignment.start),
            ],
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.edit,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ContactEdit(
                      contact: contact,
                      context: context,
                      callback: callback,
                    )),
          );
          // Navigator.pushNamed(context, '/contactEdit', arguments: contact);
        },
      ),
    );
  }
}
