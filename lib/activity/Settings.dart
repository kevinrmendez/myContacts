import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:kevin_app/ContactDb.dart';
import 'package:kevin_app/components/expandableThemeSettings.dart';
import 'package:kevin_app/contact.dart';
import 'package:kevin_app/main.dart';
import 'package:kevin_app/myThemes.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as p;

import 'package:permission_handler/permission_handler.dart';

import 'package:contacts_service/contacts_service.dart' as a;
import 'package:kevin_app/ContactDb.dart';

import 'package:kevin_app/appSettings.dart';
import 'package:csv/csv.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import 'aboutActivity .dart';

final ContactDb _db = ContactDb();
final snackBar = (text) => SnackBar(content: Text(text));

PermissionStatus _permissionStatus;

class Settings extends StatefulWidget {
  @override
  SettingsState createState() {
    return SettingsState();
  }
}

class SettingsState extends State<Settings> {
  bool activateCamera;
  bool importedContacts;
  bool importedContactsProgress;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final ContactDb db = ContactDb();
  // ThemeData _theme;
  // MyThemeKeys themekey;
  // bool isExpanded;

  // Future<int> themekeyprefs;

  // Future<Null> getSharePreferences() async {
  //   prefs = await SharedPreferences.getInstance();
  // }

  @override
  void initState() {
    activateCamera = true;
    importedContacts = (prefs.getBool('importedContacts') ?? false);
    importedContactsProgress = false;
    // isExpanded = false;
    super.initState();
    // Prefs.init();
    // getSharePreferences();
    // themekeyprefs = Prefs.getIntF('themekey') ?? 0;
    // themekey = MyThemeKeys.values[themekeyprefs];
  }

  @override
  Widget build(BuildContext context) {
    //WARNING MESSAGE BEFORE DELETING CONTACTS
    void _warningMessage(String message) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(message),
              actions: <Widget>[
                FlatButton(
                    child: Text('close'),
                    onPressed: () {
                      // Navigator.of(context).pop();
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    }),
                FlatButton(
                    child: Text('ok'),
                    onPressed: () async {
                      await _db.deleteAllContacts();

                      Navigator.pop(context);
                    })
              ],
            );
          });
    }

    _deleteContacts() async {
      _warningMessage('Are you sure you want to delete all your contacts');
    }

    Future<PermissionStatus> _checkPermission(
        PermissionGroup permissionGroup) async {
      PermissionStatus permission =
          await PermissionHandler().checkPermissionStatus(permissionGroup);
      return permission;
    }

    Future<Map<PermissionGroup, PermissionStatus>> _requestPermission(
        PermissionGroup permissionGroup) async {
      // await PermissionHandler()
      //     .shouldShowRequestPermissionRationale(PermissionGroup.contacts);
      // await PermissionHandler().openAppSettings();
      _permissionStatus = await _checkPermission(permissionGroup);
      if (_permissionStatus != PermissionStatus.granted) {
        return await PermissionHandler().requestPermissions([permissionGroup]);
      }
    }

    _importContactsFromService() async {
      Iterable<a.Contact> contacts = await a.ContactsService.getContacts();
      contacts.map((value) {});

      return contacts;
    }

    _importContacts() {
      print('CONTACTS');
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'importing contacts...',
              ),
              content: Container(
                constraints: BoxConstraints(maxHeight: 30, maxWidth: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator()),
                  ],
                ),
              ),
            );
          });

      _requestPermission(PermissionGroup.contacts).then((permission) {
        _importContactsFromService().then((contacts) {
          setState(() {
            importedContactsProgress = true;
          });

          List contactList = contacts.toList();
          contactList.forEach((contact) {
            List phones = contact.phones.toList();
            List emails = contact.emails.toList();
            String email = emails.length > 0 ? emails[0].value : "";
            String phone = phones.length > 0 ? phones[0].value : "";
            String name = contact.displayName;

            Contact newContact =
                Contact(name: name, email: email, phone: phone);

            db.insertContact(newContact);

            print(email);
            print(contact.displayName);
            print(phone);
            // print(phone);
          });
        }).then((onValue) {
          setState(() {
            importedContacts = true;
            prefs.setBool('importedContacts', importedContacts);
            importedContactsProgress = false;
          });
          _scaffoldKey.currentState.showSnackBar(snackBar(
              'All your contacts from your phone have been imported!'));
          Navigator.pop(context);
        }).catchError((e) {
          print('ERROR');
          print(e);
        });
      });
    }

    void _createContactCsv() async {
      List<dynamic> contacts = await db.contacts();
      List<List<dynamic>> rows = List<List<dynamic>>();
      for (int i = 0; i < contacts.length; i++) {
        List<dynamic> row = List();
        row.add(contacts[i].name);
        row.add(contacts[i].phone);
        row.add(contacts[i].email);
        row.add(contacts[i].instagram);
        rows.add(row);
      }
      print('CONTACTS EXPORTED');
      Directory dir = await getExternalStorageDirectory();
      // var dir = await getApplicationDocumentsDirectory();

      String path = dir.absolute.path;
      print(path);
      // Directory contactsDir = await Directory(path).create();
      // print(contactsDir);
      File file = File('${path}/contacts.csv');
      print(file);
      String csv = const ListToCsvConverter().convert(rows);

      file.writeAsString(csv);

      final Email email = Email(
        body:
            'In this email you will find  MyContacts attached as a csv file. Thank you for using MyContacts!',
        subject: 'MyContacts nformation',
        // recipients: ['example@example.com'],
        attachmentPath: '${file.path}',
      );
      await FlutterEmailSender.send(email);
      _scaffoldKey.currentState
          .showSnackBar(snackBar('Your contacts have been exported'));
    }

    void _exportContacts() async {
      // Map permission = await _requestPermission(PermissionGroup.storage);
      PermissionStatus status = await _checkPermission(PermissionGroup.storage);
      if (status == PermissionStatus.granted) {
        _createContactCsv();
      } else {
        Map<PermissionGroup, PermissionStatus> permission =
            await _requestPermission(PermissionGroup.storage);
        print(permission["permissionStatus"]);
        if (permission["permissionStatus"] == PermissionStatus.granted) {
          _createContactCsv();
        } else {
          return null;
        }
      }
    }

    Future<List<dynamic>> _generateTable() async {
      List<dynamic> contacts = await db.contacts();
      List<p.Widget> rows = List();
      // List<p.Widget> row = List();

      p.Text _text(text) {
        return p.Text('$text ||', style: p.TextStyle(fontSize: 12));
      }

      for (int i = 0; i < contacts.length; i++) {
        var text = p.Row(
          children: [
            p.Text('${i + 1})', style: p.TextStyle(fontSize: 12)),
            _text('${contacts[i].name}'),
            _text('${contacts[i].phone}'),
            _text('${contacts[i].email}'),
          ],
        );

        rows.add(text);
      }
      return rows;
    }

    void _createPdf() async {
      Directory dir = await getExternalStorageDirectory();
      String path = dir.absolute.path;
      File file = File('${path}/example.pdf');
      final p.Document pdfDocument = p.Document();
      var data = await _generateTable();

      pdfDocument.addPage(p.MultiPage(header: (p.Context context) {
        return p.Header(
            level: 1,
            child: p.Text('MyContacts', style: p.TextStyle(fontSize: 20)));
      }, build: (p.Context context) {
        return data;
      }));
      file.writeAsBytesSync(pdfDocument.save());

      final Email email = Email(
        body: 'MyContacts pdf!',
        subject: 'MyContacts information in pdf',
        // recipients: ['example@example.com'],
        attachmentPath: '${file.path}',
      );
      await FlutterEmailSender.send(email);
    }

    void _exportContactsPdf() async {
      PermissionStatus status = await _checkPermission(PermissionGroup.storage);
      if (status == PermissionStatus.granted) {
        _createPdf();
      } else {
        Map<PermissionGroup, PermissionStatus> permission =
            await _requestPermission(PermissionGroup.storage);
        print(permission["permissionStatus"]);
        if (permission["permissionStatus"] == PermissionStatus.granted) {
          _createPdf();
        } else {
          return null;
        }
      }
    }

    AppSettings appState = AppSettings.of(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Builder(
        builder: (context) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text('About'),
                    trailing: IconButton(
                      icon: Icon(Icons.info),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AboutActivity()),
                        );
                      },
                    ),
                  ),
                  SwitchListTile(
                    value: appState.camera,
                    title: Text('Camera'),
                    onChanged: (value) {
                      setState(() {
                        activateCamera = value;
                        AppSettings.of(context).callback(camera: value);
                      });
                    },
                  ),
                  ListTile(
                    title: Text('Delete contacts'),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                  'Are you sure you want to delete all your contacts?'),
                              actions: <Widget>[
                                FlatButton(
                                    child: Text('close'),
                                    onPressed: () {
                                      // Navigator.of(context).pop();
                                      Navigator.popUntil(
                                          context, ModalRoute.withName('/'));
                                    }),
                                FlatButton(
                                    child: Text('ok'),
                                    onPressed: () async {
                                      bool isDataDeleted =
                                          await _db.deleteAllContacts();
                                      if (isDataDeleted) {
                                        _scaffoldKey.currentState.showSnackBar(
                                            snackBar(
                                                'All your contacts have been deleted!'));
                                        setState(() {
                                          importedContacts = false;
                                          prefs.setBool('importedContacts',
                                              importedContacts);
                                        });
                                      }

                                      Navigator.pop(context);
                                    })
                              ],
                            );
                          });
                    },
                    trailing: Icon(Icons.delete),
                  ),
                  importedContacts == false
                      ? ListTile(
                          title: Text('Import contacts'),
                          onTap: () async {
                            _importContacts();
                          },
                          trailing: Icon(Icons.import_contacts),
                        )
                      : const SizedBox(),
                  ListTile(
                    title: Text('Export Contacts as csv'),
                    trailing: Icon(Icons.import_export),
                    onTap: () {
                      print('EXPORTING CONTACTS');
                      _exportContacts();
                    },
                  ),
                  ListTile(
                    title: Text('Export Contacts as pdf'),
                    trailing: Icon(Icons.import_export),
                    onTap: () {
                      print('EXPORTING CONTACTS');
                      _exportContactsPdf();
                    },
                  ),
                  ExpandableThemeSettings(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
