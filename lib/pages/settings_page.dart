import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/field_definition.dart';
import '../providers/inventory_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _nameController = TextEditingController();
  final _patternController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _patternController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Field Settings')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          return Center(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: isWide ? 600 : double.infinity),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Field Name'),
            ),
            TextField(
              controller: _patternController,
              decoration: const InputDecoration(
                labelText: 'Validation Regex (optional)',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final provider = context.read<InventoryProvider>();
                final name = _nameController.text.trim();
                final pattern = _patternController.text.trim();
                if (name.isEmpty) return;
                provider
                    .addField(
                      FieldDefinition(
                        id: '',
                        name: name,
                        pattern: pattern.isEmpty ? null : pattern,
                      ),
                    )
                    .then((_) {
                      _nameController.clear();
                      _patternController.clear();
                    });
              },
              child: const Text('Add Field'),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Consumer<InventoryProvider>(
                builder: (context, provider, _) {
                  final fields = provider.fields;
                  if (fields.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView(
                    children:
                        fields.map((f) => ListTile(title: Text(f.name))).toList(),
                  );
                },
              ),
            ),
          ],
        ),
              ),
            ),
          );
        },
      ),
    );
  }
}
