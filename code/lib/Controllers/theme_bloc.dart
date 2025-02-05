import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events
abstract class ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent {
  final bool isDark;
  ToggleThemeEvent(this.isDark);
}

class LoadThemeEvent extends ThemeEvent {}

// State
class ThemeState {
  final bool isDark;
  final ThemeData themeData;

  ThemeState({required this.isDark, required this.themeData});

  factory ThemeState.initial() {
    return ThemeState(
      isDark: false,
      themeData: _getLightTheme(),
    );
  }

  ThemeState copyWith({bool? isDark, ThemeData? themeData}) {
    return ThemeState(
      isDark: isDark ?? this.isDark,
      themeData: themeData ?? this.themeData,
    );
  }

  static ThemeData _getLightTheme() {
    return ThemeData(
      primarySwatch: Colors.deepPurple,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF6F6F6),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF412963),
        unselectedItemColor: Color(0xFFA26DC5),
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  static ThemeData _getDarkTheme() {
    return ThemeData(
      primarySwatch: Colors.deepPurple,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        selectedItemColor: Color(0xFFA26DC5),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF1E1E1E),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

// Bloc
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _themeKey = 'isDarkMode';
  final SharedPreferences _prefs;

  ThemeBloc(this._prefs) : super(ThemeState.initial()) {
    on<LoadThemeEvent>(_loadTheme);
    on<ToggleThemeEvent>(_toggleTheme);
  }

  Future<void> _loadTheme(LoadThemeEvent event, Emitter<ThemeState> emit) async {
    final isDark = _prefs.getBool(_themeKey) ?? false;
    emit(ThemeState(
      isDark: isDark,
      themeData: isDark ? ThemeState._getDarkTheme() : ThemeState._getLightTheme(),
    ));
  }

  Future<void> _toggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) async {
    await _prefs.setBool(_themeKey, event.isDark);
    emit(ThemeState(
      isDark: event.isDark,
      themeData: event.isDark ? ThemeState._getDarkTheme() : ThemeState._getLightTheme(),
    ));
  }
}
