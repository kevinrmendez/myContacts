import 'dart:io';
import 'dart:wasm';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:kevin_app/activity/Settings.dart';
import 'package:kevin_app/activity/cameraActivity.dart';
import 'package:kevin_app/activity/contactEdit.dart';
import 'package:kevin_app/models/contact.dart';

import 'package:kevin_app/utils/admobUtils.dart';
import 'package:kevin_app/utils/colors.dart';
import 'package:kevin_app/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class WidgetUtils {
  static showSnackbar(String text, BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  static Widget contactSearchTextField(
      {BuildContext context, TextEditingController filter}) {
    return Material(
      elevation: 10,
      child: TextField(
        style: TextStyle(color: GREY, fontSize: 17),
        controller: filter,
        decoration: new InputDecoration(
          border: InputBorder.none,
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
      ),
    );
  }

  static Widget buildCamera(
      String image, BuildContext context, Function callback) {
    return RaisedButton(
      color: Theme.of(context).accentColor,
      onPressed: () async {
        var permissionStatus = await Permission.camera.status;

        final cameras = await availableCameras();
        final firstCamera = cameras.first;

        switch (permissionStatus) {
          case PermissionStatus.granted:
            {
              image = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CameraActivity(
                          camera: firstCamera,
                        )),
              );
              callback(image);
              Scaffold.of(context).showSnackBar(SnackBar(
                  content:
                      Text(translatedText("message_picture_taken", context))));
              print(image.toString());
            }
            break;
          case PermissionStatus.undetermined:
            {
              Permission.camera.request();
            }
            break;
          case PermissionStatus.denied:
            {
              Permission.camera.request();
            }
            break;
          default:
        }
      },
      child: Icon(
        Icons.camera_alt,
        color: Colors.white,
      ),
    );
  }

  static Widget contactListTile(
      int index, Contact contact, BuildContext context) {
    Route _createRoute() {
      return PageRouteBuilder(
        transitionDuration: Duration(seconds: 1),
        pageBuilder: (context, animation, secondaryAnimation) => ContactEdit(
          contact: contact,
          index: index,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.easeIn;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(_createRoute());
        },
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: Theme.of(context).primaryColor,
          backgroundImage: contact.image == "" || contact.image == null
              ? AssetImage('assets/person-icon-w-s3p.png')
              : FileImage(File(contact.image)),
        ),
        title: Text(
          '${contact.name}',
          style: TextStyle(fontSize: 22),
        ),
        trailing: Icon(
            contact.favorite == 0 ? Icons.keyboard_arrow_right : Icons.star),
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

  static Widget largeButton(
      {String title, Function onPressed, Color textColor, Color color}) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      width: 200,
      child: RaisedButton(
          elevation: 10,
          color: color,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor, fontSize: 22),
          ),
          onPressed: onPressed),
    );
  }

  static Widget urlButtons({String url, IconData icon, BuildContext context}) {
    return Container(
      width: 80,
      height: 35,
      padding: EdgeInsets.fromLTRB(
        10,
        2,
        10,
        2,
      ),
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        child: Icon(
          icon,
          size: 20,
          color: Colors.white,
        ),
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

  static Widget settingsTile({String title, Function onTap, IconData icon}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontSize: 16.5),
            ),
            Icon(
              icon,
              color: GREY,
            )
          ],
        ),
      ),
    );
  }

  static Dialog dialog(
      {Widget child,
      BuildContext context,
      String title,
      double height,
      bool showAd = true}) {
    return Dialog(
      child: Container(
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                padding: EdgeInsets.symmetric(vertical: 14),
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).primaryColor,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 22),
                )),
            SizedBox(
              height: 10,
            ),
            child,
            SizedBox(
              height: 10,
            ),
            showAd ? AdmobUtils.admobBanner() : SizedBox()
          ],
        ),
      ),
    );
  }

  static Widget textButton(
      {BuildContext context,
      String title,
      Function onPress,
      double buttonWidth = 120}) {
    return Container(
      width: buttonWidth,
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        child: Container(
          width: 100,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
        onPressed: onPress,
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
