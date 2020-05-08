import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kevin_app/activity/backupActivityList.dart';
import 'package:kevin_app/utils/fileUtils.dart';
import 'package:kevin_app/utils/utils.dart';
import 'package:kevin_app/utils/widgetUitls.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BackupActivity extends StatefulWidget {
  const BackupActivity({Key key}) : super(key: key);

  @override
  BackupActivityState createState() => BackupActivityState();
}

class BackupActivityState extends State<BackupActivity> {
  Directory dir;
  String path;
  List files = [];
  List directories = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final snackBar = (text) => SnackBar(content: Text(text));

  @override
  void initState() {
    super.initState();
    _getFiles();
  }

  _getFiles() async {
    dir = await getExternalStorageDirectory();
    path = dir.absolute.path;

    setState(() {
      //list of file paths
      dir.listSync().forEach((f) {
        print("FILETYPE: ${f.runtimeType}");
        if (f is File) {
          files.add(f.path);
        } else {
          directories.add(f.path);
        }
        // return f.path;
      });
    });
    files.forEach(((f) => print("FILE $f")));
  }

  _createBackup() async {
    Directory dir = await getExternalStorageDirectory();
    String path = dir.absolute.path;
    DateTime date = DateTime.now();
    String folderName = "mycontacts_$date";
    Directory newDir = Directory("$path/$folderName");
    newDir.create();
    dir.listSync();
    print("FOLDER NAME: $folderName");
    setState(() {
      //list of file paths
      directories = dir.listSync().map((f) => f.path).toList();
    });
    directories.forEach(((f) => print("FILE $f")));
    await FileUtils.createCsv(newDir);
    await FileUtils.createPdf(newDir);
    await FileUtils.createVcard(newDir);
    List newFilelist = [];
    newFilelist = newDir.listSync();
    print("NEWFILELIST $newFilelist");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text(translatedText("app_title_about", context))),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('backup'),
              Column(
                children: <Widget>[
                  WidgetUtils.largeButton(
                      title: "create backup",
                      onPressed: () {
                        _createBackup();
                        _scaffoldKey.currentState.showSnackBar(
                            new SnackBar(content: Text("backup created")));
                      },
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor),
                  directories.length > 0
                      ? WidgetUtils.largeButton(
                          title: "check backups",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BackupActivityList()),
                            );
                          },
                          textColor: Colors.white,
                          color: Theme.of(context).primaryColor)
                      : SizedBox(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
