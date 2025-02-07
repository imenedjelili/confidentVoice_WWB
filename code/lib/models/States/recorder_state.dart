abstract class RecordersState {}

class RecorderInitial extends RecordersState {}

class RecorderRecording extends RecordersState {
  final int duration;
  RecorderRecording(this.duration);
}

class RecorderPaused extends RecordersState {
  final int pausedDuration;
  RecorderPaused(this.pausedDuration);
}

class RecorderStopped extends RecordersState {}
