import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:inventory_pro/pages/dashboard_page.dart';
import 'package:inventory_pro/providers/inventory_provider.dart';
import 'package:inventory_pro/services/inventory_service.dart';
import 'package:inventory_pro/pages/settings_page.dart';

void main() {
  testWidgets('navigate to settings page', (tester) async {
    final fake = FakeFirebaseFirestore();
    final service = InventoryService(firestore: fake);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => InventoryProvider(service: service),
        child: const MaterialApp(home: DashboardPage()),
      ),
    );

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsPage), findsOneWidget);
  });
}
