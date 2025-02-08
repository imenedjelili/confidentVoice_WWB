import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
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
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'firebase_options.dart'; 
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const String channelId = 'high_importance_channel'; 
const String channelName = 'High Importance Notifications'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings(
          '@mipmap/ic_launcher'); 
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await _createNotificationChannel(); 

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://mxyimmdjdeodycerflhx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im14eWltbWRqZGVvZHljZXJmbGh4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg4MzQ0NjcsImV4cCI6MjA1NDQxMDQ2N30.bEHRspfm_QqXWRKU10kOnQGbVdR44zrzNMibmMonKq8', // Corrected key (truncated for security)
  );

  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  if (!kIsWeb && kDebugMode) {
    final dbPath = path.join(await getDatabasesPath(), 'ConfidentVoice.db');
    if (await databaseExists(dbPath)) {
      await deleteDatabase(dbPath);
    }
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission!');

    String? token = await messaging.getToken();
    if (token != null) {
      print('FCM token: $token');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground message: ${message.messageId}");
      _showFlutterLocalNotification(message);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message opened from background: ${message.messageId}');
      _handleMessage(message);
    });
  } else {
    print('User declined or has not yet requested permission.');
  }

  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

Future<void> _createNotificationChannel() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    channelId, 
    channelName,
    description:
        'This channel is for high importance notifications.', 
    importance:
        Importance.max, 
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Handling a background message: ${message.messageId}");
  _showFlutterLocalNotification(message); 
}

void _showFlutterLocalNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId, 
          channelName,
          importance: Importance.max,
          priority: Priority.high,
          ticker: notification.title,
        ),
      ),
    );
  }
}

void _handleMessage(RemoteMessage message) {
  if (message.data['route'] != null) {
    String route = message.data['route'];
    print('Navigating to route: $route');
  }
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
