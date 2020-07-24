import 'dart:async';

import 'package:kevin_app/db/contactDb.dart';
import 'package:kevin_app/models/group.dart';

class GroupDao {
  final dbProvider = ContactDb.dbProvider;

  Future<int> insertGroup(Group group) async {
    final db = await dbProvider.database;

    var result = await db.insert(
      groupTable,
      group.toMap(),
    );
    return result;
  }

  Future<List<Group>> groups() async {
    final db = await dbProvider.database;

    final List<Map<String, dynamic>> maps =
        await db.query(groupTable, orderBy: 'name');

    // Convert the List<Map<String, dynamic> into a List<Contact>.
    return List.generate(maps.length, (i) {
      return Group(
        id: maps[i]['id'],
        name: maps[i]['name'],
      );
    });
  }

  Future<Group> getGroupById(int id) async {
    // Get a reference to the database.
    List groups = await this.groups();
    Group group;
    groups.forEach((dbGroup) {
      if (dbGroup.id == id) {
        group = dbGroup;
      }
    });
    return group;
  }

  Future<int> getGroupId(Group group) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (group != null) {
      result = await db
          .query(groupTable, where: 'name = ?', whereArgs: ["${group.name}"]);
    } else {
      result = await db.query(groupTable);
    }
    Group groupfromDb = Group.fromJson(result[0]);
    return groupfromDb.id;
  }

  Future<int> updateGroup(Group group) async {
    // Get a reference to the database.
    final db = await dbProvider.database;

    var result = await db.update(
      groupTable,
      group.toMap(),
      where: "id = ?",
      whereArgs: [group.id],
    );
    return result;
  }

  Future<int> deleteGroup(int id) async {
    // Get a reference to the database.
    final db = await dbProvider.database;

    var result = await db.delete(
      groupTable,
      where: "id = ?",
      whereArgs: [id],
    );

    return result;
  }

  Future<bool> deleteAllGroups() async {
    // Get a reference to the database.
    final db = await dbProvider.database;
    bool isDataDeleted;

    await db
        .delete(
      'groups',
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
