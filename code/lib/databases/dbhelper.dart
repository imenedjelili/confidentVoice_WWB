import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const _database_name = "ConfidentVoice.db";
  static const _database_version = 1;
  static var database;

  static Future getDatabase() async {
    if (database != null) {
      return database;
    }

    database = openDatabase(
      join(await getDatabasesPath(), _database_name),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usr (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT NOT NULL,
            birth_date TEXT NOT NULL,
            gender TEXT NOT NULL,
            password TEXT NOT NULL,
            full_name TEXT NOT NULL,
            profile_picture TEXT,  -- URL or path to the profile picture
            created_at TEXT
          );
        ''');

        // Creating the Category table
        await db.execute('''
          CREATE TABLE category (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
          );
        ''');

        // Creating the Speech table
        await db.execute('''
          CREATE TABLE speech (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            category_id INTEGER NOT NULL,
            content TEXT NOT NULL,
            created_at TEXT,
            FOREIGN KEY (category_id) REFERENCES category(id)
            title TEXT,
            author TEXT
          );
        ''');

        // Creating the Saving table
        await db.execute('''
          CREATE TABLE saving (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            category_saving_id INTEGER NOT NULL,
            speech_id INTEGER NOT NULL,
            content_saving TEXT
            created_at TEXT,
            FOREIGN KEY (category_saving_id) REFERENCES Speech(category_id),
            FOREIGN KEY (speech_id) REFERENCES Speech(id)
            FOREIGN KEY (content_saving) REFERENCES Speech(content)
          );
        ''');

        // Creating the Script table
        await db.execute('''
          CREATE TABLE script (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            content TEXT NOT NULL
          );
        ''');

        // Creating the Exercise table
        await db.execute('''
          CREATE TABLE exercise (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT NOT NULL,
            period INTEGER NOT NULL,
            status enum NOT NULL
            created_at TEXT
          );
        ''');

        // Creating the Steps table
        await db.execute('''
          CREATE TABLE Steps (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            exercise_id INTEGER NOT NULL,
            content TEXT NOT NULL,
            status enum NOT NULL,
            created_at TEXT
            FOREIGN KEY (exercise_id) REFERENCES exercise(id)
          );
        ''');

        // Creating the Recording table
        await db.execute('''
          CREATE TABLE recording (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            recording_path TEXT NOT NULL,
            created_at TEXT,
            FOREIGN KEY (user_id) REFERENCES usr(id)
          );
        ''');

        // Creating the Timer table
        await db.execute('''
          CREATE TABLE timer (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            period INTEGER NOT NULL,
            created_at TEXT
          );
        ''');

        // Creating the Settings table
        await db.execute('''
          CREATE TABLE settings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            dark_mode_enabled BOOLEAN,
            language TEXT,
            email_notifications_enabled BOOLEAN,
            push_notifications_enabled BOOLEAN,
            privacy_policy TEXT,
            FOREIGN KEY (user_id) REFERENCES usr(id)
          );
        ''');

        await db.execute('''
          CREATE TABLE Feedback (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            comments TEXT,
            rating INTEGER,
            created_at TEXT,
            FOREIGN KEY (user_id) REFERENCES Users(id)
          );
        ''');
        
        await db.execute('''
          CREATE TABLE LoginSignupHistory (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            timestamp TEXT NOT NULL,
            activity TEXT NOT NULL,
            FOREIGN KEY (user_id) REFERENCES Users(id)
          );
        ''');
      },
      version: _database_version,
      onUpgrade: (db, oldVersion, newVersion) {},
    );
    return database;
  }
}
