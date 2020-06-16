import 'package:flutter/material.dart';
import 'package:kevin_app/components/importContactsComponent.dart';
import 'package:kevin_app/main.dart';
import 'package:kevin_app/state/appSettings.dart';
import 'package:kevin_app/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class SetupActivity extends StatefulWidget {
  SetupActivity({Key key}) : super(key: key);

  @override
  _SetupActivityState createState() => _SetupActivityState();
}

class _SetupActivityState extends State<SetupActivity> {
  bool isContactedImported;
  _startSetup() {
    Future.delayed(const Duration(milliseconds: 700), () {
      _requestPermissions();
    });
  }

  _requestPermissions() async {
    await Permission.camera.request();
    await Permission.contacts.request();
    await Permission.storage.request();
  }

  @override
  void initState() {
    super.initState();
    isContactedImported = false;

    // _requestPermissions();
    _startSetup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.blue,
          child: ImportContactsComponent(),
        ),
      ),
    );
  }
}
