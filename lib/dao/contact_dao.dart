import 'dart:async';

import 'package:kevin_app/db/contactDb.dart';
import 'package:kevin_app/models/contact.dart';

class ContactDao {
  final dbProvider = ContactDb.dbProvider;

  Future<int> insertContact(Contact contact) async {
    final db = await dbProvider.database;

    var result = await db.insert(
      contactTable,
      contact.toMap(),
    );
    return result;
  }

  Future<List<Contact>> contacts() async {
    final db = await dbProvider.database;

    final List<Map<String, dynamic>> maps =
        await db.query(contactTable, orderBy: 'name');

    // Convert the List<Map<String, dynamic> into a List<Contact>.
    return List.generate(maps.length, (i) {
      return Contact(
        id: maps[i]['id'],
        name: maps[i]['name'],
        phone: maps[i]['phone'],
        email: maps[i]['email'],
        image: maps[i]['image'],
        category: maps[i]['category'],
        birthday: maps[i]['birthday'],
        address: maps[i]['address'],
        organization: maps[i]['organization'],
        website: maps[i]['website'],
        facebook: maps[i]['facebook'],
        instagram: maps[i]['instagram'],
        linkedin: maps[i]['linkedin'],
        twitter: maps[i]['twitter'],
        note: maps[i]['note'],
        favorite: maps[i]['favorite'],
        showNotification: maps[i]['showNotification'],
      );
    });
  }

  Future<Contact> getContactById(int id) async {
    // Get a reference to the database.
    List contacts = await this.contacts();
    Contact contact;
    contacts.forEach((dbContact) {
      if (dbContact.id == id) {
        contact = dbContact;
      }
    });
    return contact;
  }

  Future<int> getContactId(Contact contact) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (contacts != null) {
      result = await db.query(contactTable,
          where: 'name = ?', whereArgs: ["${contact.name}"]);
    } else {
      result = await db.query(contactTable);
    }
    Contact contactsfromDb = Contact.fromJson(result[0]);
    return contactsfromDb.id;
  }

  Future<int> updateContact(Contact contact) async {
    // Get a reference to the database.
    final db = await dbProvider.database;

    var result = await db.update(
      contactTable,
      contact.toMap(),
      where: "id = ?",
      whereArgs: [contact.id],
    );
    return result;
  }

  Future<int> deleteContact(int id) async {
    // Get a reference to the database.
    final db = await dbProvider.database;

    var result = await db.delete(
      contactTable,
      where: "id = ?",
      whereArgs: [id],
    );

    return result;
  }

  Future<bool> deleteAllContacts() async {
    // Get a reference to the database.
    final db = await dbProvider.database;
    bool isDataDeleted;

    await db
        .delete(
      'contacts',
    )
        .then((rowsAffected) {
      if (rowsAffected == 0) {
        isDataDeleted = false;
      } else {
        isDataDeleted = true;
      }
    });
    return isDataDeleted;
  }
}
