import 'package:flutter/material.dart';
import '../services/inventory_service.dart';
import '../models/field_definition.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _nameController = TextEditingController();
  final _patternController = TextEditingController();
  final InventoryService _service = InventoryService();

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
      body: Padding(
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
                final name = _nameController.text.trim();
                final pattern = _patternController.text.trim();
                if (name.isEmpty) return;
                _service
                    .addFieldDefinition(
                      FieldDefinition(
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
              child: StreamBuilder<List<FieldDefinition>>(
                stream: _service.fieldDefinitionsStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final fields = snapshot.data!;
                  return ListView(
                    children: fields
                        .map((f) => ListTile(title: Text(f.name)))
                        .toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
