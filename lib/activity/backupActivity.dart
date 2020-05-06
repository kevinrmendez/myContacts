import 'dart:io';

import 'package:flutter/material.dart';
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
  List myFiles;

  @override
  void initState() {
    super.initState();
    _getFiles();
  }

  _getFiles() async {
    dir = await getExternalStorageDirectory();
    path = dir.absolute.path;
    files = dir.listSync();

    setState(() {
      myFiles = files;
    });
    files.forEach(((f) => print("FILE $f")));
  }

  _deleteFile(String path) {
    final dir = Directory(path);
    dir.deleteSync(recursive: true);
  }

  List<Widget> _buildListFiles() {
    return myFiles.map((file) {
      return ListTile(
        title: Text(file.toString()),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {},
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
                children: myFiles.length == 0 ? SizedBox() : _buildListFiles(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
