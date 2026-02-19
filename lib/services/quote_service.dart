import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quote.dart';
import '../models/category.dart';

/// Handles loading quotes from JSON and managing favorites.
class QuoteService {
  static const String _favoritesKey = 'favorites_list';
  List<Quote> _allQuotes = [];
  List<Category> _categories = [];
  Set<String> _favoriteKeys = {};

  List<Quote> get allQuotes => _allQuotes;
  List<Category> get categories => _categories;

  /// Loads all quotes from the bundled JSON asset.
  Future<void> loadQuotes() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/quotes.json');
    final Map<String, dynamic> data = json.decode(jsonString);
    final List<dynamic> categoriesData = data['categories'];

    _allQuotes = [];
    _categories = [];

    for (var catData in categoriesData) {
      final String catName = catData['name'];
      final List<dynamic> quotes = catData['quotes'] ?? [];
      final List<dynamic> premiumQuotes = catData['premium_quotes'] ?? [];

      // Add regular quotes
      for (var quoteText in quotes) {
        _allQuotes.add(Quote.fromData(
          text: quoteText,
          category: catName,
          isPremium: false,
        ));
      }

      // Add premium quotes
      for (var quoteText in premiumQuotes) {
        _allQuotes.add(Quote.fromData(
          text: quoteText,
          category: catName,
          isPremium: true,
        ));
      }

      // Build category object
      _categories.add(Category(
        name: catName,
        icon: Category.iconFromString(catData['icon'] ?? ''),
        color: Category.colorFromHex(catData['color'] ?? '#757575'),
        quoteCount: quotes.length + premiumQuotes.length,
      ));
    }

    // Load saved favorites
    await _loadFavorites();
  }

  /// Returns quotes for a specific category.
  List<Quote> getQuotesByCategory(String category) {
    return _allQuotes.where((q) => q.category == category).toList();
  }

  /// Searches quotes across all categories.
  List<Quote> searchQuotes(String query) {
    if (query.isEmpty) return [];
    final lowerQuery = query.toLowerCase();
    return _allQuotes
        .where((q) => q.text.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// Returns all favorited quotes.
  List<Quote> getFavorites() {
    return _allQuotes.where((q) => q.isFavorite).toList();
  }

  /// Toggles favorite status for a quote.
  Future<void> toggleFavorite(Quote quote) async {
    final key = _quoteKey(quote);
    quote.isFavorite = !quote.isFavorite;

    if (quote.isFavorite) {
      _favoriteKeys.add(key);
    } else {
      _favoriteKeys.remove(key);
    }

    await _saveFavorites();
  }

  /// Checks if a quote is favorited.
  bool isFavorite(Quote quote) {
    return _favoriteKeys.contains(_quoteKey(quote));
  }

  String _quoteKey(Quote quote) => '${quote.category}::${quote.text}';

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> keys = prefs.getStringList(_favoritesKey) ?? [];
    _favoriteKeys = keys.toSet();

    // Mark quotes as favorites
    for (var quote in _allQuotes) {
      quote.isFavorite = _favoriteKeys.contains(_quoteKey(quote));
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, _favoriteKeys.toList());
  }
}
