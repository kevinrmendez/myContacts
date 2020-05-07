import 'package:flutter/material.dart';
import 'package:kevin_app/main.dart';
import 'package:kevin_app/state/appSettings.dart';
import 'package:kevin_app/utils/permissionsUtils.dart';
import 'package:kevin_app/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class SetupActivity extends StatefulWidget {
  final snackBar = SnackBar(content: Text('Contacts imported'));

  final PermissionHandler _permissionHandler = PermissionHandler();

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
    await PermissionsUtils.requestPermission(
        widget._permissionHandler, PermissionGroup.camera);
    await PermissionsUtils.requestPermission(
        widget._permissionHandler, PermissionGroup.contacts);
    await PermissionsUtils.requestPermission(
        widget._permissionHandler, PermissionGroup.storage);
  }

  @override
  void initState() {
    super.initState();
    isContactedImported = false;

    _requestPermissions();
    _startSetup();
  }

  _buildButton({String title, Function onPressed}) {
    return Container(
      width: 200,
      child: RaisedButton(
          elevation: 10,
          color: Colors.white,
          child: Text(
            title,
            style: TextStyle(color: Colors.blue, fontSize: 22),
          ),
          onPressed: onPressed),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.blue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Welcome to",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 40),
              ),
              Text(
                "MyContacts",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 40),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/person-icon-w-s3p.png'))),
                ),
              ),
              // CircularProgressIndicator(backgroundColor: Colors.white),
              Column(
                children: <Widget>[
                  isContactedImported
                      ? Container(
                          width: MediaQuery.of(context).size.width * .7,
                          child: Column(children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text(
                                "Your contacts have been imported",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 28),
                              ),
                            ),
                            _buildButton(
                              title: "continue",
                              onPressed: () async {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home()),
                                    (Route<dynamic> route) => false);
                                AppSettings.of(context)
                                    .callback(showSetupScreen: false);
                                prefs.setBool('showSetupScreen', false);
                              },
                            )
                          ]),
                        )
                      : _buildButton(
                          title: "import Contacts",
                          onPressed: () {
                            importContacts(context);
                            //TODO: change state after contacts
                            Future.delayed(const Duration(milliseconds: 700),
                                () {
                              setState(() {
                                isContactedImported = true;
                              });
                              Scaffold.of(context)
                                  .showSnackBar(widget.snackBar);

                              // _requestPermissions();
                            });
                          },
                        ),
                  isContactedImported
                      ? SizedBox()
                      : _buildButton(
                          title: "skip",
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => Home()),
                                (Route<dynamic> route) => false);
                            AppSettings.of(context)
                                .callback(showSetupScreen: false);
                            prefs.setBool('showSetupScreen', false);

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => Home()),
                            // );
                          },
                        ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
