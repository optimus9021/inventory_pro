import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/field_definition.dart';
import '../providers/inventory_provider.dart';

class ItemFormPage extends StatefulWidget {
  const ItemFormPage({super.key});

  @override
  State<ItemFormPage> createState() => _ItemFormPageState();
}

class _ItemFormPageState extends State<ItemFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = <String, TextEditingController>{};

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InventoryProvider>();
    final fields = provider.fields;
    for (final field in fields) {
      _controllers.putIfAbsent(field.id, () => TextEditingController());
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Add Item')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (fields.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          final isWide = constraints.maxWidth > 600;
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isWide ? 600 : double.infinity),
              child: Padding(
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
                            provider.addItem(data).then((_) => Navigator.pop(context));
                          }
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
