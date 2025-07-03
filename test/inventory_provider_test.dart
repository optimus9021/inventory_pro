import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import 'package:inventory_pro/models/field_definition.dart';
import 'package:inventory_pro/providers/inventory_provider.dart';
import 'package:inventory_pro/services/inventory_service.dart';

void main() {
  test('addField stores data', () async {
    final fake = FakeFirebaseFirestore();
    final service = InventoryService(firestore: fake);
    final provider = InventoryProvider(service: service);

    await provider.addField(FieldDefinition(id: '', name: 'name'));
    final snap = await fake.collection('field_definitions').get();
    expect(snap.docs.length, 1);
  });
}
