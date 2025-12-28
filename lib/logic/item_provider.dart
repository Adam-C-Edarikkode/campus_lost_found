import 'package:flutter/material.dart';
import '../data/models/item_model.dart';
import '../data/repositories/item_repository.dart';

enum FilterStatus { all, lost, found }

class ItemProvider extends ChangeNotifier {
  final ItemRepository _repository = ItemRepository();
  List<Item> _items = [];
  bool _isLoading = false;
  
  // Theme state
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  List<Item> get items => _items;
  bool get isLoading => _isLoading;

  // Search and Filter state
  String _searchQuery = '';
  String? _categoryFilter;
  FilterStatus _filterStatus = FilterStatus.all;

  FilterStatus get filterStatus => _filterStatus;
  String? get categoryFilter => _categoryFilter;

  List<Item> get filteredItems {
    return _items.where((item) {
      final matchesSearch = item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _categoryFilter == null || item.category == _categoryFilter;
      
      bool matchesStatus = true;
      if (_filterStatus == FilterStatus.lost) {
        matchesStatus = !item.isFound;
      } else if (_filterStatus == FilterStatus.found) {
        matchesStatus = item.isFound;
      }

      return matchesSearch && matchesCategory && matchesStatus;
    }).toList();
  }
  

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {

      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  Future<void> loadItems() async {
    _isLoading = true;
    notifyListeners();
    try {
      _items = await _repository.getItems();
       // Sort by date lost descending
      _items.sort((a, b) => b.dateLost.compareTo(a.dateLost));
    } catch (e) {
      debugPrint("Error loading items: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    
  }

  Future<void> addItem(Item item) async {
    await _repository.addItem(item);
    await loadItems();
  }

  Future<void> updateItem(Item item) async {
    await _repository.updateItem(item);
    await loadItems();
  }
  
  Future<void> markAsFound(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      final item = _items[index];
      final updatedItem = item.copyWith(isFound: true, foundAt: DateTime.now());
      await _repository.updateItem(updatedItem);
      await loadItems();
    }
  }

  Future<void> deleteItem(String id) async {
    await _repository.deleteItem(id);
    await loadItems();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategoryFilter(String? category) {
    _categoryFilter = category;
    notifyListeners();
  }

  void setFilterStatus(FilterStatus status) {
    _filterStatus = status;
    notifyListeners();
  }
}
