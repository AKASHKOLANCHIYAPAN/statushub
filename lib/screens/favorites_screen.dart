import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quote_provider.dart';
import '../providers/ad_provider.dart';
import '../widgets/quote_card.dart';

/// Displays the user's favorited quotes with remove option.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quoteProvider = context.watch<QuoteProvider>();
    final adProvider = context.watch<AdProvider>();
    final favorites = quoteProvider.favorites;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              children: [
                Text(
                  'Favorites',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.favorite, color: Colors.redAccent, size: 24),
              ],
            ),
          ),
          if (favorites.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '${favorites.length} saved quotes',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
              ),
            ),

          const SizedBox(height: 12),

          // Favorites list or empty state
          Expanded(
            child: favorites.isEmpty
                ? _buildEmptyState(isDark)
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final quote = favorites[index];
                      return Dismissible(
                        key: ValueKey('${quote.category}::${quote.text}'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 24),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.delete_rounded,
                            color: Colors.redAccent,
                          ),
                        ),
                        onDismissed: (_) {
                          quoteProvider.toggleFavorite(quote);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Removed from favorites'),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              duration: const Duration(seconds: 2),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () {
                                  quoteProvider.toggleFavorite(quote);
                                },
                              ),
                            ),
                          );
                        },
                        child: QuoteCard(
                          quote: quote,
                          isFavorite: true,
                          onFavoriteToggle: () {
                            quoteProvider.toggleFavorite(quote);
                          },
                          onInteraction: () {
                            adProvider.recordInteraction();
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite_border_rounded,
            size: 80,
            color: isDark ? Colors.white24 : Colors.black12,
          ),
          const SizedBox(height: 16),
          Text(
            'No favorites yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white38 : Colors.black38,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the ❤️ on any quote to save it here',
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
