import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confident_voice/views/screens/splashScreen.dart';
import 'package:confident_voice/views/themes/themeprovider.dart';
import 'package:confident_voice/views/themes/theme.dart';
import 'package:confident_voice/views/screens/homepage.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode:
              themeNotifier.themeMode, 
          home: const SplashScreen(),
          routes: {
            '/home': (context) => const HomePage(),
          },
        );
      },
    );
  }
}
