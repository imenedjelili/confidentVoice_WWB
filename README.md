# ConfidentVoice 🎙️

A Flutter mobile application designed to help users build public speaking confidence through voice recording, warm-up exercises, teleprompter scripts, a PDF library, and progress tracking — all backed by Firebase and Supabase.

---

## ✨ Features

- **Voice Recorder** — Record, play back, and manage audio recordings with waveform visualization
- **Practice Timer** — Configurable countdown timer with custom session settings for timed speaking practice
- **Warm-Up Exercises** — Guided vocal and breathing exercises to prepare before speaking
- **Teleprompter** — Create and scroll through custom scripts while practicing
- **PDF Library** — Browse, view, and manage speech-related PDF documents
- **Progress Tracker** — Visual charts and history to track improvement over time
- **Speech-to-Text** — Real-time transcription of spoken practice sessions
- **Authentication** — Email/password sign-up and Google Sign-In via Firebase Auth
- **User Profiles** — Profile picture, personal info, security settings, and edit capabilities
- **Motivational Quotes** — Daily quotes to keep users inspired
- **Push Notifications** — Firebase Cloud Messaging for reminders and updates
- **Dark/Light Theme** — Fully themeable UI with persistent preferences
- **Premium Plan** — In-app premium tier with upgraded features

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x / Dart ^3.5.2 |
| State Management | Flutter BLoC + Cubit |
| Backend | Firebase (Auth, Firestore, Storage, Messaging, App Check) |
| Secondary Backend | Supabase |
| Local Database | SQLite via `sqflite` (web: `sqflite_common_ffi_web`) |
| Audio | `record`, `audioplayers`, `audio_waveforms` |
| PDF Viewer | `syncfusion_flutter_pdfviewer` |
| Charts | `fl_chart` |
| Speech-to-Text | `speech_to_text` |
| Notifications | `firebase_messaging` + `flutter_local_notifications` |

---

## 📁 Project Structure

```
lib/
├── Controllers/        # BLoC/Cubit state management
├── commons/            # App-wide config and constants
├── data/
│   ├── quotes.dart
│   └── repo/           # Authentication repository
├── databases/          # SQLite helpers
├── models/
│   ├── classes/        # Data models (User, RecordedData, Quote, etc.)
│   ├── Events/         # BLoC events
│   └── States/         # BLoC states
├── providers/          # Theme provider
├── services/           # Document and progress services
├── utils/              # String extensions
├── views/
│   ├── screens/        # All app screens
│   │   ├── auth/
│   │   ├── login/
│   │   ├── signup/
│   │   ├── welcomePages/
│   │   ├── recording,Timer/
│   │   ├── teleprompter/
│   │   ├── warm-up-exercises/
│   │   ├── profile/
│   │   ├── settings/
│   │   └── ProVersion/
│   ├── themes/         # Colors, styles, theme definitions
│   └── widgets/        # Reusable UI components
└── widgets/            # Global widgets (snackbars, etc.)
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `^3.5.2`
- Dart `^3.5.2`
- A Firebase project with Android/iOS apps configured
- A Supabase project

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/confidentVoice.git
   cd confidentVoice/code
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
   - Enable **Authentication** (Email/Password + Google), **Firestore**, **Storage**, **Messaging**, and **App Check**
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) and place them in the respective platform folders
   - Update `lib/firebase_options.dart` with your project credentials (or use the FlutterFire CLI: `flutterfire configure`)

4. **Configure Supabase**
   - Create a project at [supabase.com](https://supabase.com)
   - Replace the `url` and `anonKey` in `lib/main.dart` with your project credentials:
     ```dart
     await Supabase.initialize(
       url: 'YOUR_SUPABASE_URL',
       anonKey: 'YOUR_SUPABASE_ANON_KEY',
     );
     ```

5. **Run the app**
   ```bash
   flutter run
   ```

---

## 🔐 Environment & Secrets

> ⚠️ **Never commit real API keys or credentials to source control.**

Before pushing to GitHub:
- Replace the Supabase `anonKey` in `main.dart` with an environment variable or secrets manager
- Add `android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist` to `.gitignore`
- Rotate any keys that have already been exposed

---

## 🧪 Running Tests

```bash
flutter test
```

BLoC tests are located alongside their controllers. The project uses `bloc_test` and `flutter_test`.

---

## 📦 Key Dependencies

| Package | Purpose |
|---|---|
| `flutter_bloc` | State management |
| `firebase_auth` | User authentication |
| `cloud_firestore` | Cloud database |
| `firebase_storage` | File/image storage |
| `firebase_messaging` | Push notifications |
| `supabase_flutter` | Secondary backend |
| `sqflite` | Local SQLite database |
| `record` + `audioplayers` | Audio recording & playback |
| `audio_waveforms` | Waveform visualization |
| `speech_to_text` | Live transcription |
| `syncfusion_flutter_pdfviewer` | PDF viewing |
| `fl_chart` | Progress charts |
| `google_sign_in` | Google authentication |
| `image_picker` | Profile picture selection |
| `shared_preferences` | Persistent local settings |

---

## 🤝 Contributing

Contributions are welcome! Please open an issue first to discuss what you'd like to change, then submit a pull request.

1. Fork the project
2. Create your feature branch: `git checkout -b feature/my-feature`
3. Commit your changes: `git commit -m 'Add my feature'`
4. Push to the branch: `git push origin feature/my-feature`
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
