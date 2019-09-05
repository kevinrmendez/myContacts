import 'package:flutter/cupertino.dart';

class AppSettings extends InheritedWidget {
  final Brightness brightness;
  final bool camera;
  final Function callback;
  final bool darkMode;

  AppSettings(
      {this.brightness,
      this.callback,
      this.camera,
      this.darkMode,
      Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static AppSettings of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(AppSettings);
}
