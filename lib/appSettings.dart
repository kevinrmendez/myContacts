import 'package:flutter/material.dart';
import 'package:kevin_app/myThemes.dart';

class AppSettings extends InheritedWidget {
  final Brightness brightness;
  final bool camera;
  final Function callback;
  final bool darkMode;
  final ThemeData theme;
  final MyThemeKeys themeKey;

  AppSettings(
      {this.brightness,
      this.callback,
      this.camera,
      this.darkMode,
      this.themeKey,
      this.theme,
      Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static AppSettings of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(AppSettings);
}
