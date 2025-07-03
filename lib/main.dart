import 'package:flutter/material.dart';

import 'services/inventory_service.dart';

import 'pages/item_form_page.dart';
import 'pages/settings_page.dart';
import 'services/database_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'pages/dashboard_page.dart';
import 'providers/inventory_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await InventoryService().init();

  await DatabaseHelper.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InventoryProvider(),
      child: MaterialApp(
        title: 'Inventory Pro',
        theme: ThemeData(useMaterial3: true),
        home: const DashboardPage(),
      ),
    );
  }
}
