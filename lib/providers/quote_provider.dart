import 'package:flutter/material.dart';
import '../models/quote.dart';
import '../models/category.dart';
import '../services/quote_service.dart';

/// Manages quote state: loading, filtering, searching, and favorites.
class QuoteProvider extends ChangeNotifier {
  final QuoteService _quoteService = QuoteService();

  List<Category> _categories = [];
  List<Quote> _currentQuotes = [];
  List<Quote> _searchResults = [];
  List<Quote> _favorites = [];
  bool _isLoading = true;
  String _searchQuery = '';

  // Getters
  List<Category> get categories => _categories;
  List<Quote> get currentQuotes => _currentQuotes;
  List<Quote> get searchResults => _searchResults;
  List<Quote> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  /// Initialize by loading quotes from JSON.
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    await _quoteService.loadQuotes();
    _categories = _quoteService.categories;
    _favorites = _quoteService.getFavorites();
    _isLoading = false;
    notifyListeners();
  }

  /// Load quotes for a specific category.
  void loadCategory(String categoryName) {
    _currentQuotes = _quoteService.getQuotesByCategory(categoryName);
    notifyListeners();
  }

  /// Search across all quotes.
  void search(String query) {
    _searchQuery = query;
    _searchResults = _quoteService.searchQuotes(query);
    notifyListeners();
  }

  /// Clear search results.
  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    notifyListeners();
  }

  /// Toggle favorite for a quote.
  Future<void> toggleFavorite(Quote quote) async {
    await _quoteService.toggleFavorite(quote);
    _favorites = _quoteService.getFavorites();
    notifyListeners();
  }

  /// Check if a quote is favorited.
  bool isFavorite(Quote quote) => _quoteService.isFavorite(quote);
}
