
import 'package:confident_voice/models/classes/RecordedData.dart';

abstract class RecordingsState {}

class RecordingsInitial extends RecordingsState {}

class RecordingsLoading extends RecordingsState {}

class RecordingsLoaded extends RecordingsState {
  final List<RecordedData> recordings;

  RecordingsLoaded(this.recordings);
}

class RecordingsError extends RecordingsState {
  final String message;

  RecordingsError(this.message);
}
