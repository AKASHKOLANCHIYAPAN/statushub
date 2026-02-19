import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quote_provider.dart';
import '../providers/ad_provider.dart';
import '../widgets/quote_card.dart';
import '../widgets/banner_ad_widget.dart';

/// Displays a scrollable list of quotes for a given category.
class QuotesListScreen extends StatelessWidget {
  final String categoryName;
  final Color categoryColor;

  const QuotesListScreen({
    super.key,
    required this.categoryName,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    final quoteProvider = context.watch<QuoteProvider>();
    final adProvider = context.watch<AdProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final quotes = quoteProvider.currentQuotes;
    final premiumUnlocked = adProvider.isPremiumUnlocked(categoryName);

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                categoryColor.withOpacity(isDark ? 0.4 : 0.8),
                categoryColor.withOpacity(isDark ? 0.2 : 0.5),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Quote count header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  categoryColor.withOpacity(isDark ? 0.15 : 0.1),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Text(
              '${quotes.where((q) => !q.isPremium || premiumUnlocked).length} quotes available',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
            ),
          ),

          // Quotes list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              itemCount: quotes.length,
              itemBuilder: (context, index) {
                final quote = quotes[index];
                final isLocked = quote.isPremium && !premiumUnlocked;

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: QuoteCard(
                    key: ValueKey(quote.text),
                    quote: quote,
                    isFavorite: quoteProvider.isFavorite(quote),
                    isLocked: isLocked,
                    onFavoriteToggle: () {
                      quoteProvider.toggleFavorite(quote);
                    },
                    onInteraction: () {
                      adProvider.recordInteraction();
                    },
                    onUnlockPremium: isLocked
                        ? () {
                            adProvider.showRewardedAd(categoryName);
                          }
                        : null,
                  ),
                );
              },
            ),
          ),

          // Banner ad at bottom
          const BannerAdWidget(),
        ],
      ),
    );
  }
}
