import 'package:flutter/material.dart';

enum MyThemeKeys { BLUE, RED, GREEN, DARK, PINK, YELLOW, NAVY }

class MyThemes {
  static final ThemeData blueTheme = ThemeData(
    primaryColor: Colors.blue,
    primaryIconTheme: IconThemeData(color: Colors.white),
    accentColor: Colors.blue[200],
    brightness: Brightness.light,
  );

  static final ThemeData redTheme = ThemeData(
    primaryColor: Colors.red,
    accentColor: Colors.red[200],
    brightness: Brightness.light,
  );

  static final ThemeData yellowTheme = ThemeData(
    primaryColor: Colors.yellow,
    accentColor: Colors.yellow[200],
    brightness: Brightness.light,
  );
  static final ThemeData navyTheme = ThemeData(
    primaryColor: Color.fromRGBO(0, 0, 139, 1),
    accentColor: Color.fromRGBO(255, 228, 53, 1),
    brightness: Brightness.light,
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.cyan,
    accentColor: Colors.cyan,
    brightness: Brightness.dark,
  );

  static final ThemeData greenTheme = ThemeData(
    primaryColor: Colors.green,
    accentColor: Colors.green[200],
    brightness: Brightness.light,
  );
  static final ThemeData pinkTheme = ThemeData(
    primaryColor: Colors.pink,
    accentColor: Colors.pink[200],
    brightness: Brightness.light,
  );

  static ThemeData getThemeFromKey(MyThemeKeys themeKey) {
    switch (themeKey) {
      case MyThemeKeys.BLUE:
        return blueTheme;
      case MyThemeKeys.RED:
        return redTheme;
      case MyThemeKeys.GREEN:
        return greenTheme;
      case MyThemeKeys.YELLOW:
        return yellowTheme;
      case MyThemeKeys.PINK:
        return pinkTheme;
      case MyThemeKeys.NAVY:
        return navyTheme;
      case MyThemeKeys.DARK:
        return darkTheme;
      default:
        return blueTheme;
    }
  }
}
