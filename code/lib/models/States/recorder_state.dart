abstract class RecordersState {
}

class RecorderInitial extends RecordersState {}

class RecorderRecording extends RecordersState {
  final int duration;
  RecorderRecording(this.duration);
}

class RecorderStopped extends RecordersState {}
