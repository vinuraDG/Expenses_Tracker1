import 'package:flutter/material.dart';
import '../core/services/firestore_service.dart';
import '../models/category_model.dart';

class CategoryProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();

  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CategoryModel> get categories => List.unmodifiable(_categories);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  CategoryModel? findById(String id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> fetchCategories() async {
    _setLoading(true);
    try {
      _categories = await _service.getCategories();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addCategory(String name, String icon) async {
    _setLoading(true);
    try {
      final data = {'name': name.trim(), 'icon': icon};
      final ref = await _service.addCategory(data);
      _categories.add(CategoryModel(id: ref.id, name: name.trim(), icon: icon));
      _categories.sort((a, b) => a.name.compareTo(b.name));
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateCategory(String id, String name, String icon) async {
    _setLoading(true);
    try {
      final data = {'name': name.trim(), 'icon': icon};
      await _service.updateCategory(id, data);
      final index = _categories.indexWhere((c) => c.id == id);
      if (index != -1) {
        _categories[index] = CategoryModel(id: id, name: name.trim(), icon: icon);
        _categories.sort((a, b) => a.name.compareTo(b.name));
      }
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteCategory(String id) async {
    _setLoading(true);
    try {
      await _service.deleteCategory(id);
      _categories.removeWhere((c) => c.id == id);
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}