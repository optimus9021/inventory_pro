import 'dart:async';
import 'dart:convert';
import '../models/field_definition.dart';
import 'db_service.dart';

class InventoryService {
  InventoryService._();
  static final InventoryService _instance = InventoryService._();
  factory InventoryService() => _instance;

  final DbService _db = DbService();
  final StreamController<List<FieldDefinition>> _fieldsController =
      StreamController<List<FieldDefinition>>.broadcast();

  Future<void> init() async {
    await _db.init();
    await _loadFields();
  }

  Stream<List<FieldDefinition>> fieldDefinitionsStream() =>
      _fieldsController.stream;

  Future<void> _loadFields() async {
    final db = await _db.database;
    final maps = await db.query('field_definitions');
    final fields = maps.map(FieldDefinition.fromMap).toList();
    _fieldsController.add(fields);
  }

  Future<void> addFieldDefinition(FieldDefinition field) async {
    final db = await _db.database;
    await db.insert('field_definitions', field.toMap());
    await _loadFields();
  }

  Future<void> saveItem(Map<String, dynamic> data) async {
    final db = await _db.database;

import 'package:sqflite/sqflite.dart';

import '../models/field_definition.dart';
import 'database_helper.dart';

class InventoryService {
  final StreamController<List<FieldDefinition>> _controller =
      StreamController.broadcast();

  Stream<List<Map<String, dynamic>>> itemsStream() {
    return _itemsCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    });
  }

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
