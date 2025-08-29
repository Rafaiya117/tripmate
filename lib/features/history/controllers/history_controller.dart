import 'package:flutter/material.dart';
import 'package:trip_mate/features/history/models/history_model.dart';

class HistoryController extends ChangeNotifier {
  List<HistoryModel> _historyList = [];
  List<HistoryModel> _filteredList = [];
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<HistoryModel> get historyList => _historyList;
  List<HistoryModel> get filteredList => _filteredList;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  HistoryController() {
    _loadMockData();
  }

  // Load mock data for demonstration
  void _loadMockData() {
    _isLoading = true;
    notifyListeners();

    // Simulate API call delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _historyList = [
        HistoryModel(
          id: '1',
          imageUrl: 'https://images.unsplash.com/photo-1564507592333-c60657eea523?w=800&h=400&fit=crop',
          date: '19 March, 2025',
          location: 'Delhi, India',
          description: 'Red Fort - Historical monument',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        HistoryModel(
          id: '2',
          imageUrl: 'https://images.unsplash.com/photo-1587474260584-136574528ed5?w=800&h=400&fit=crop',
          date: '19 March, 2025',
          location: 'Delhi, India',
          description: 'India Gate - War memorial',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        HistoryModel(
          id: '3',
          imageUrl: 'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?w=800&h=400&fit=crop',
          date: '19 March, 2025',
          location: 'London, UK',
          description: 'Stonehenge - Prehistoric monument',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        HistoryModel(
          id: '4',
          imageUrl: 'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=800&h=400&fit=crop',
          date: '19 March, 2025',
          location: 'South Dakota, USA',
          description: 'Mount Rushmore - National memorial',
          createdAt: DateTime.now().subtract(const Duration(days: 4)),
        ),
        HistoryModel(
          id: '5',
          imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&h=400&fit=crop',
          date: '19 March, 2025',
          location: 'Paris, France',
          description: 'Eiffel Tower - Iconic landmark',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        HistoryModel(
          id: '6',
          imageUrl: 'https://images.unsplash.com/photo-1555992336-03a23c7b20ee?w=800&h=400&fit=crop',
          date: '19 March, 2025',
          location: 'Rome, Italy',
          description: 'Colosseum - Ancient amphitheater',
          createdAt: DateTime.now().subtract(const Duration(days: 6)),
        ),
      ];

      _filteredList = List.from(_historyList);
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    });
  }

  // Search functionality
  void searchHistory(String query) {
    _searchQuery = query;
    
    if (query.isEmpty) {
      _filteredList = List.from(_historyList);
    } else {
      _filteredList = _historyList.where((history) {
        final searchLower = query.toLowerCase();
        return history.location?.toLowerCase().contains(searchLower) == true ||
               history.description?.toLowerCase().contains(searchLower) == true ||
               history.date.toLowerCase().contains(searchLower);
      }).toList();
    }
    
    notifyListeners();
  }

  // Clear search
  void clearSearch() {
    _searchQuery = '';
    _filteredList = List.from(_historyList);
    notifyListeners();
  }

  // Delete history item
  void deleteHistoryItem(String id) {
    _historyList.removeWhere((item) => item.id == id);
    _filteredList.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  // Add new history item
  void addHistoryItem(HistoryModel history) {
    _historyList.insert(0, history);
    _filteredList.insert(0, history);
    notifyListeners();
  }

  // Refresh history
  Future<void> refreshHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      _loadMockData();
    } catch (e) {
      _errorMessage = 'Failed to refresh history';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
