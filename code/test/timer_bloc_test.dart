import 'package:bloc_test/bloc_test.dart';
import 'package:confident_voice/Controllers/timer_bloc.dart';
import 'package:confident_voice/models/Events/timer_event.dart';
import 'package:confident_voice/models/States/timer_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TimerBloc', () {
    final initialDuration = const Duration(hours: 1, minutes: 30, seconds: 45);

    blocTest<TimerBloc, TimerState>(
      'Initial state is TimerInitial with correct duration',
      build: () => TimerBloc(initialDuration),
      verify: (bloc) {
        expect(bloc.state, TimerInitialState(initialDuration));
      },
    );

    blocTest<TimerBloc, TimerState>(
      'Emits [TimerRunningState] when StartTimerEvent is added',
      build: () => TimerBloc(initialDuration),
      act: (bloc) => bloc.add(StartTimerEvent()),
      expect: () => [TimerRunningState(initialDuration)],
    );

    blocTest<TimerBloc, TimerState>(
      'Emits [TimerPausedState] when PauseTimerEvent is added',
      build: () => TimerBloc(initialDuration),
      act: (bloc) => bloc.add(PauseTimerEvent()),
      expect: () => [TimerPausedState(initialDuration)],
    );

    blocTest<TimerBloc, TimerState>(
      'Emits [TimerRunningState], [TimerPausedState] when StartTimerEvent, PauseTimerEvent are added',
      build: () => TimerBloc(initialDuration),
      act: (bloc) => bloc
        ..add(StartTimerEvent())
        ..add(PauseTimerEvent()),
      expect: () => [
        TimerRunningState(initialDuration),
        TimerPausedState(initialDuration)
      ],
    );

    blocTest<TimerBloc, TimerState>(
      'Emits [TimerRunningState], [TimerPausedState], [TimerRunningState] when StartTimerEvent, PauseTimerEvent, StartTimerEvent are added',
      build: () => TimerBloc(initialDuration),
      act: (bloc) => bloc
        ..add(StartTimerEvent())
        ..add(PauseTimerEvent())
        ..add(StartTimerEvent()),
      expect: () => [
        TimerRunningState(initialDuration),
        TimerPausedState(initialDuration),
        TimerRunningState(initialDuration)
      ],
    );

    blocTest<TimerBloc, TimerState>(
      'Emits [TimerCompletedState] when CancelTimerEvent is added',
      build: () => TimerBloc(initialDuration),
      act: (bloc) => bloc.add(CancelTimerEvent()),
      expect: () => [TimerCompletedState()],
    );

    blocTest<TimerBloc, TimerState>(
      'Updates duration correctly and emits [TimerRunningState] when TimerTickedEvent is added',
      build: () => TimerBloc(initialDuration),
      act: (bloc) => bloc
        ..add(StartTimerEvent()) // Start the timer first
        ..add(UpdateTimerEvent(
            const Duration(hours: 1, minutes: 30, seconds: 44))),
      expect: () => [
        TimerRunningState(initialDuration),
        TimerRunningState(const Duration(hours: 1, minutes: 30, seconds: 44))
      ],
    );

    blocTest<TimerBloc, TimerState>(
      'Emits correct sequence and duration updates',
      build: () => TimerBloc(initialDuration),
      act: (bloc) => bloc
        ..add(StartTimerEvent())
        ..add(UpdateTimerEvent(
            const Duration(hours: 1, minutes: 30, seconds: 44)))
        ..add(PauseTimerEvent())
        ..add(UpdateTimerEvent(
            const Duration(hours: 1, minutes: 30, seconds: 43)))
        ..add(StartTimerEvent())
        ..add(UpdateTimerEvent(
            const Duration(hours: 1, minutes: 30, seconds: 42))),
      expect: () => [
        TimerRunningState(initialDuration),
        TimerRunningState(const Duration(hours: 1, minutes: 30, seconds: 44)),
        TimerPausedState(const Duration(hours: 1, minutes: 30, seconds: 44)),
        TimerPausedState(const Duration(hours: 1, minutes: 30, seconds: 43)),
        TimerRunningState(const Duration(hours: 1, minutes: 30, seconds: 43)),
        TimerRunningState(const Duration(hours: 1, minutes: 30, seconds: 42))
      ],
    );

    blocTest<TimerBloc, TimerState>(
      'Timer completes and emits [TimerCompletedState]',
      build: () =>
          TimerBloc(const Duration(seconds: 2)), // Short duration for test
      act: (bloc) async {
        bloc.add(StartTimerEvent());
        await Future.delayed(
            const Duration(seconds: 3)); // Wait for timer to finish
      },
      expect: () => [
        TimerRunningState(const Duration(seconds: 2)),
        TimerRunningState(const Duration(seconds: 1)),
        TimerCompletedState()
      ],
    );

    blocTest<TimerBloc, TimerState>(
      'Timer completes and resets to initial duration on Cancel',
      build: () => TimerBloc(initialDuration),
      act: (bloc) async {
        bloc.add(StartTimerEvent());
        await Future.delayed(
            const Duration(seconds: 2)); // Wait for timer to finish
        bloc.add(CancelTimerEvent());
      },
      expect: () => [
        TimerRunningState(initialDuration), // Initial state
        TimerRunningState(
            initialDuration - const Duration(seconds: 1)), // After 1 sec
        TimerRunningState(
            initialDuration - const Duration(seconds: 2)), // After 2 sec
        TimerCompletedState() // Cancelled and reset
      ],
    );
  });
}
