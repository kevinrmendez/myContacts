import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:kevin_app/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BackupActivity extends StatefulWidget {
  const BackupActivity({Key key}) : super(key: key);

  @override
  _BackupActivityState createState() => _BackupActivityState();
}

class _BackupActivityState extends State<BackupActivity> {
  Directory dir;
  String path;
  List files = [];
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
              Column(children: [
                files.length == 0
                    ? SizedBox()
                    : Column(
                        children: _buildListFiles(),
                      )
              ])
            ],
          ),
        ),
      ),
    );
  }
}
