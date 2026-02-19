import 'package:flutter/material.dart';

/// Represents a quote category with display info.
class Category {
  final String name;
  final IconData icon;
  final Color color;
  final int quoteCount;

  const Category({
    required this.name,
    required this.icon,
    required this.color,
    required this.quoteCount,
  });

  /// Maps icon string names from JSON to Material Icons.
  static IconData iconFromString(String iconName) {
    switch (iconName) {
      case 'favorite':
        return Icons.favorite;
      case 'water_drop':
        return Icons.water_drop;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'emoji_events':
        return Icons.emoji_events;
      case 'sentiment_very_satisfied':
        return Icons.sentiment_very_satisfied;
      case 'wb_sunny':
        return Icons.wb_sunny;
      case 'cake':
        return Icons.cake;
      case 'celebration':
        return Icons.celebration;
      case 'favorite_border':
        return Icons.favorite_border;
      case 'military_tech':
        return Icons.military_tech;
      default:
        return Icons.format_quote;
    }
  }

  /// Parses a hex color string to Color.
  static Color colorFromHex(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
}
