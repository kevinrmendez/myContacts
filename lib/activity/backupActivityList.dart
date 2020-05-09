import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:kevin_app/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BackupActivityList extends StatefulWidget {
  const BackupActivityList({Key key}) : super(key: key);

  @override
  _BackupActivityListState createState() => _BackupActivityListState();
}

class _BackupActivityListState extends State<BackupActivityList> {
  Directory dir;
  String path;
  List directories = [];
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

  // _deleteFile(String pathFile) async {
  //   String fileName = pathFile.split('/').last;
  //   print("FILENAME: $fileName");
  //   Directory dir = await getExternalStorageDirectory();
  //   String path = dir.absolute.path;
  //   File file = File("${path}/${fileName}");
  //   print("$path/$fileName");
  //   // File file = File('$path/contact.vcf');
  //   file.delete();
  // }
  _deleteDirectory(String pathDirectory) async {
    String directoryName = pathDirectory.split('/').last;
    print("FILENAME: $directoryName");
    Directory dir = await getExternalStorageDirectory();
    String path = dir.absolute.path;
    Directory directory = Directory("${path}/${directoryName}");
    print("$path/$directoryName");
    // File file = File('$path/contact.vcf');
    directory.delete(recursive: true);
  }

  // _sendFile(String pathFile) async {
  //   Directory dir = await getExternalStorageDirectory();
  //   String fileName = pathFile.split('/').last;

  //   String path = dir.absolute.path;
  //   String filePath = "$path/$fileName";
  //   final Email email = Email(
  //     body: translatedText("text", context),
  //     subject: translatedText("email_csv_subject", context),
  //     // recipients: ['example@example.com'],
  //     attachmentPaths: [filePath],
  //   );
  //   await FlutterEmailSender.send(email);
  //   _scaffoldKey.currentState.showSnackBar(
  //       snackBar(translatedText("snackbar_contact_exported", context)));
  // }

  _sendDirectory(String pathFile) async {
    List<String> filePaths = [];
    Directory dir = await getExternalStorageDirectory();
    String directoryName = pathFile.split('/').last;
    String path = dir.absolute.path;
    String direcotyPath = "$path/$directoryName";
    Directory directory = Directory(direcotyPath);

    filePaths = directory.listSync().map((f) {
      print("FILETYPE: ${f.runtimeType}");
      return f.path;
    }).toList();

    final Email email = Email(
      body: translatedText("email_body", context),
      subject: translatedText("email_subject", context),
      // recipients: ['example@example.com'],
      attachmentPaths: filePaths,
    );
    await FlutterEmailSender.send(email);
    _scaffoldKey.currentState.showSnackBar(
        snackBar(translatedText("snackbar_contact_exported", context)));
  }

  // List<Widget> _buildListFiles() {
  //   return files.map((file) {
  //     String fileName = file.split('/').last;

  //     return ListTile(
  //       title: Text(fileName),
  //       trailing: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           IconButton(
  //             icon: Icon(Icons.delete),
  //             onPressed: () {
  //               _deleteFile(file.toString());
  //               files.remove(file);
  //               setState(() {
  //                 files = files;
  //               });
  //             },
  //           ),
  //           IconButton(
  //             icon: Icon(Icons.send),
  //             onPressed: () {
  //               _sendFile(file);
  //             },
  //           ),
  //         ],
  //       ),
  //     );
  //   }).toList();
  // }

  List<Widget> _buildListDirectories() {
    return directories.map((directory) {
      String fileName = directory.split('/').last;
      String dateString = fileName.split('_').last;
      String backupName =
          "${translatedText("text_backup", context)} $dateString";

      return ListTile(
        title: Text(backupName),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await _deleteDirectory(directory.toString());
                directories.remove(directory);
                setState(() {
                  directories = directories;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                _sendDirectory(directory);
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
      appBar: AppBar(title: Text(translatedText("app_title_backup", context))),
      body: directories.length > 0
          ? SingleChildScrollView(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    translatedText("title_backup_list", context),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26),
                  ),
                ),
                Column(children: [
                  Column(
                    children: _buildListDirectories(),
                  )
                ])
              ],
            ))
          : Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      // padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        translatedText("title_backup_list", context),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 26),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      translatedText("text_backup_empty", context),
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ]),
            ),
    );
  }
}
