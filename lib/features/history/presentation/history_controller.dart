import 'package:flutter/foundation.dart';
import '../../../core/storage/storage_service.dart';
import '../../../models/history_item.dart';

class HistoryController extends ChangeNotifier {
  final StorageService _storage;
  List<HistoryItem> _items = [];
  String _searchQuery = '';

  HistoryController(this._storage) {
    _loadHistory();
  }

  List<HistoryItem> get items {
    if (_searchQuery.isEmpty) return List.unmodifiable(_items);
    final q = _searchQuery.toLowerCase();
    return _items.where((item) => item.title.toLowerCase().contains(q)).toList();
  }

  int get totalCount => _items.length;
  String get searchQuery => _searchQuery;

  void _loadHistory() {
    _items = _storage.getHistory();
    // Default sample history if totally empty
    if (_items.isEmpty) {
      final now = DateTime.now();
      _items = [
        HistoryItem(
          id: '1',
          title: 'My First Landing Page',
          code: '''<!DOCTYPE html>
<html>
<head><title>Welcome</title></head>
<body><h1>Hello World</h1><p>Welcome to my awesome website.</p></body>
</html>''',
          createdAt: now.subtract(const Duration(hours: 2)),
          updatedAt: now.subtract(const Duration(hours: 2)),
        ),
      ];
      _storage.saveHistory(_items);
    }
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> saveProject(String title, String code) async {
    final newItem = HistoryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim().isEmpty ? 'Untitled Project' : title.trim(),
      code: code,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _items.insert(0, newItem);
    await _storage.saveHistory(_items);
    notifyListeners();
  }

  Future<void> deleteProject(String id) async {
    _items.removeWhere((item) => item.id == id);
    await _storage.saveHistory(_items);
    notifyListeners();
  }

  Future<void> clearAll() async {
    _items.clear();
    await _storage.clearHistory();
    notifyListeners();
  }
}
