import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:kevin_app/components/contact_form.dart';

class ContactActivity2 extends StatefulWidget {
  @override
  ContactActivityState2 createState() => ContactActivityState2();
}

class ContactActivityState2 extends State<ContactActivity2> {
  String _image = "";
  final StreamController<String> _streamController =
      StreamController<String>.broadcast();

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
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
          StreamBuilder<String>(
            stream: _streamController.stream,
            initialData: _image,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return snapshot.data == "" || snapshot.data == null
                  ? Container(
                      height: 80, child: Image.asset('assets/person.png'))
                  : Container(
                      height: 200, child: Image.file(File(snapshot.data)));
            },
          ),
          // Container(height: 100, child: Image.asset('assets/person.png')),
          ContactForm(streamController: _streamController),
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
              StreamBuilder<String>(
                stream: _streamController.stream,
                initialData: _image,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return snapshot.data == "" || snapshot.data == null
                      ? Container(
                          height: 80, child: Image.asset('assets/person.png'))
                      : Container(
                          height: 200, child: Image.file(File(snapshot.data)));
                },
              ),
            ],
          ),
          // Container(height: 100, child: Image.asset('assets/person.png')),
          ContactForm(streamController: _streamController),
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
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => ContactList()),
          // );
          Navigator.pushNamed(context, '/contactList');
        },
      ),
    );
  }
}
