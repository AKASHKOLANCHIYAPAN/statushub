import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../models/quote.dart';

/// Card widget displaying a single quote with copy, share, and favorite actions.
class QuoteCard extends StatefulWidget {
  final Quote quote;
  final bool isFavorite;
  final bool isLocked;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onInteraction;
  final VoidCallback? onUnlockPremium;

  const QuoteCard({
    super.key,
    required this.quote,
    required this.isFavorite,
    this.isLocked = false,
    required this.onFavoriteToggle,
    required this.onInteraction,
    this.onUnlockPremium,
  });

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartController;
  late Animation<double> _heartAnimation;

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _heartAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.quote.text));
    widget.onInteraction();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('✓ Copied to clipboard'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 1),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _shareQuote() {
    Share.share(
      '${widget.quote.text}\n\n— Shared via StatusHub',
      subject: 'Quote from StatusHub',
    );
    widget.onInteraction();
  }

  void _toggleFavorite() {
    _heartController.forward().then((_) => _heartController.reverse());
    widget.onFavoriteToggle();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // If the quote is premium and locked, show a blurred/locked version
    if (widget.isLocked) {
      return _buildLockedCard(theme, isDark);
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quote icon
            Icon(
              Icons.format_quote,
              size: 24,
              color: theme.colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 8),
            // Quote text
            Text(
              widget.quote.text,
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                fontWeight: FontWeight.w400,
                color: isDark ? Colors.white.withOpacity(0.9) : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            // Action buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Copy button
                _ActionButton(
                  icon: Icons.copy_rounded,
                  label: 'Copy',
                  onTap: _copyToClipboard,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                // Share button
                _ActionButton(
                  icon: Icons.share_rounded,
                  label: 'Share',
                  onTap: _shareQuote,
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                // Favorite button with animation
                ScaleTransition(
                  scale: _heartAnimation,
                  child: _ActionButton(
                    icon: widget.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    label: 'Fav',
                    onTap: _toggleFavorite,
                    color:
                        widget.isFavorite ? Colors.redAccent : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLockedCard(ThemeData theme, bool isDark) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: widget.onUnlockPremium,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(
                Icons.lock_rounded,
                size: 28,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Premium Quote',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Watch a short ad to unlock exclusive quotes',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.play_circle_fill_rounded,
                size: 36,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small action button used in quote cards.
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
