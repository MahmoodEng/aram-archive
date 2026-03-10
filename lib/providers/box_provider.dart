import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
import '../models/box_model.dart';

class BoxProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();
  List<BoxModel> _boxes = [];

  List<BoxModel> get boxes => _boxes;

  Future<void> loadBoxes() async {
    _boxes = await _db.getAllBoxes();
    notifyListeners();
  }

  Future<void> addBox(String name) async {
    final box = BoxModel(
      name: name,
      createdAt: DateTime.now().toIso8601String(),
    );
    await _db.insertBox(box);
    await loadBoxes();
  }

  Future<void> updateBox(BoxModel box) async {
    await _db.updateBox(box);
    await loadBoxes();
  }

  Future<void> deleteBox(int id) async {
    await _db.deleteBox(id);
    await loadBoxes();
  }
}
