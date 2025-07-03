import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _db;

  Future<void> init() async {
    if (_db != null) return;

    if (kIsWeb) {
      sqfliteFfiWebInit();
      databaseFactory = databaseFactoryFfiWeb;
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, 'inventory.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE fields(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, pattern TEXT)');
        await db.execute(
            'CREATE TABLE items(id INTEGER PRIMARY KEY AUTOINCREMENT, data TEXT NOT NULL)');
      },
    );
  }

  Future<Database> get database async {
    if (_db == null) {
      await init();
    }
    return _db!;
  }
}
