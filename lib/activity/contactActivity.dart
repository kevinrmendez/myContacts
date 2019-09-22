import 'package:flutter/material.dart';
import 'package:kevin_app/appSettings.dart';
import 'package:kevin_app/components/contactImage.dart';
import 'dart:async';
import 'package:kevin_app/components/contact_form.dart';
import 'package:flutter/services.dart';

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
  final instagramController = TextEditingController();

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

  Widget _buildImage({double height}) {
    return ContactImage(image: _image, height: height);
  }

  Widget _buildVerticalLayout(Orientation orientation) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                'Add contact',
                style: TextStyle(fontSize: 30),
              )),
          _buildImage(height: 200),
          // _streamBuilder(),
          // Container(height: 100, child: Image.asset('assets/person.png')),
          ContactForm(
            image: _image,
            callback: callback,
            orientation: orientation,
            nameController: nameController,
            phoneController: phoneController,
            emailController: emailController,
            instagramController: instagramController,
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalLayout(Orientation orientation) {
    return Center(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        'Add contact',
                        style: TextStyle(fontSize: 30),
                      )),
                  _buildImage(height: 100),
                  // _streamBuilder(),
                  Container(
                    width: 200,
                  )
                ],
              ),
              ContactForm(
                image: _image,
                orientation: orientation,
                callback: callback,
                nameController: nameController,
                phoneController: phoneController,
                emailController: emailController,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Contacts'),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        var orientation = MediaQuery.of(context).orientation;
        return orientation == Orientation.portrait
            ? _buildVerticalLayout(orientation)
            : _buildHorizontalLayout(orientation);
      }),
    );
  }
}
