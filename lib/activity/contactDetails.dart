import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kevin_app/activity/contactEdit.dart';
import 'package:url_launcher/url_launcher.dart';
import '../appSettings.dart';
import '../contact.dart';

class ContactDetails extends StatelessWidget {
  final Contact contact;
  final Function callback;

  ContactDetails({this.contact, this.callback});

  Widget _buildUrlButton({String url, String title}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: RaisedButton(
        child: Text(title),
        onPressed: () async {
          // String phone = contact.phone.toString();
          // String url = 'tel:$phone';
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        },
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
          margin: EdgeInsets.only(bottom: 5, left: 30, top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(right: 20),
                child: Icon(
                  Icons.person,
                  color: Colors.blue[300],
                ),
              ),
              Text(
                contact.name,
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 5, left: 30),
          child: Row(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.phone, color: Colors.blue[300])),
              Text(
                contact.phone.toString(),
                style: TextStyle(fontSize: 30),
              ),
              _buildUrlButton(
                  url: "tel:${contact.phone.toString()}", title: 'call')
              // RaisedButton(
              //   child: Text('call'),
              //   onPressed: () async {
              //     String phone = contact.phone.toString();
              //     String url = 'tel:$phone';
              //     if (await canLaunch(url)) {
              //       await launch(url);
              //     } else {
              //       throw 'Could not launch $url';
              //     }
              //   },
              // )
            ],
          ),
        ),
        contact.email != ""
            ? Container(
                margin: EdgeInsets.only(bottom: 5, left: 30),
                child: Row(
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(Icons.email, color: Colors.blue[300])),
                    Text(
                      contact.email,
                      style: TextStyle(fontSize: 30),
                    ),
                    contact.email != null || contact.email == ""
                        ? _buildUrlButton(
                            url: 'mailto:${contact.email}', title: 'send email')
                        : Container()
                  ],
                ),
              )
            : Container(),
      ],
    );
  }

  Widget _buildVerticalLayout(BuildContext context) {
    AppSettings appState = AppSettings.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height:
                      contact.image == null || contact.image == "" ? 150 : 300,
                  child: contact.image == null || contact.image == ""
                      ? (appState.brightness == Brightness.light
                          ? Image.asset('assets/person.png')
                          : Image.asset('assets/person-w.png'))
                      : Image.file(File(contact.image)),
                ),
              ],
            ),
            _buildDetailstext(mainAlignment: MainAxisAlignment.start)
          ],
        ),
      ],
    );
  }

  Widget _buildHorizontalLayout(BuildContext context) {
    AppSettings appState = AppSettings.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height:
                      contact.image == null || contact.image == "" ? 150 : 250,
                  child: contact.image == null || contact.image == ""
                      ? (appState.brightness == Brightness.light
                          ? Image.asset('assets/person.png')
                          : Image.asset('assets/person-w.png'))
                      : Image.file(File(contact.image)),
                ),
              ],
            ),
            _buildDetailstext(
                mainAlignment: MainAxisAlignment.center,
                crossAlignment: CrossAxisAlignment.start)
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
              ? _buildVerticalLayout(context)
              : _buildHorizontalLayout(context);
        }),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
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
