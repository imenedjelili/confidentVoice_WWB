
abstract class PlaybackEvent {}

class LoadAudioEvent extends PlaybackEvent {
  final String audioPath;

  LoadAudioEvent(this.audioPath);
}

class PlayPauseAudioEvent extends PlaybackEvent {}

class StopAudioEvent extends PlaybackEvent {}

class SeekAudioEvent extends PlaybackEvent {
  final Duration position;

  SeekAudioEvent(this.position);
}
