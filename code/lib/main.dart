import 'package:confident_voice/views/screens/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:confident_voice/Controllers/theme_bloc.dart';
import 'package:confident_voice/Controllers/profile_bloc.dart';
import 'package:confident_voice/views/screens/recording,Timer/RecordingPlayer.dart';
import 'package:confident_voice/views/screens/recording,Timer/recordings.dart';
import 'package:confident_voice/views/screens/recording,Timer/timer.dart';
import 'package:confident_voice/views/screens/homepage.dart';
import 'package:confident_voice/views/screens/profile/personal_information.dart';
import 'package:confident_voice/views/screens/settings/settings.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBloc(prefs)..add(LoadThemeEvent()),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: state.themeData,
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/homepage': (context) => const HomePage(),
              '/Recording': (context) => const RecordingsPage(),
              '/Timer': (context) => const TimerPage(),
              RecordingPlayerPage.recording: (context) =>
                  const RecordingPlayerPage(),
              '/personal_info': (context) => const PersonalInformation(),
              '/settings': (context) => const Settings(),
            },
          );
        },
      ),
    );
  }
}
