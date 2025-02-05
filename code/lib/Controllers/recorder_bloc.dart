import 'package:confident_voice/models/Events/recorder_event.dart';
import 'package:confident_voice/models/States/recorder_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class RecorderBloc extends Bloc<RecorderEvent, RecordersState> {
  RecorderBloc() : super(RecorderInitial()) {
    on<StartRecordingEvent>((event, emit) {
      emit(RecorderRecording(0)); // Start recording with 0 duration.
    });

    on<UpdateDurationEvent>((event, emit) {
      if (state is RecorderRecording) {
        emit(RecorderRecording(event.duration)); // Update duration.
      }
    });

    on<StopRecordingEvent>((event, emit) {
      emit(RecorderStopped()); // Stop recording.
    });
  }
}
