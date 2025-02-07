abstract class RecorderEvent {}

class StartRecordingEvent extends RecorderEvent {}

class StopRecordingEvent extends RecorderEvent {}

class UpdateDurationEvent extends RecorderEvent {
  final int duration;
  UpdateDurationEvent(this.duration);
}

class PauseRecordingEvent extends RecorderEvent {}

class ResumeRecordingEvent extends RecorderEvent {}
