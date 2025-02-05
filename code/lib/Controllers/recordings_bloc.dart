
import 'package:confident_voice/models/Events/recordings_event.dart';
import 'package:confident_voice/models/States/recordings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:confident_voice/databases/db_confidentVoice.dart';
import 'package:confident_voice/models/classes/RecordedData.dart';

class RecordingsBloc extends Bloc<RecordingsEvent, RecordingsState> {
  RecordingsBloc() : super(RecordingsInitial()) {
    on<FetchRecordingsEvent>(_onFetchRecordings);
    on<RemoveRecordingEvent>(_onRemoveRecording);
  }

  Future<void> _onFetchRecordings(
      FetchRecordingsEvent event, Emitter<RecordingsState> emit) async {
    emit(RecordingsLoading());
    try {
      final recordings = await RecordedDataDB.getRecordings(1);
      emit(RecordingsLoaded(recordings.cast<RecordedData>()));
    } catch (e) {
      emit(RecordingsError('Failed to fetch recordings.'));
    }
  }

  Future<void> _onRemoveRecording(
      RemoveRecordingEvent event, Emitter<RecordingsState> emit) async {
    if (state is RecordingsLoaded) {
      final currentRecordings = (state as RecordingsLoaded).recordings;
      try {
        await RecordedDataDB.removeRecording(event.index);
        final updatedRecordings = List<RecordedData>.from(currentRecordings)
          ..removeAt(event.index);
        emit(RecordingsLoaded(updatedRecordings));
      } catch (e) {
        emit(RecordingsError('Failed to remove recording.'));
      }
    }
  }
}
