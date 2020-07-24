import 'dart:io';

class Backup {
  final String name;
  final DateTime createdDate;
  final Directory directory;

  Backup({this.name, this.createdDate, this.directory});
}
