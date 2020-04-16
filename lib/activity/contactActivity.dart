import 'package:flutter/material.dart';
import 'package:kevin_app/appSettings.dart';
import 'package:kevin_app/components/contactImage.dart';
import 'package:kevin_app/components/contactImageFull.dart';
import 'dart:async';
import 'package:kevin_app/components/contact_form.dart';
import 'package:flutter/services.dart';
import 'package:kevin_app/utils/admobUtils.dart';

import 'cameraActivity.dart';

class ContactActivity extends StatefulWidget {
  @override
  ContactActivityState createState() => ContactActivityState();
}

class ContactActivityState extends State<ContactActivity>
    with WidgetsBindingObserver {
  String _image = "";
  AppLifecycleState appState;
  AppLifecycleState appLifecycleState;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  callback(value) {
    setState(() {
      _image = value;
    });
  }

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
      appBar: AppBar(
        title: Text(
          'MyContacts',
        ),
      ),
      body: Center(
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AdmobUtils.admobBanner(),
            ContactImageFull(
              image: _image,
            ),

            // _streamBuilder(),
            // Container(height: 100, child: Image.asset('assets/person.png')),
            Align(
              alignment: Alignment.center,
              child: ContactForm(
                image: _image,
                callback: callback,
                nameController: nameController,
                phoneController: phoneController,
                emailController: emailController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
