import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kevin_app/activity/contactEdit.dart';
import 'package:url_launcher/url_launcher.dart';
import '../appSettings.dart';
import '../contact.dart';
import 'package:kevin_app/apikeys.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:share/share.dart';

int _counter = 0;
AdmobInterstitial interstitialAd = AdmobInterstitial(
  adUnitId: getInterstitialAdUnitId(),
);

getInterstitialAdUnitId() {
  return apikeys["addMobInterstellar"];
  // return apikeys["addInterstellarTest"];
}

void _showAd() {
  if (_counter % 4 == 0) {
    interstitialAd.load();
    interstitialAd.show();
  }
  _counter++;
}

class ContactDetails extends StatelessWidget {
  final Contact contact;
  final Function callback;

  ContactDetails({this.contact, this.callback});

  Widget _buildUrlButton({String url, Icon icon}) {
    return Container(
      width: 100,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: RaisedButton(
        color: Colors.blue,
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
        color: Colors.blue,
        child: Icon(
          Icons.share,
          color: Colors.white,
        ),
        onPressed: () {
          Share.share(
              "Contact Details: name: ${contact.name}, phone: ${contact.phone}, email: ${contact.phone},instagram: ${contact.instagram} ");
        },
      ),
    );
  }

  Widget _buildButtons() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildShareButton(),
          _buildUrlButton(
              url: "tel:${contact.phone.toString()}",
              icon: Icon(
                Icons.phone,
                color: Colors.white,
              )),
          contact.email != ""
              ? _buildUrlButton(
                  url: 'mailto:${contact.email}',
                  icon: Icon(
                    Icons.email,
                    color: Colors.white,
                  ))
              : Container(),
          contact.instagram != ""
              ? _buildUrlButton(
                  url: 'https://www.instagram.com/${contact.instagram}',
                  icon: Icon(
                    Icons.casino,
                    color: Colors.white,
                  ))
              : Container()
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
          margin: EdgeInsets.only(bottom: 5, left: 30),
          child: Wrap(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.phone, color: Colors.blue[300])),
              Text(
                contact.phone.toString(),
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
        ),
        contact.email != ""
            ? Container(
                margin: EdgeInsets.only(bottom: 5, left: 30),
                child: Wrap(
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(Icons.email, color: Colors.blue[300])),
                    Text(
                      contact.email,
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
              )
            : Container(),
        contact.instagram != ""
            ? Container(
                margin: EdgeInsets.only(bottom: 5, left: 30),
                child: Wrap(
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(Icons.casino, color: Colors.blue[300])),
                    Text(
                      contact.instagram,
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
              )
            : Container(),
        _buildButtons(),
      ],
    );
  }

  Widget _buildContactName(context) {
    AppSettings appState = AppSettings.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      // width: MediaQuery.of(context).size.width * 0.8,
      child: Text(
        contact.name,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: appState.darkMode ? Colors.white : Colors.blue),
      ),
    );
  }

  Widget _buildVerticalLayout(BuildContext context, orientation) {
    AppSettings appState = AppSettings.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              height: contact.image == null || contact.image == "" ? 150 : 300,
              child: contact.image == null || contact.image == ""
                  ? (appState.brightness == Brightness.light
                      ? Image.asset('assets/person.png')
                      : Image.asset('assets/person-w.png'))
                  : Image.file(File(contact.image)),
            ),
            _buildContactName(context),
          ],
        ),
        _buildDetailstext(mainAlignment: MainAxisAlignment.start),
      ],
    );
  }

  Widget _buildHorizontalLayout(BuildContext context, orientation) {
    AppSettings appState = AppSettings.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: contact.image == null || contact.image == ""
                        ? 100
                        : 200,
                    child: contact.image == null || contact.image == ""
                        ? (appState.brightness == Brightness.light
                            ? Image.asset('assets/person.png')
                            : Image.asset('assets/person-w.png'))
                        : Image.file(File(contact.image)),
                  ),
                  _buildContactName(context)
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: _buildDetailstext(
                  mainAlignment: MainAxisAlignment.center,
                  crossAlignment: CrossAxisAlignment.start),
            ),
          ],
        ),
      ],
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final Contact contact = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Details'),
      ),
      body: Center(
        child: OrientationBuilder(builder: (context, orientation) {
          var orientation = MediaQuery.of(context).orientation;
          return orientation == Orientation.portrait
              ? _buildVerticalLayout(context, orientation)
              : _buildHorizontalLayout(context, orientation);
        }),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
          _showAd();

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ContactEdit(
                      contact: contact,
                      callback: callback,
                    )),
          );
          // Navigator.pushNamed(context, '/contactEdit', arguments: contact);
        },
      ),
    );
  }
}
