import 'dart:async';
import 'package:kevin_app/state/appState.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:kevin_app/models/contact.dart';

final String contactTable = "contacts";
final String groupTable = "groups";

class ContactDb {
  static final ContactDb dbProvider = ContactDb();

  final String contactTable = "contacts";
  final String groupTable = "groups";

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDb();
    return _database;
  }

  Future<Database> getDb() async {
    return openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'contact_database.db'),
      onCreate: (db, version) {
        db.execute(
            "CREATE TABLE $groupTable(id INTEGER PRIMARY KEY  AUTOINCREMENT, name TEXT)");
        return db.execute(
          "CREATE TABLE $contactTable(id INTEGER PRIMARY KEY  AUTOINCREMENT, name TEXT, phone TEXT, email TEXT, image TEXT, category TEXT ,birthday TEXT, address TEXT,organization TEXT,website TEXT,facebook TEXT,instagram TEXT,linkedin TEXT, twitter TEXT,  note TEXT, favorite INTEGER DEFAULT 0, showNotification INTEGER DEFAULT 0)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  Future<void> deleteDuplicateContacts() async {
    final Database db = await getDb();
    ContactDb contactDb = ContactDb();
    List<Contact> contacts = await contactDb.contacts();
    print(contacts.toString());
    await db.execute(
      "DELETE FROM contacts WHERE ROWID NOT IN (SELECT MIN(ROWID) FROM contacts GROUP BY  name, phone, email)",
    );

    contacts = await contactDb.contacts();
    print(contacts.toString());
    contactService.updateContacts(contacts);

    return;
  }

  Future<void> insertContact(Contact contact) async {
    // Get a reference to the database.
    final Database db = await getDb();

    await db.insert(
      'contacts',
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Contact>> contacts() async {
    // Get a reference to the database.
    final Database db = await getDb();

    final List<Map<String, dynamic>> maps =
        await db.query('contacts', orderBy: 'name');

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

  Future<void> updateContact(Contact contact) async {
    // Get a reference to the database.
    final db = await getDb();

    await db.update(
      'contacts',
      contact.toMap(),
      where: "id = ?",
      whereArgs: [contact.id],
    );
  }

  Future<int> getId(String contactName) async {
    final db = await getDb();

    final List<Map<String, dynamic>> query = await db.query('contacts',
        columns: ['id', 'name'], where: 'name = ?', whereArgs: [contactName]);
    int id = query.first['id'];
    print(id);
    return id;
  }

  Future<void> deleteContact(int id) async {
    // Get a reference to the database.
    final db = await getDb();

    await db.delete(
      'contacts',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<bool> deleteAllContacts() async {
    // Get a reference to the database.
    final db = await getDb();
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
