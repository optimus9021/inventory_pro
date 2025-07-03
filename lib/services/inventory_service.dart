import 'dart:async';
import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../models/field_definition.dart';
import 'database_helper.dart';

class InventoryService {
  final StreamController<List<FieldDefinition>> _controller =
      StreamController.broadcast();

  Stream<List<FieldDefinition>> fieldDefinitionsStream() {
    _emitFields();
    return _controller.stream;
  }

  Future<Database> get _db async => DatabaseHelper.instance.database;

  Future<void> _emitFields() async {
    final db = await _db;
    final maps = await db.query('fields');
    final fields = maps.map(FieldDefinition.fromMap).toList();
    _controller.add(fields);
  }

  Future<void> addFieldDefinition(FieldDefinition field) async {
    final db = await _db;
    await db.insert('fields', field.toMap());
    await _emitFields();
  }

  Future<void> saveItem(Map<String, dynamic> data) async {
    final db = await _db;
    await db.insert('items', {'data': jsonEncode(data)});
  }
}
