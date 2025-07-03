import 'package:flutter/material.dart';
import '../services/inventory_service.dart';
import '../models/field_definition.dart';

class ItemFormPage extends StatefulWidget {
  const ItemFormPage({super.key});

  @override
  State<ItemFormPage> createState() => _ItemFormPageState();
}

class _ItemFormPageState extends State<ItemFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = <String, TextEditingController>{};
  final InventoryService _service = InventoryService();

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Item')),
      body: StreamBuilder<List<FieldDefinition>>(
        stream: _service.fieldDefinitionsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final fields = snapshot.data!;
          for (final field in fields) {
            _controllers.putIfAbsent(field.id, () => TextEditingController());
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  ...fields.map((field) {
                    final controller = _controllers[field.id]!;
                    return TextFormField(
                      controller: controller,
                      decoration: InputDecoration(labelText: field.name),
                      validator: (value) {
                        if (field.pattern != null && value != null) {
                          final reg = RegExp(field.pattern!);
                          if (!reg.hasMatch(value)) {
                            return 'Invalid ${field.name}';
                          }
                        }
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    );
                  }),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final data = {
                          for (final field in fields)
                            field.name: _controllers[field.id]!.text,
                        };
                        _service.saveItem(data).then((_) => Navigator.pop(context));
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
