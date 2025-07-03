import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/field_definition.dart';

class InventoryService {
  final FirebaseFirestore _firestore;
  InventoryService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _fieldsCollection =>
      _firestore.collection('field_definitions');

  CollectionReference<Map<String, dynamic>> get _itemsCollection =>
      _firestore.collection('items');

  Stream<List<Map<String, dynamic>>> itemsStream() {
    return _itemsCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    });
  }

  Stream<List<FieldDefinition>> fieldDefinitionsStream() {
    return _fieldsCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => FieldDefinition.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Future<void> addFieldDefinition(FieldDefinition field) {
    return _fieldsCollection.add(field.toMap());
  }

  Future<void> saveItem(Map<String, dynamic> data) {
    return _itemsCollection.add(data);
  }
}
