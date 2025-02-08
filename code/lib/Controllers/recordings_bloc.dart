import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confident_voice/models/Events/recordings_event.dart';
import 'package:confident_voice/models/States/recordings_state.dart';
import 'package:confident_voice/models/classes/RecordedData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:confident_voice/databases/db_confidentVoice.dart';

class RecordingsBloc extends Bloc<RecordingsEvent, RecordingsState> {
      String userId;
  RecordingsBloc({required this.userId}) : super(RecordingsInitial()) {
    on<FetchRecordingsEvent>(_onFetchRecordings);
    on<RemoveRecordingEvent>(_onRemoveRecording);
  }


  Future<void> _onFetchRecordings(
      FetchRecordingsEvent event, Emitter<RecordingsState> emit) async {
    emit(RecordingsLoading());
    try {
      if (userId != null) {
        final recordingsFromDb = await RecordedDataDB.getRecordings(userId);
        print("userid  ${userId}");
        print(recordingsFromDb);
        List<RecordedData> recordings = recordingsFromDb.map((map) {
          return RecordedData.fromMap(map);
        }).toList();

        emit(RecordingsLoaded(recordings));
      } else {
        emit(RecordingsError(
            'User ID not found ${userId}.')); // Handle the case where userId is null
      }
    } catch (e) {
      emit(RecordingsError(
          'Failed to fetch recordings: $e')); // Include the error message
    }
  }

  // 2. Implement the _getUserId() function:
//   Future<String?> _getUserId() async {
//     try {
//      User? user = FirebaseAuth.instance.currentUser;
//      print(user?.uid);
// ;      if (user != null) {
//         print(user.uid);
//         return user.uid;
        
//       }
//       return null;
//     } catch (e) {
//       print("Error getting user ID: $e");
//       return null;
//     }
//   }

  Future<void> _onRemoveRecording(
      RemoveRecordingEvent event, Emitter<RecordingsState> emit) async {
    if (state is RecordingsLoaded) {
      final currentRecordings = (state as RecordingsLoaded).recordings;
      try {
        await RecordedDataDB.removeRecording(event.index);
        final updatedRecordings = currentRecordings
            .where((recording) => recording.id != event.index)
            .toList();

        emit(RecordingsLoaded(updatedRecordings));
      } catch (e) {
        emit(RecordingsError('Failed to remove recording.'));
      }
    }
  }
}


