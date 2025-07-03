import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/inventory_provider.dart';
import 'item_form_page.dart';
import 'settings_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryProvider>(
      builder: (context, provider, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 700;
            final menu = _buildMenu(context);
            final list = ListView(
              children: provider.items.map((item) {
                final title = provider.fields.isNotEmpty
                    ? item[provider.fields.first.name]?.toString() ?? 'Item'
                    : 'Item';
                return ListTile(title: Text(title));
              }).toList(),
            );
            return Scaffold(
              appBar: AppBar(title: const Text('Inventory Dashboard')),
              drawer: isWide ? null : Drawer(child: menu),
              body: Row(
                children: [
                  if (isWide)
                    SizedBox(width: 200, child: menu),
                  Expanded(child: list),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMenu(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.add),
          title: const Text('Add Item'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ItemFormPage()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Field Settings'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            );
          },
        ),
      ],
    );
  }
}
