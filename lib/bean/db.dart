import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

Helper dbHelper;

void initDB() async {
  // Get a location using path_provider
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String path = join(documentsDirectory.path, "chic.db");
  // Make sure the directory exists
  try {
    await documentsDirectory.create(recursive: true);
  } catch (_) {}

  dbHelper = new Helper(path);
}

_onConfigure(Database db) async {
  // Add support for cascade delete
  await db.execute("PRAGMA foreign_keys = ON");
}

class Helper {
  final String path;
  Helper(this.path);

  Database _db;
  final _lock = new Lock();

  Future<Database> getDb() async {
    if (_db == null) {
      await _lock.synchronized(() async {
        // Check again once entering the synchronized block
        if (_db == null) {
          _db = await openDatabase(path);
        }
      });
    }
    return _db;
  }
}
