import 'dart:typed_data';

class DbBackup {
  String id;
  String table;
  String name;
  String status;
  DateTime creationTime;

  DbBackup(
      {required this.status,
      required this.name,
      required this.creationTime,
      required this.table,
      required this.id});
}
