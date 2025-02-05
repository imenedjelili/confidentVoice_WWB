// lib/models/States/home_state.dart

class HomeState {
  final String currentQuote;
  final List<String> quotes;
  final List<Map<String, dynamic>> categories;

  HomeState({
    this.currentQuote = '',
    this.quotes = const [],
    this.categories = const [],
  });

  HomeState copyWith({
    String? currentQuote,
    List<String>? quotes,
    List<Map<String, dynamic>>? categories,
  }) {
    return HomeState(
      currentQuote: currentQuote ?? this.currentQuote,
      quotes: quotes ?? this.quotes,
      categories: categories ?? this.categories,
    );
  }
}
