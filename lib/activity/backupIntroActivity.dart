import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:kevin_app/utils/utils.dart';
import 'package:kevin_app/utils/widgetUitls.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BackupActivityIntro extends StatefulWidget {
  const BackupActivityIntro({Key key}) : super(key: key);

  @override
  BackupActivityIntroState createState() => BackupActivityIntroState();
}

class BackupActivityIntroState extends State<BackupActivityIntro> {
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
      files = dir.listSync().map((f) => f.path).toList();
    });
    files.forEach(((f) => print("FILE $f")));
  }

  _deleteFile(String pathFile) async {
    String fileName = pathFile.split('/').last;
    print("FILENAME: $fileName");
    Directory dir = await getExternalStorageDirectory();
    String path = dir.absolute.path;
    File file = File("${path}/${fileName}");
    print("$path/$fileName");
    // File file = File('$path/contact.vcf');
    file.delete();
  }

  _sendFile(String pathFile) async {
    Directory dir = await getExternalStorageDirectory();
    String fileName = pathFile.split('/').last;

    String path = dir.absolute.path;
    String filePath = "$path/$fileName";
    final Email email = Email(
      body: translatedText("text", context),
      subject: translatedText("email_csv_subject", context),
      // recipients: ['example@example.com'],
      attachmentPaths: [filePath],
    );
    await FlutterEmailSender.send(email);
    _scaffoldKey.currentState.showSnackBar(
        snackBar(translatedText("snackbar_contact_exported", context)));
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
  }

  List<Widget> _buildListFiles() {
    return files.map((file) {
      String fileName = file.split('/').last;

      return ListTile(
        title: Text(fileName),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteFile(file.toString());
                files.remove(file);
                setState(() {
                  files = files;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                _sendFile(file);
              },
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      },
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor),
                  WidgetUtils.largeButton(
                      title: "check backups",
                      onPressed: () {},
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
