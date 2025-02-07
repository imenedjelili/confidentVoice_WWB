import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:confident_voice/Controllers/theme_bloc.dart';
import 'package:confident_voice/Controllers/profile_bloc.dart';
import 'package:confident_voice/views/screens/splashScreen.dart';
import 'package:confident_voice/views/screens/recording,Timer/RecordingPlayer.dart';
import 'package:confident_voice/views/screens/recording,Timer/recordings.dart';
import 'package:confident_voice/views/screens/recording,Timer/timer.dart';
import 'package:confident_voice/views/screens/homepage.dart';
import 'package:confident_voice/views/screens/profile/personal_information.dart';
import 'package:confident_voice/views/screens/settings/settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as path;
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database factory for web
  if (kIsWeb) {
    // Initialize databaseFactory for web
    databaseFactory = databaseFactoryFfiWeb;
  }
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://mxyimmdjdeodycerflhx.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im14eWltbWRqZGVvZHljZXJmbGh4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg4MzQ0NjcsImV4cCI6MjA1NDQxMDQ2N30.bEHRspfm_QqXWRKU10kOnQGbVdR44zrzNMibmMonKq8',
  );

  // Only try to delete database if not on web
  if (!kIsWeb) {
    final dbPath = path.join(await getDatabasesPath(), 'ConfidentVoice.db');
    if (await databaseExists(dbPath)) {
      await deleteDatabase(dbPath);
    }
  }

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
            home: const SplashScreen(),
            routes: {
              '/home': (context) => const HomePage(
                    userName: 'Guest User',
                    profilePictureUrl: 'assets/images/image_placeholder.png', userEmail: '',
                  ),
              '/Timer': (context) => const TimerPage(),
              '/Recording': (context) => const RecordingsPage(),
              '/RecordingPlayer': (context) => const RecordingPlayerPage(),
              '/settings': (context) => const Settings(),
              '/personal_info': (context) => const PersonalInformation(),
            },
          );
        },
      ),
    );
  }
}
