
abstract class RecordingsEvent {}

class FetchRecordingsEvent extends RecordingsEvent {}

class RemoveRecordingEvent extends RecordingsEvent {
  final int index;

  RemoveRecordingEvent(this.index);
}
