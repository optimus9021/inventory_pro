import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/field_definition.dart';
import '../services/inventory_service.dart';

class InventoryProvider extends ChangeNotifier {
  InventoryProvider({InventoryService? service})
      : _service = service ?? InventoryService() {
    _listen();
  }

  final InventoryService _service;

  StreamSubscription<List<FieldDefinition>>? _fieldSub;
  StreamSubscription<List<Map<String, dynamic>>>? _itemsSub;

  List<FieldDefinition> fields = [];
  List<Map<String, dynamic>> items = [];

  void _listen() {
    _fieldSub = _service.fieldDefinitionsStream().listen((data) {
      fields = data;
      notifyListeners();
    });
    _itemsSub = _service.itemsStream().listen((data) {
      items = data;
      notifyListeners();
    });
  }

  Future<void> addField(FieldDefinition field) {
    return _service.addFieldDefinition(field);
  }

  Future<void> addItem(Map<String, dynamic> data) {
    return _service.saveItem(data);
  }

  @override
  void dispose() {
    _fieldSub?.cancel();
    _itemsSub?.cancel();
    super.dispose();
  }
}
