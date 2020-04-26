import 'package:flutter/material.dart';
import 'package:kevin_app/activity/Settings.dart';
import 'package:kevin_app/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class WidgetUtils {
  static showSnackbar(String text, BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
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

  // static Widget bottomNavigation(BuildContext context){
  //  return BottomNavigationBar(
  //           type: BottomNavigationBarType.shifting,
  //           selectedItemColor: Color(0xFF6A6A6C),
  //           unselectedItemColor: Colors.grey,
  //           selectedLabelStyle: TextStyle(
  //             color: Theme.of(context).primaryColor,
  //           ),
  //           unselectedLabelStyle: TextStyle(
  //             color: Colors.grey,
  //           ),
  //           showUnselectedLabels: true,
  //           currentIndex: _currentIndex,
  //           onTap: onTabTapped,
  //           items: [
  //             BottomNavigationBarItem(
  //                 icon: Icon(
  //                   Icons.home,
  //                   // color: Theme.of(context).primaryColor,
  //                 ),
  //                 title: Text(translatedText("menu_home", context))),
  //             BottomNavigationBarItem(
  //                 icon: Icon(Icons.contacts),
  //                 title:Text(translatedText("menu_contactList", context))),
  //             BottomNavigationBarItem(
  //                 icon: Icon(Icons.star),
  //                 title:Text(translatedText("menu_favorite", context))),
  //             BottomNavigationBarItem(
  //                 icon: Icon(Icons.group),
  //                 title:Text(translatedText("menu_groups", context))),
  //             // BottomNavigationBarItem(
  //             //     icon: Icon(Icons.settings),
  //             //     title: _bottomMenuTitle("menu_settings")),
  //           ])
  // }

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
