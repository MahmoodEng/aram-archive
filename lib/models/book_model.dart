class BookModel {
  final int? id;
  final int boxId;
  final String name;
  final int pageCount;
  final String? pdfPath;
  final bool isFavorite;
  final String? createdAt;

  BookModel({
    this.id,
    required this.boxId,
    required this.name,
    required this.pageCount,
    this.pdfPath,
    this.isFavorite = false,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'box_id': boxId,
      'name': name,
      'page_count': pageCount,
      'pdf_path': pdfPath,
      'is_favorite': isFavorite ? 1 : 0,
      'created_at': createdAt,
    };
  }

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      id: map['id'] as int?,
      boxId: map['box_id'] as int,
      name: map['name'] as String,
      pageCount: map['page_count'] as int,
      pdfPath: map['pdf_path'] as String?,
      isFavorite: (map['is_favorite'] as int) == 1,
      createdAt: map['created_at'] as String?,
    );
  }

  BookModel copyWith({
    int? id,
    int? boxId,
    String? name,
    int? pageCount,
    String? pdfPath,
    bool? isFavorite,
    String? createdAt,
  }) {
    return BookModel(
      id: id ?? this.id,
      boxId: boxId ?? this.boxId,
      name: name ?? this.name,
      pageCount: pageCount ?? this.pageCount,
      pdfPath: pdfPath ?? this.pdfPath,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
