// lib/Controllers/home_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/Events/home_event.dart';
import '../models/States/home_state.dart';
import 'package:flutter/material.dart';
import '../views/screens/recording,Timer/recorder.dart';
import '../views/screens/recording,Timer/timer_setting.dart';
import '../views/screens/teleprompter/scripts.dart';
import '../views/screens/warm-up-exercises/exercises.dart';
import '../views/screens/librarypage.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState()) {
    on<InitializeHomeEvent>(_onInitialize);
    on<RefreshQuoteEvent>(_onRefreshQuote);
  }

  void _onInitialize(InitializeHomeEvent event, Emitter<HomeState> emit) {
    final quotes = [
      "Believe you can and you're halfway there. - Theodore Roosevelt",
      "The only way to do great work is to love what you do. - Steve Jobs",
      "Success is not final, failure is not fatal: It is the courage to continue that counts. - Winston Churchill",
    ];

    final categories = [
      {"title": "Recording", "icon": Icons.mic, "page": const RecorderPage()},
      {
        "title": "Teleprompter",
        "icon": Icons.view_compact,
        "page": const Scripts()
      },
      {
        "title": "Library",
        "icon": Icons.library_books,
        "page": const SpeechLibraryPage()
      },
      {
        "title": "Warm-up",
        "icon": Icons.record_voice_over,
        "page": const Exercises()
      },
      {
        "title": "Timer",
        "icon": Icons.timer,
        "page": const TimerConfigurationPage()
      },
      {"title": "Saving", "icon": Icons.save, "page": const SavingPage()},
    ];

    emit(state.copyWith(
      quotes: quotes,
      currentQuote: quotes[0],
      categories: categories,
    ));
  }

  void _onRefreshQuote(RefreshQuoteEvent event, Emitter<HomeState> emit) {
    final quotes = List<String>.from(state.quotes);
    quotes.shuffle();
    emit(state.copyWith(currentQuote: quotes.first));
  }
}

class SavingPage extends StatelessWidget {
  const SavingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Saving")),
      body: const Center(child: Text("Saving Page")),
    );
  }
}
