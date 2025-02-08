import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const _database_name = "ConfidentVoice.db";
  static const _database_version = 2; 
  static Database? database;

  static Future<Database> getDatabase() async {
    if (database != null) {
      return database!;
    }

    database = await openDatabase(
      join(await getDatabasesPath(), _database_name),
      version: _database_version,
      onCreate: (db, version) async {
        print("Database initialized. Creating tables...");

        // Create User table
        await db.execute('''
        CREATE TABLE User (
          id TEXT PRIMARY KEY,
          username TEXT NOT NULL,
          email TEXT NOT NULL UNIQUE,
          password TEXT NOT NULL,
          birthday TEXT NOT NULL,
          image TEXT
          is_asset_image INTEGER
        )
      ''');

        print("User table created.");

        await db.execute('''
          CREATE TABLE category (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
          );
        ''');

        await db.execute('''
          CREATE TABLE speech (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            category_id INTEGER NOT NULL,
            content TEXT NOT NULL,
            created_at TEXT,
            title TEXT,
            author TEXT,
            FOREIGN KEY (category_id) REFERENCES category(id)
          );
        ''');

        await db.execute('''
          CREATE TABLE saving (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            category_saving_id INTEGER NOT NULL,
            speech_id INTEGER NOT NULL,
            content_saving TEXT,
            created_at TEXT,
            FOREIGN KEY (category_saving_id) REFERENCES category(id),
            FOREIGN KEY (speech_id) REFERENCES speech(id),
            FOREIGN KEY (content_saving) REFERENCES speech(content)
          );
        ''');

        await db.execute('''
          CREATE TABLE script (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            content TEXT NOT NULL
          );
        ''');

        await db.execute('''
          CREATE TABLE exercise (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,z
            description TEXT NOT NULL,
            period INTEGER NOT NULL,
            status TEXT NOT NULL,
            created_at TEXT
          );
        ''');

        await db.execute('''
          CREATE TABLE steps (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            exercise_id INTEGER NOT NULL,
            content TEXT NOT NULL,
            status TEXT NOT NULL,
            created_at TEXT,
            FOREIGN KEY (exercise_id) REFERENCES exercise(id)
          );
        ''');

        await db.execute('''
          CREATE TABLE recording (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT,
            recording_path TEXT NOT NULL,
            created_at TEXT
            )
        ''');

        await db.execute('''
          CREATE TABLE timer (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            period INTEGER NOT NULL,
            created_at TEXT
          );
        ''');

        await db.execute('''
          CREATE TABLE settings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            dark_mode_enabled BOOLEAN,
            language TEXT,
            email_notifications_enabled BOOLEAN,
            push_notifications_enabled BOOLEAN,
            privacy_policy TEXT,
            FOREIGN KEY (user_id) REFERENCES User(id)
          );
        ''');

        await db.execute('''
          CREATE TABLE feedback (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            comments TEXT,
            rating INTEGER,
            created_at TEXT,
            FOREIGN KEY (user_id) REFERENCES User(id)
          );
        ''');

        await db.execute('''
          CREATE TABLE login_signup_history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            timestamp TEXT NOT NULL,
            activity TEXT NOT NULL,
            FOREIGN KEY (user_id) REFERENCES User(id)
          );
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        print("Database upgraded from $oldVersion to $newVersion");
      },
    );

    return database!;
  }

  // Method to check if a table exists
  static Future<bool> doesTableExist(String tableName) async {
    final database = await getDatabase();
    final result = await database.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName'",
    );
    return result.isNotEmpty;
  }
}
