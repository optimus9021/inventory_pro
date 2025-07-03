class FieldDefinition {
  final String id;
  final String name;
  final String? pattern;

  FieldDefinition({required this.id, required this.name, this.pattern});

  factory FieldDefinition.fromMap(String id, Map<String, dynamic> data) {
    return FieldDefinition(
      id: id,
      name: data['name'] as String,
      pattern: data['pattern'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      if (pattern != null) 'pattern': pattern,
    };
  }
}
