// lib/models/States/library_state.dart
class LibraryState {
  final String? selectedCategory;
  final List<Map<String, dynamic>> categories;

  LibraryState({
    this.selectedCategory,
    this.categories = const [],
  });

  LibraryState copyWith({
    String? selectedCategory,
    List<Map<String, dynamic>>? categories,
  }) {
    return LibraryState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      categories: categories ?? this.categories,
    );
  }
}
