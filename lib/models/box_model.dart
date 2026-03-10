class BoxModel {
  final int? id;
  final String name;
  final String? createdAt;

  BoxModel({
    this.id,
    required this.name,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt,
    };
  }

  factory BoxModel.fromMap(Map<String, dynamic> map) {
    return BoxModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      createdAt: map['created_at'] as String?,
    );
  }

  BoxModel copyWith({
    int? id,
    String? name,
    String? createdAt,
  }) {
    return BoxModel(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
