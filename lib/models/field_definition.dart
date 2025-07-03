class FieldDefinition {
  final int? id;
  final String name;
  final String? pattern;

  FieldDefinition({this.id, required this.name, this.pattern});

  factory FieldDefinition.fromMap(Map<String, dynamic> data) {
    return FieldDefinition(
      id: data['id'] as int?,
      name: data['name'] as String,
      pattern: data['pattern'] as String?,
    );
  }

  Map<String, dynamic> toMap({bool withId = false}) {
    final map = <String, dynamic>{'name': name};
    if (pattern != null) map['pattern'] = pattern;
    if (withId && id != null) map['id'] = id;
    return map;
  }
}
