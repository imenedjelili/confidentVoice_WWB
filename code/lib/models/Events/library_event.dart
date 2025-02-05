// lib/models/Events/library_event.dart
abstract class LibraryEvent {}

class SelectCategoryEvent extends LibraryEvent {
  final String? category;
  SelectCategoryEvent(this.category);
}

class InitializeLibraryEvent extends LibraryEvent {}
