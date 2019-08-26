import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:kevin_app/components/contact_form.dart';
import 'package:flutter/services.dart';

import 'cameraActivity.dart';

class ContactActivity2 extends StatefulWidget {
  @override
  ContactActivityState2 createState() => ContactActivityState2();
}

class ContactActivityState2 extends State<ContactActivity2>
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

  Widget _buildVerticalLayout() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                'Add contact',
                style: TextStyle(fontSize: 30),
              )),
          _image == "" || _image == null
              ? Container(height: 80, child: Image.asset('assets/person.png'))
              : Container(height: 200, child: Image.file(File(_image))),
          // _streamBuilder(),

          // Container(height: 100, child: Image.asset('assets/person.png')),
          ContactForm(
            image: _image,
            callback: callback,
            nameController: nameController,
            phoneController: phoneController,
            emailController: emailController,
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalLayout() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: 20, bottom: 30),
                  child: Text(
                    'Add contact',
                    style: TextStyle(fontSize: 30),
                  )),
              _image == "" || _image == null
                  ? Container(
                      height: 80, child: Image.asset('assets/person.png'))
                  : Container(height: 170, child: Image.file(File(_image))),
              // _streamBuilder(),
              Container(
                width: 200,
              )
            ],
          ),
          // Container(height: 100, child: Image.asset('assets/person.png')),
          ContactForm(
            image: _image,
            callback: callback,
            nameController: nameController,
            phoneController: phoneController,
            emailController: emailController,
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
            ? _buildVerticalLayout()
            : _buildHorizontalLayout();
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.contacts),
        onPressed: () {
          Navigator.pushNamed(context, '/contactList');
        },
      ),
    );
  }
}
