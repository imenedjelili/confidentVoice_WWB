
abstract class PlaybackState {}

class PlaybackInitial extends PlaybackState {}

class PlaybackLoading extends PlaybackState {}

class PlaybackReady extends PlaybackState {
  final String audioPath;
  final bool isPlaying;
  final Duration duration;
  final Duration position;

  PlaybackReady({
    required this.audioPath,
    required this.isPlaying,
    required this.duration,
    required this.position,
  });
}

class PlaybackError extends PlaybackState {
  final String message;

  PlaybackError(this.message);
}
