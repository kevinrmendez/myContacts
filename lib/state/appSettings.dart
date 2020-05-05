import 'package:flutter/material.dart';
import 'package:kevin_app/utils/myThemes.dart';

class AppSettings extends InheritedWidget {
  final bool camera;
  final Function callback;
  final ThemeData theme;
  final MyThemeKeys themeKey;
  Color color;

  AppSettings(
      {this.callback,
      this.camera,
      this.themeKey,
      this.theme,
      Widget child,
      this.color})
      : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static AppSettings of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(AppSettings);
}
