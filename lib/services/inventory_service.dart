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
    await db.insert('items', {'data': jsonEncode(data)});
  }
}
