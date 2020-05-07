import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:kevin_app/activity/Settings.dart';
import 'package:kevin_app/components/contactActivityComponent.dart';
import 'package:kevin_app/components/contactImage.dart';
import 'package:kevin_app/components/contactImage.dart';
import 'package:kevin_app/components/contactImage.dart';
import 'dart:async';
import 'package:kevin_app/components/contact_form.dart';
import 'package:flutter/services.dart';
import 'package:kevin_app/contact.dart';
import 'package:kevin_app/contactDb.dart';
import 'package:kevin_app/state/appState.dart';
import 'package:kevin_app/utils/admobUtils.dart';
import 'package:kevin_app/utils/colors.dart';
import 'package:kevin_app/utils/utils.dart';
import 'package:kevin_app/utils/widgetUitls.dart';
import 'package:permission_handler/permission_handler.dart';

import '../app_localizations.dart';
import 'cameraActivity.dart';

class ContactActivity extends StatefulWidget {
  final PermissionHandler _permissionHandler = PermissionHandler();
  final _formKey = GlobalKey<FormState>();

  @override
  ContactActivityState createState() => ContactActivityState();

  Future<bool> _requestCameraPermission() async {
    var result =
        await _permissionHandler.requestPermissions([PermissionGroup.camera]);

    if (result[PermissionGroup.contacts] == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }
}

class ContactActivityState extends State<ContactActivity>
    with WidgetsBindingObserver {
  AppLifecycleState appState;
  AppLifecycleState appLifecycleState;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState appLifecycleState) {
    appState = appLifecycleState;
    print(appLifecycleState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: ContactActivityComponent(context));
  }
}
