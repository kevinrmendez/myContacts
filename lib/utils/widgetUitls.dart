import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kevin_app/activity/Settings.dart';
import 'package:kevin_app/activity/contactEdit.dart';
import 'package:kevin_app/contact.dart';
import 'package:kevin_app/utils/colors.dart';
import 'package:kevin_app/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class WidgetUtils {
  static showSnackbar(String text, BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  static Widget contactSearchTextField(
      {BuildContext context, TextEditingController filter}) {
    return TextField(
      style: TextStyle(color: GREY, fontSize: 17),
      controller: filter,
      decoration: new InputDecoration(
        prefixIcon: new Icon(
          Icons.search,
          color: Theme.of(context).primaryColor,
        ),
        hintText: translatedText("hintText_search", context),
        hintStyle: TextStyle(color: GREY),
        // enabledBorder: UnderlineInputBorder(
        //   borderSide: BorderSide(color: Theme.of(context).accentColor),
        // ),
        // focusedBorder: UnderlineInputBorder(
        //     borderSide:
        //         BorderSide(color: Theme.of(context).accentColor)),
      ),
    );
  }

  static Widget contactListTile(
      int index, Contact contact, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(seconds: 1),
            pageBuilder: (_, __, ___) => ContactEdit(
              contact: contact,
              index: index,
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          leading: Hero(
            child: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              backgroundImage: contact.image == "" || contact.image == null
                  ? AssetImage('assets/person-icon-w-s3p.png')
                  : FileImage(File(contact.image)),
            ),
            tag: contact.name + index.toString(),
          ),
          title: Text(
            '${contact.name}',
            style: TextStyle(fontSize: 20),
          ),
          trailing: Icon(
              contact.favorite == 0 ? Icons.keyboard_arrow_right : Icons.star),
        ),
      ),
    );
  }

  static Widget emptyListText(
      {String title, String description, BuildContext context}) {
    return Center(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 200,
                    // margin: EdgeInsets.only(top: 40),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Theme.of(context).accentColor),
                    ),
                  ),
                  description != null
                      ? Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.7),
                          margin: EdgeInsets.only(top: 20),
                          child: Text(
                            description,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 17),
                          ),
                        )
                      : SizedBox()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget urlButtons(
      {String url, Icon icon, BuildContext context, Color color}) {
    return Container(
      width: 100,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: RaisedButton(
        color: color,
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

  static PreferredSizeWidget appBar(
      {String title, Color iconColor, BuildContext context}) {
    void _menuSelected(choice) {
      switch (choice) {
        case 'settings':
          {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Settings()),
            );
          }
          break;
      }
    }

    return AppBar(
      title: Text(title),
      actions: <Widget>[
        PopupMenuButton(
          icon: Icon(
            Icons.settings,
            size: 30,
          ),
          onSelected: _menuSelected,
          color: Colors.white,
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: 'settings',
                child: Container(
                    child: Text(translatedText("app_title_settings", context))),
              ),
            ];
          },
        ),
      ],
    );
    // return AppBar(
    //   title: Text(title),
    //   iconTheme: IconThemeData(color: iconColor),
    // );
  }
}
