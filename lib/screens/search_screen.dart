import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quote_provider.dart';
import '../providers/ad_provider.dart';
import '../widgets/quote_card.dart';

/// Search screen with instant filtering across all categories.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-focus search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quoteProvider = context.watch<QuoteProvider>();
    final adProvider = context.watch<AdProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final results = quoteProvider.searchResults;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            quoteProvider.clearSearch();
            Navigator.pop(context);
          },
        ),
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          // Search input field
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              onChanged: (value) => quoteProvider.search(value),
              decoration: InputDecoration(
                hintText: 'Search quotes...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          quoteProvider.clearSearch();
                        },
                      )
                    : null,
                filled: true,
                fillColor: isDark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.black.withOpacity(0.04),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
          ),

          // Results or empty state
          Expanded(
            child: _searchController.text.isEmpty
                ? _buildPromptState(isDark)
                : results.isEmpty
                    ? _buildNoResultsState(isDark)
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final quote = results[index];
                          return QuoteCard(
                            quote: quote,
                            isFavorite: quoteProvider.isFavorite(quote),
                            onFavoriteToggle: () {
                              quoteProvider.toggleFavorite(quote);
                            },
                            onInteraction: () {
                              adProvider.recordInteraction();
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptState(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_rounded,
            size: 64,
            color: isDark ? Colors.white24 : Colors.black12,
          ),
          const SizedBox(height: 16),
          Text(
            'Search across all categories',
            style: TextStyle(
              fontSize: 15,
              color: isDark ? Colors.white38 : Colors.black38,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try "love", "motivation", or "காதல்"',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white24 : Colors.black26,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.sentiment_dissatisfied_rounded,
            size: 64,
            color: isDark ? Colors.white24 : Colors.black12,
          ),
          const SizedBox(height: 16),
          Text(
            'No quotes found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white38 : Colors.black38,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white24 : Colors.black26,
            ),
          ),
        ],
      ),
    );
  }
}
