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
  static Future<List<Map<String, dynamic>>> getExercises(int userId) async {
    final database = await DBHelper.getDatabase();
    return database
        .rawQuery('''SELECT * FROM Exercises WHERE user_id = ?''', [userId]);
  }

  static Future<int> insertExercise(Map<String, dynamic> data) async {
    final database = await DBHelper.getDatabase();
    return await database.insert("Exercises", data);
  }
}

class RecordedDataDB {
  static Future<List<Map<String, dynamic>>> getRecordings(int userId) async {
    final database = await DBHelper.getDatabase();
    return database.rawQuery(
        '''SELECT recording_path FROM RecordedData WHERE user_id = ?''',
        [userId]);
  }

  static Future<int> insertRecording(Map<String, dynamic> data) async {
    final database = await DBHelper.getDatabase();
    return await database.insert("RecordedData", data);
  }

  static Future<int> removeRecording(int id) async {
    final database = await DBHelper.getDatabase();
    return await database
        .delete("RecordedData", where: "id = ?", whereArgs: [id]);
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
