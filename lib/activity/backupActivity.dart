import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kevin_app/activity/backupActivityList.dart';
import 'package:kevin_app/state/appState.dart';
import 'package:kevin_app/utils/colors.dart';
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
    // String dateFormatted = DateFormat("dd-MM-yyyy").format(date);
    // String folderName = "mycontacts_$dateFormatted";
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
      appBar: AppBar(title: Text(translatedText("app_title_backup", context))),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                translatedText("title_backup", context),
                style: TextStyle(fontSize: 28),
              ),
              Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Icon(
                      Icons.backup,
                      size: 60,
                      color: GREY,
                    ),
                  ),
                  contactService.current.length > 0
                      ? WidgetUtils.largeButton(
                          title:
                              translatedText("button_backup_create", context),
                          onPressed: () {
                            _createBackup();
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text(translatedText(
                                    "snackbar_contact_backup_created",
                                    context))));
                          },
                          textColor: Colors.white,
                          color: Theme.of(context).primaryColor)
                      : Container(
                          width: MediaQuery.of(context).size.width * .8,
                          child: Column(children: [
                            Text(
                              translatedText("text_backup_empty_list", context),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                            Text(
                              translatedText(
                                  "text_backup_empty_list_instructions",
                                  context),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            )
                          ]),
                        ),
                  directories.length > 0
                      ? WidgetUtils.largeButton(
                          title: translatedText("button_backup_list", context),
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
