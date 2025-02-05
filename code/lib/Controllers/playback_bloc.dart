
import 'package:confident_voice/models/Events/playback_event.dart';
import 'package:confident_voice/models/States/playback_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';

class PlaybackBloc extends Bloc<PlaybackEvent, PlaybackState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _duration = Duration.zero;

  PlaybackBloc() : super(PlaybackInitial()) {
    on<LoadAudioEvent>(_onLoadAudio);
    on<PlayPauseAudioEvent>(_onPlayPauseAudio);
    on<StopAudioEvent>(_onStopAudio);
    on<SeekAudioEvent>(_onSeekAudio);

    _audioPlayer.onDurationChanged.listen((duration) {
      _duration = duration;
    });

    _audioPlayer.onPositionChanged.listen((position) {
      if (state is PlaybackReady) {
        final currentState = state as PlaybackReady;
        emit(PlaybackReady(
          audioPath: currentState.audioPath,
          isPlaying: currentState.isPlaying,
          duration: _duration,
          position: position,
        ));
      }
    });
  }

  Future<void> _onLoadAudio(
      LoadAudioEvent event, Emitter<PlaybackState> emit) async {
    emit(PlaybackLoading());
    try {
      await _audioPlayer.setSource(DeviceFileSource(event.audioPath));
      emit(PlaybackReady(
        audioPath: event.audioPath,
        isPlaying: false,
        duration: _duration,
        position: Duration.zero,
      ));
    } catch (e) {
      emit(PlaybackError('Failed to load audio'));
    }
  }

  Future<void> _onPlayPauseAudio(
      PlayPauseAudioEvent event, Emitter<PlaybackState> emit) async {
    if (state is PlaybackReady) {
      final currentState = state as PlaybackReady;
      if (currentState.isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.resume();
      }
      emit(PlaybackReady(
        audioPath: currentState.audioPath,
        isPlaying: !currentState.isPlaying,
        duration: _duration,
        position: currentState.position,
      ));
    }
  }

  Future<void> _onStopAudio(
      StopAudioEvent event, Emitter<PlaybackState> emit) async {
    if (state is PlaybackReady) {
      await _audioPlayer.stop();
      emit(PlaybackReady(
        audioPath: (state as PlaybackReady).audioPath,
        isPlaying: false,
        duration: _duration,
        position: Duration.zero,
      ));
    }
  }

  Future<void> _onSeekAudio(
      SeekAudioEvent event, Emitter<PlaybackState> emit) async {
    if (state is PlaybackReady) {
      await _audioPlayer.seek(event.position);
      emit(PlaybackReady(
        audioPath: (state as PlaybackReady).audioPath,
        isPlaying: (state as PlaybackReady).isPlaying,
        duration: _duration,
        position: event.position,
      ));
    }
  }

  @override
  Future<void> close() {
    _audioPlayer.dispose();
    return super.close();
  }
}
