import 'package:flutter/material.dart';
import 'package:prefs/prefs.dart';

import '../appSettings.dart';
import '../myThemes.dart';

class ExpandableThemeSettings extends StatefulWidget {
  @override
  ExpandableThemeSettingsState createState() => ExpandableThemeSettingsState();
}

class ExpandableThemeSettingsState extends State<ExpandableThemeSettings> {
  // This widget is the root of your application.
  bool changeTheme;
  List<Item> items = [Item(headerValue: 'Theme')];
  ThemeData _theme;
  MyThemeKeys themekey;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppSettings appState = AppSettings.of(context);
    void _changeTheme(value) async {
      setState(() {
        themekey = value;
      });
      _theme = MyThemes.getThemeFromKey(themekey);
      appState.callback(theme: _theme, themeKey: themekey);
      print('hola');

      print(appState.themeKey);
      print(themekey.toString());
      switch (value) {
        case MyThemeKeys.BLUE:
          await Prefs.setInt('themekey', 0);
          break;
        case MyThemeKeys.RED:
          await Prefs.setInt('themekey', 1);
          break;
        case MyThemeKeys.GREEN:
          await Prefs.setInt('themekey', 2);
          break;
        case MyThemeKeys.RED:
          await Prefs.setInt('themekey', 3);
          break;
        case MyThemeKeys.RED:
          await Prefs.setInt('themekey', 4);
          break;

        default:
      }
    }

    return ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            items[index].isExpanded = !isExpanded;
          });
        },
        children: items.map<ExpansionPanel>((Item item) {
          return ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(item.headerValue),
              );
            },
            body: Card(
              child: Column(children: [
                ListTile(
                  title: const Text('Blue'),
                  leading: Radio(
                    value: MyThemeKeys.BLUE,
                    groupValue: themekey,
                    onChanged: (value) {
                      _changeTheme(value);
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Red'),
                  leading: Radio(
                    value: MyThemeKeys.RED,
                    groupValue: themekey,
                    onChanged: (value) {
                      _changeTheme(value);
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Green'),
                  leading: Radio(
                    value: MyThemeKeys.GREEN,
                    groupValue: themekey,
                    onChanged: (value) {
                      _changeTheme(value);
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Pink'),
                  leading: Radio(
                    value: MyThemeKeys.PINK,
                    groupValue: themekey,
                    onChanged: (value) {
                      _changeTheme(value);
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Dark'),
                  leading: Radio(
                    value: MyThemeKeys.DARK,
                    groupValue: themekey,
                    onChanged: (value) {
                      _changeTheme(value);
                    },
                  ),
                ),
              ]),
            ),
            canTapOnHeader: true,
            isExpanded: item.isExpanded,
          );
        }).toList());
  }
}

class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  List<Widget> expandedValue;
  String headerValue;
  bool isExpanded;
}
