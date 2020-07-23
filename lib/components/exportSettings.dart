import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:kevin_app/db/contactDb.dart';
import 'package:kevin_app/utils/admobUtils.dart';
import 'package:kevin_app/utils/fileUtils.dart';
import 'package:kevin_app/utils/utils.dart';
import 'package:kevin_app/utils/widgetUitls.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

final ContactDb db = ContactDb();
final _scaffoldKey = GlobalKey<ScaffoldState>();
final snackBar = (text) => SnackBar(content: Text(text));

class ExportSettings extends StatefulWidget {
  @override
  _ExportSettingsState createState() => _ExportSettingsState();
}

class _ExportSettingsState extends State<ExportSettings> {
  // PermissionStatus _permissionStatus;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetUtils.settingsTile(
        icon: Icons.import_export,
        title: translatedText("settings_export_contacts", context),
        onTap: () async {
          var permissionStatus = await Permission.storage.status;
          print(permissionStatus);
          switch (permissionStatus) {
            case PermissionStatus.granted:
              {
                showDialog(context: context, builder: (_) => ExportDialog());
                WidgetUtils.showSnackbar(
                    translatedText("snackbar_contact_exported", context),
                    context);
              }
              break;
            case PermissionStatus.undetermined:
              {
                Permission.storage.request();
              }
              break;
            case PermissionStatus.denied:
              {
                Permission.storage.request();
              }
              break;
            default:
          }
        });
  }
}

class ExportDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WidgetUtils.dialog(
      title: translatedText("settings_export_contacts", context),
      context: context,
      height: MediaQuery.of(context).size.height * .6,
      child: ExportDialogContent(),
    );
  }
}

class ExportDialogContent extends StatefulWidget {
  final List<String> filepaths = [];
  @override
  _ExportDialogContentState createState() => _ExportDialogContentState();
}

class _ExportDialogContentState extends State<ExportDialogContent> {
  bool isPdfSelected;
  bool isCsvSelected;
  bool isVcfSelected;
  bool contactsExported;
  bool contactsExporting;

  @override
  void initState() {
    super.initState();
    isPdfSelected = false;
    isCsvSelected = false;
    isVcfSelected = false;
    contactsExported = false;
    contactsExporting = false;
  }

  void _exportContacts() async {
    if (isPdfSelected) {
      await _createPdf();
    }
    if (isCsvSelected) {
      await _createCsv();
    }
    if (isVcfSelected) {
      await _createVcard();
    }
    _sendEmail(filePaths: widget.filepaths);
    Navigator.of(context).pop();
    setState(() {
      // contactsExporting = false;
      contactsExported = true;
    });
  }

  _sendEmail({List<String> filePaths}) async {
    print("FILEPATHS: ${filePaths.toString()}");

    final Email email = Email(
        body: translatedText("email_body", context),
        subject: translatedText("email_subject", context),
        // recipients: ['example@example.com'],
        attachmentPaths: filePaths);
    print("FILEPATHS: ${filePaths.toString()}");
    await FlutterEmailSender.send(email);
    // _scaffoldKey.currentState.showSnackBar(
    //     snackBar(translatedText("snackbar_contact_exported", context)));
  }

  Future<void> _createCsv() async {
    Directory dir = await getExternalStorageDirectory();
    String file = await FileUtils.createCsv(dir);
    widget.filepaths.add(file);
  }

  Future<void> _createPdf() async {
    Directory dir = await getExternalStorageDirectory();
    String file = await FileUtils.createPdf(dir);
    widget.filepaths.add(file);
  }

  Future<void> _createVcard() async {
    Directory dir = await getExternalStorageDirectory();
    String file = await FileUtils.createVcard(dir);
    widget.filepaths.add(file);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              contactsExporting
                  ? SizedBox()
                  : Column(children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .8,
                        child: Text(
                          translatedText(
                              "settings_export_description", context),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ]),
              contactsExporting
                  ? Column(children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          translatedText("dialog_exporting_contacts", context),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      CircularProgressIndicator()
                    ])
                  : Column(children: [
                      CheckboxListTile(
                        title: Text('pdf'),
                        value: isPdfSelected,
                        onChanged: (bool value) {
                          setState(() {
                            isPdfSelected = value;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text('csv'),
                        value: isCsvSelected,
                        onChanged: (bool value) {
                          setState(() {
                            isCsvSelected = value;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: Text('vcf'),
                        value: isVcfSelected,
                        onChanged: (bool value) {
                          setState(() {
                            isVcfSelected = value;
                          });
                        },
                      ),
                    ]),
              SizedBox(
                height: 10,
              ),
              contactsExporting
                  ? SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            translatedText("button_export", context),
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          onPressed: () {
                            _exportContacts();
                            setState(() {
                              contactsExporting = true;
                            });
                            // Navigator.of(context).pop();
                          },
                        ),
                        RaisedButton(
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            translatedText("button_close", context),
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
            ],
          )
        ],
      ),
    );
  }
}
