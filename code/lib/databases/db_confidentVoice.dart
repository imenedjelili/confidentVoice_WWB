import 'package:confident_voice/databases/dbhelper.dart';

class UserDB {
  // Get all users
  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final database = await DBHelper.getDatabase();
    return database.rawQuery('''SELECT * FROM User''');
  }

  // Insert a new user
  static Future<int> insertUser(Map<String, dynamic> data) async {
    final database = await DBHelper.getDatabase();
    return await database.insert("User", data);
  }

  // Update an existing user
  static Future<int> updateUser(Map<String, dynamic> data, int id) async {
    final database = await DBHelper.getDatabase();
    return await database
        .update("User", data, where: "id = ?", whereArgs: [id]);
  }

  // Delete a user
  static Future<void> deleteUser(int id) async {
    final database = await DBHelper.getDatabase();
    await database.delete("User", where: "id = ?", whereArgs: [id]);
  }
}

class QuotesDB {
  static Future<List<Map<String, dynamic>>> getAllQuotes() async {
    final database = await DBHelper.getDatabase();
    return database.rawQuery('''SELECT * FROM Quotes''');
  }

  static Future<int> insertQuote(Map<String, dynamic> data) async {
    final database = await DBHelper.getDatabase();
    return await database.insert("Quotes", data);
  }
}

class SettingsDB {
  static Future<List<Map<String, dynamic>>> getSettings(int userId) async {
    final database = await DBHelper.getDatabase();
    return database
        .rawQuery('''SELECT * FROM Settings WHERE user_id = ?''', [userId]);
  }

  static Future<int> insertSettings(Map<String, dynamic> data) async {
    final database = await DBHelper.getDatabase();
    return await database.insert("Settings", data);
  }

  static Future<int> updateSettings(
      Map<String, dynamic> data, int userId) async {
    final database = await DBHelper.getDatabase();
    return await database
        .update("Settings", data, where: "user_id = ?", whereArgs: [userId]);
  }
}

class ExercisesDB {
  Future<int> insertExercise(Map<String, dynamic> exercise) async {
    final db = await DBHelper.getDatabase();
    int exerciseId = await db.insert('Exercises', {
      'title': exercise['title'],
      'duration': exercise['duration'],
      'progress': exercise['progress'],
      'imagePath': exercise['imagePath'],
    });
    Future<List<Map<String, dynamic>>> fetchExercises() async {
      final db = await DBHelper.getDatabase();
      List<Map<String, dynamic>> exercises = await db.query('Exercises');

      for (var exercise in exercises) {
        List<Map<String, dynamic>> steps = await db.query(
          'Steps',
          where: 'exerciseId = ?',
          whereArgs: [exercise['id']],
        );

        exercise['steps'] =
            steps.map((step) => step['step'] as String).toList();
      }

      return exercises;
    }

    void populateDatabase() async {
      List<Map<String, dynamic>> exercises = [
        {
          'title': 'Deep Breathing',
          'duration': '5 minutes',
          'progress': 0.7,
          'imagePath': 'assets/images/exo1.png',
          'steps': [
            'Step 1: Inhale deeply through your nose for 4 seconds.',
            'Step 2: Hold your breath for 7 seconds.',
            'Step 3: Exhale slowly through your mouth for 8 seconds.',
            'Step 4: Repeat the process for 5 minutes.'
          ],
        },
        // Add other exercises here
      ];

      for (var exercise in exercises) {
        await insertExercise(exercise);
      }
    }

    List<String> steps = List<String>.from(exercise['steps']);
    for (String step in steps) {
      await db.insert('Steps', {'exerciseId': exerciseId, 'step': step});
    }

    return exerciseId;
  }

  static Future<List<Map<String, dynamic>>> getExercises(int userId) async {
    final database = await DBHelper.getDatabase();
    return database
        .rawQuery('''SELECT * FROM Exercises WHERE user_id = ?''', [userId]);
  }
}

class RecordedDataDB {
  static Future<List<Map<String, dynamic>>> getRecordings(String userId) async {
    final database = await DBHelper.getDatabase();
    return database.rawQuery(
        '''SELECT recording_path FROM recording WHERE user_id = ?''',
        [userId]);
  }

  static Future<int> insertRecording(Map<String, dynamic> data) async {
    final database = await DBHelper.getDatabase();
    return await database.insert("recording", data);
  }

  static Future<int> removeRecording(int id) async {
    final database = await DBHelper.getDatabase();
    return await database
        .delete("recording", where: "id = ?", whereArgs: [id]);
  }
}

class LoginSignupHistoryDB {
  static Future<List<Map<String, dynamic>>> getHistory(int userId) async {
    final database = await DBHelper.getDatabase();
    return database.rawQuery(
        '''SELECT * FROM LoginSignupHistory WHERE user_id = ?''', [userId]);
  }

  static Future<int> insertHistory(Map<String, dynamic> data) async {
    final database = await DBHelper.getDatabase();
    return await database.insert("LoginSignupHistory", data);
  }
}

class FeedbackDB {
  static Future<List<Map<String, dynamic>>> getFeedback(int userId) async {
    final database = await DBHelper.getDatabase();
    return database
        .rawQuery('''SELECT * FROM Feedback WHERE user_id = ?''', [userId]);
  }

  static Future<int> insertFeedback(Map<String, dynamic> data) async {
    final database = await DBHelper.getDatabase();
    return await database.insert("Feedback", data);
  }
}
