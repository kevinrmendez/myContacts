import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutActivity extends StatelessWidget {
  const AboutActivity({Key key}) : super(key: key);

  _text(String text, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .8,
      padding: EdgeInsets.symmetric(vertical: 5),
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
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Icon(
              Icons.info,
              color: Theme.of(context).primaryColor,
              size: 60,
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('About')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _title('About MyContacts'),
              _text(
                  'MyContacts is a free app that will help you to manage your contacts.',
                  context),
              _text(
                  'All the data that is store in the app is saved on the device memory',
                  context),
              _text(
                  'You can import your contacts from your phone manually from the settings',
                  context),
              _text(
                  'If you delete contacts from the app, they will not be deleted from your phone',
                  context),
              _text(
                  'The user is responsible of proper use of the app and proper handling and storage of their contacts data',
                  context),
              _text(
                  'In order to keep this app free to use, it contains some ads',
                  context),
              _text("If you enjoy using the app, don't forget to rate the app",
                  context),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    'Rate App',
                    style: TextStyle(color: Colors.white, fontSize: 25),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
