import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:kevin_app/ContactDb.dart';
import 'package:kevin_app/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as p;

final ContactDb db = ContactDb();
final _scaffoldKey = GlobalKey<ScaffoldState>();
final snackBar = (text) => SnackBar(content: Text(text));

class ExpandableExportSettings extends StatefulWidget {
  final BuildContext context;
  ExpandableExportSettings(this.context);

  @override
  ExpandableExportSettingsState createState() =>
      ExpandableExportSettingsState();
}

class ExpandableExportSettingsState extends State<ExpandableExportSettings> {
  // This widget is the root of your application.
  List<Item> items;
  PermissionStatus _permissionStatus;

  @override
  void initState() {
    super.initState();
    items = [
      Item(
          headerValue:
              translatedText("settings_export_contacts", widget.context))
    ];
  }

  @override
  Widget build(BuildContext context) {
    void _createContactCsv() async {
      List<dynamic> contacts = await db.contacts();
      List<List<dynamic>> rows = List<List<dynamic>>();
      for (int i = 0; i < contacts.length; i++) {
        List<dynamic> row = List();
        row.add(contacts[i].name);
        row.add(contacts[i].phone);
        row.add(contacts[i].email);
        row.add(contacts[i].category);
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
        body: translatedText("text", context),
        subject: translatedText("email_csv_subject", context),
        // recipients: ['example@example.com'],
        attachmentPath: '${file.path}',
      );
      await FlutterEmailSender.send(email);
      _scaffoldKey.currentState.showSnackBar(
          snackBar(translatedText("snackbar_contact_exported", context)));
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
        body: translatedText("email_pdf_body", context),
        subject: translatedText("email_pdf_subject", context),
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

    return ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            items[index].isExpanded = !isExpanded;
          });
        },
        children: items.map<ExpansionPanel>((Item item) {
          return ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(item.headerValue),
              );
            },
            body: Card(
              child: Column(children: [
                ListTile(
                  title: Text(
                      translatedText("settings_export_contacts_csv", context)),
                  leading: Icon(Icons.import_export),
                  onTap: () {
                    _exportContacts();
                  },
                ),
                ListTile(
                  title: Text(
                      translatedText("settings_export_contacts_pdf", context)),
                  leading: Icon(Icons.picture_as_pdf),
                  onTap: () {
                    _exportContactsPdf();
                  },
                ),
              ]),
            ),
            canTapOnHeader: true,
            isExpanded: item.isExpanded,
          );
        }).toList());
  }
}

class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  List<Widget> expandedValue;
  String headerValue;
  bool isExpanded;
}
