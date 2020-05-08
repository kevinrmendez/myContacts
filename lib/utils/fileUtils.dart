import 'dart:io';

import 'package:csv/csv.dart';
import 'package:kevin_app/contactDb.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as p;

import 'package:vcard/vcard.dart';

class FileUtils {
  static final ContactDb db = ContactDb();

  static Future<String> createVcard(Directory directory) async {
    // Directory dir = await getExternalStorageDirectory();
    String path = directory.path;

    File file = File('$path/myContacts.vcf');

    file.writeAsStringSync("", mode: FileMode.write);

    String content;

    var vCard = VCard();
    List<dynamic> contacts = await db.contacts();

    contacts.forEach((contact) {
      // var name;
      // var firstName;
      // var lastName;
      // if (contact.name != null) {
      // name = contact.name.split(" ");
      // print("CONTACT NAME: $name");
      // print(name.length);
      // firstName = name[0];
      // if (name.length > 1) {
      //   lastName = name[1];
      // } else {
      //   lastName = "";
      // }
      // } else {
      //   name = [];
      //   firstName = "";
      //   lastName = "";
      // }
      // print("CONTACT: ${contact}");
      vCard.firstName = contact.name == null ? "no name" : contact.name;
      // vCard.firstName = firstName;
      // vCard.middleName = 'MiddleName';
      // vCard.lastName = lastName;
      // vCard.organization = 'ActivSpaces Labs';
      // vCard.photo.attachFromUrl(
      //     'https://www.activspaces.com/wp-content/uploads/2019/01/ActivSpaces-Logo_Dark.png',
      //     'PNG');
      vCard.workPhone = contact.phone == null ? "no phone" : contact.phone;
      // vCard.birthday = DateTime.now();
      // vCard.jobTitle = 'Software Developer';
      vCard.email = contact.email == null ? "no email" : contact.email;
      // vCard.note = 'Notes on contact';

      content = vCard.getFormattedString();
      file.writeAsStringSync(content, mode: FileMode.append);
    });
    String filePath = '${path}/contact.vcf';
    // widget.filepaths.add(filePath);
    filePath = file.path;

    return filePath;
  }

  static Future<List<dynamic>> _generateTable() async {
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

  static Future<String> createPdf(Directory directory) async {
    // Directory dir = await getExternalStorageDirectory();
    String path = directory.absolute.path;
    File file = File('${path}/myContacts.pdf');

    print("PDF FILE: $file");
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
    String filePath = '${path}/myContacts.pdf';
    filePath = file.path;
    // widget.filepaths.add(filePath);
    return filePath;
  }

  static Future<String> createContactCsv(Directory directory) async {
    print('CONTACTS EXPORTED');
    // Directory dir = await getExternalStorageDirectory();
    // var dir = await getApplicationDocumentsDirectory();

    String path = directory.absolute.path;
    print(path);
    File file = File('${path}/myContacts.csv');
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

    print(file);
    String csv = const ListToCsvConverter().convert(rows);

    file.writeAsString(csv);
    String filePath = '${path}/contacts.csv';
    // widget.filepaths.add(filePath);
    filePath = file.path;

    return filePath;
  }
}
