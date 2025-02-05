// lib/Controllers/library_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/Events/library_event.dart';
import '../models/States/library_state.dart';
import 'package:flutter/material.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  LibraryBloc() : super(LibraryState()) {
    on<InitializeLibraryEvent>(_onInitialize);
    on<SelectCategoryEvent>(_onSelectCategory);
  }

  void _onInitialize(InitializeLibraryEvent event, Emitter<LibraryState> emit) {
    final categories = [
      {'label': 'For You', 'icon': Icons.star},
      {'label': 'Marketing', 'icon': Icons.trending_up},
      {'label': 'Art & Photos', 'icon': Icons.photo},
      {'label': 'Science', 'icon': Icons.science},
      {'label': 'Technology', 'icon': Icons.computer},
      {'label': 'Health', 'icon': Icons.health_and_safety},
      {'label': 'Travel', 'icon': Icons.travel_explore},
      {'label': 'Music', 'icon': Icons.music_note},
      {'label': 'Food', 'icon': Icons.fastfood},
      {'label': 'Sports', 'icon': Icons.sports},
      {'label': 'Movies', 'icon': Icons.movie},
      {'label': 'Comedy', 'icon': Icons.sentiment_satisfied},
      {'label': 'Books', 'icon': Icons.book},
    ];

    emit(state.copyWith(categories: categories));
  }

  void _onSelectCategory(
      SelectCategoryEvent event, Emitter<LibraryState> emit) {
    emit(state.copyWith(selectedCategory: event.category));
  }
}
