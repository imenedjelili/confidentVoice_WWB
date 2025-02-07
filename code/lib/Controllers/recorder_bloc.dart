import 'package:confident_voice/models/Events/recorder_event.dart';
import 'package:confident_voice/models/States/recorder_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecorderBloc extends Bloc<RecorderEvent, RecordersState> {
  RecorderBloc() : super(RecorderInitial()) {
    on<StartRecordingEvent>((event, emit) {
      emit(RecorderRecording(0)); 
    });

    on<UpdateDurationEvent>((event, emit) {
      if (state is RecorderRecording) {
        emit(RecorderRecording(event.duration));
      }
    });

    on<PauseRecordingEvent>((event, emit) {
      if (state is RecorderRecording) {
        final currentDuration = (state as RecorderRecording).duration;
        emit(RecorderPaused(currentDuration)); 
      }
    });

    on<ResumeRecordingEvent>((event, emit) {
      if (state is RecorderPaused) {
        final pausedDuration = (state as RecorderPaused).pausedDuration;
        emit(RecorderRecording(pausedDuration)); // Resume recording
      }
    });

    on<StopRecordingEvent>((event, emit) {
      emit(RecorderStopped()); // Stop recording
    });
  }
}
