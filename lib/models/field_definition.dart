class FieldDefinition {
  final String id;
  final String name;
  final String? pattern;

  FieldDefinition({required this.id, required this.name, this.pattern});

  factory FieldDefinition.fromMap(Map<String, Object?> data) {
    return FieldDefinition(
      id: data['id'].toString(),
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
