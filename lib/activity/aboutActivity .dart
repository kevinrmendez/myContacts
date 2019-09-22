import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutActivity extends StatelessWidget {
  const AboutActivity({Key key}) : super(key: key);

  _text(String text) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _title(String text) {
      return Column(
        children: <Widget>[
          Text(
            text,
            style: TextStyle(fontSize: 30),
          ),
          Icon(
            Icons.info,
            color: Theme.of(context).primaryColor,
            size: 100,
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('About')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _title('About MyContacts'),
            _text(
                'MyContacts is a free app that will help you to manage your contatcs. '),
            _text(
                'All the data that is store in the app is saved on the device memory'),
            _text(
                'In order to keep this app free to use, it contains some ads'),
            _text("If you enjoy using the app, don't forget to rate the app"),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text(
                'Rate App',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                String url =
                    "https://play.google.com/store/apps/details?id=com.kevinrmendez.contact_app";
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
