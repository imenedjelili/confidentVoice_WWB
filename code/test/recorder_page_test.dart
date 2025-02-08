import 'package:bloc_test/bloc_test.dart';
import 'package:confident_voice/Controllers/recorder_bloc.dart';
import 'package:confident_voice/models/Events/recorder_event.dart';
import 'package:confident_voice/models/States/recorder_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RecorderBloc', () {
    blocTest<RecorderBloc, RecordersState>(
      'Initial state is RecorderInitial',
      build: () => RecorderBloc(),
      verify: (bloc) {
        expect(bloc.state, isA<RecorderInitial>());
      },
    );

    blocTest<RecorderBloc, RecordersState>(
      'Emits [RecorderRecording] when StartRecordingEvent is added',
      build: () => RecorderBloc(),
      act: (bloc) => bloc.add(StartRecordingEvent()),
      expect: () => [isA<RecorderRecording>()],
    );

    blocTest<RecorderBloc, RecordersState>(
      'Emits [RecorderPaused] when PauseRecordingEvent is added',
      build: () => RecorderBloc(),
      act: (bloc) => bloc.add(PauseRecordingEvent()),
      expect: () => [isA<RecorderPaused>()],
    );

    blocTest<RecorderBloc, RecordersState>(
      'Emits [RecorderRecording] then [RecorderPaused] when StartRecordingEvent and PauseRecordingEvent are added',
      build: () => RecorderBloc(),
      act: (bloc) => bloc
        ..add(StartRecordingEvent())
        ..add(PauseRecordingEvent()),
      expect: () => [isA<RecorderRecording>(), isA<RecorderPaused>()],
    );

    blocTest<RecorderBloc, RecordersState>(
      'Emits [RecorderRecording] then [RecorderPaused] then [RecorderRecording] when StartRecordingEvent, PauseRecordingEvent, and ResumeRecordingEvent are added',
      build: () => RecorderBloc(),
      act: (bloc) => bloc
        ..add(StartRecordingEvent())
        ..add(PauseRecordingEvent())
        ..add(ResumeRecordingEvent()),
      expect: () => [
        isA<RecorderRecording>(),
        isA<RecorderPaused>(),
        isA<RecorderRecording>()
      ],
    );

    blocTest<RecorderBloc, RecordersState>(
      'Emits [RecorderRecording] then [RecorderStopped] when StartRecordingEvent and StopRecordingEvent are added',
      build: () => RecorderBloc(),
      act: (bloc) => bloc
        ..add(StartRecordingEvent())
        ..add(StopRecordingEvent()),
      expect: () => [isA<RecorderRecording>(), isA<RecorderStopped>()],
    );

    blocTest<RecorderBloc, RecordersState>(
      'Emits [RecorderRecording] with correct duration when UpdateDurationEvent is added',
      build: () => RecorderBloc(),
      act: (bloc) => bloc
        ..add(StartRecordingEvent())
        ..add(UpdateDurationEvent(30)),
      expect: () => [isA<RecorderRecording>(), RecorderRecording(30)],
    );

    blocTest<RecorderBloc, RecordersState>(
      'Emits [RecorderRecording] then [RecorderPaused] with correct duration when StartRecordingEvent, UpdateDurationEvent and PauseRecordingEvent are added',
      build: () => RecorderBloc(),
      act: (bloc) => bloc
        ..add(StartRecordingEvent())
        ..add(UpdateDurationEvent(30))
        ..add(PauseRecordingEvent()),
      expect: () => [
        isA<RecorderRecording>(),
        RecorderRecording(30),
        isA<RecorderPaused>()
      ],
    );

    blocTest<RecorderBloc, RecordersState>(
      'Emits [RecorderRecording] then [RecorderPaused] with correct duration then [RecorderRecording] with updated duration when StartRecordingEvent, UpdateDurationEvent, PauseRecordingEvent and UpdateDurationEvent are added',
      build: () => RecorderBloc(),
      act: (bloc) => bloc
        ..add(StartRecordingEvent())
        ..add(UpdateDurationEvent(30))
        ..add(PauseRecordingEvent())
        ..add(UpdateDurationEvent(40)),
      expect: () => [
        isA<RecorderRecording>(),
        RecorderRecording(30),
        isA<RecorderPaused>(),
        RecorderRecording(40)
      ],
    );
  });
}
