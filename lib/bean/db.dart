import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

Helper dbHelper = new Helper();

class Helper {
  Database _db;
  final _lock = new Lock();

  Future<Database> getDb() async {
    if (_db == null) {
      await _lock.synchronized(() async {
        // Check again once entering the synchronized block
        if (_db == null) {
          // 异步流，最终得到db对象
          _initDBPath()
              .then((String path) => openDatabase(
                    path,
                    version: 1,
                    onCreate: _onCreate,
                    onConfigure: _onConfigure,
                  ))
              .then((Database db) => _db = db)
              .catchError((e) => print("db creator error :$e"));
        }
      });
    }
    return _db;
  }

  Future<String> _initDBPath() async {
    // Get a location using path_provider.
    // And make sure the directory exists, if not, create the directory.
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      await documentsDirectory.create(recursive: true);
      return join(documentsDirectory.path, "chic.db");
    } catch (e) {
      print("path for chic.db error :$e");
    }
    return null;
  }

  _onConfigure(Database db) async {
    // Add support for cascade delete
    await db.execute("PRAGMA foreign_keys = ON");
  }

  _onCreate(Database db, int version) async {
    //await db.execute();
  }
}

abstract class SQLModel{
  String createTableSQL();
}
