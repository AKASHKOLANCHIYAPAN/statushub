/// Represents a single quote with its metadata.
class Quote {
  final String text;
  final String category;
  final bool isPremium;
  bool isFavorite;

  Quote({
    required this.text,
    required this.category,
    this.isPremium = false,
    this.isFavorite = false,
  });

  /// Creates a Quote from a JSON string and category name.
  factory Quote.fromData({
    required String text,
    required String category,
    bool isPremium = false,
  }) {
    return Quote(
      text: text,
      category: category,
      isPremium: isPremium,
    );
  }

  /// Serializes to a map for local storage.
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'category': category,
      'isPremium': isPremium,
    };
  }

  /// Deserializes from a map (used for favorites).
  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      text: map['text'] ?? '',
      category: map['category'] ?? '',
      isPremium: map['isPremium'] ?? false,
      isFavorite: true,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Quote &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          category == other.category;

  @override
  int get hashCode => text.hashCode ^ category.hashCode;
}
