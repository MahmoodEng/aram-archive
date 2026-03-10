import 'package:flutter_test/flutter_test.dart';
import 'package:aram_archive/models/box_model.dart';
import 'package:aram_archive/models/book_model.dart';

void main() {
  group('BoxModel', () {
    test('toMap and fromMap roundtrip', () {
      final box = BoxModel(id: 1, name: 'Test Box', createdAt: '2024-01-01');
      final map = box.toMap();
      final restored = BoxModel.fromMap(map);
      expect(restored.id, box.id);
      expect(restored.name, box.name);
      expect(restored.createdAt, box.createdAt);
    });

    test('copyWith updates fields', () {
      final box = BoxModel(id: 1, name: 'Old Name');
      final updated = box.copyWith(name: 'New Name');
      expect(updated.id, 1);
      expect(updated.name, 'New Name');
    });
  });

  group('BookModel', () {
    test('toMap and fromMap roundtrip', () {
      final book = BookModel(
        id: 1,
        boxId: 2,
        name: 'Test Book',
        pageCount: 100,
        pdfPath: '/path/to/file.pdf',
        isFavorite: true,
        createdAt: '2024-01-01',
      );
      final map = book.toMap();
      final restored = BookModel.fromMap(map);
      expect(restored.id, book.id);
      expect(restored.boxId, book.boxId);
      expect(restored.name, book.name);
      expect(restored.pageCount, book.pageCount);
      expect(restored.pdfPath, book.pdfPath);
      expect(restored.isFavorite, book.isFavorite);
    });

    test('isFavorite defaults to false', () {
      final book = BookModel(boxId: 1, name: 'Book', pageCount: 50);
      expect(book.isFavorite, false);
    });

    test('copyWith updates isFavorite', () {
      final book = BookModel(boxId: 1, name: 'Book', pageCount: 50);
      final favorited = book.copyWith(isFavorite: true);
      expect(favorited.isFavorite, true);
      expect(favorited.name, 'Book');
    });
  });
}
