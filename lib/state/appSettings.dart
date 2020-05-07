import 'package:flutter/material.dart';
import 'package:kevin_app/utils/myThemes.dart';

class AppSettings extends InheritedWidget {
  final Function callback;
  Color color;
  bool showSetupScreen;

  AppSettings({this.callback, Widget child, this.color, this.showSetupScreen})
      : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static AppSettings of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(AppSettings);
}
