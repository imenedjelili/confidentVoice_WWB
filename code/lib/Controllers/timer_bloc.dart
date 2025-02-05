// timer_bloc.dart
import 'dart:async';
import 'package:confident_voice/models/Events/timer_event.dart';
import 'package:confident_voice/models/States/timer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class TimerBloc extends Bloc<TimerEvent, TimerState> {
  Timer? _timer;
  late Duration _duration;

  TimerBloc(Duration initialDuration)
      : super(TimerInitialState(initialDuration)) {
    _duration = initialDuration;

    on<StartTimerEvent>((event, emit) {
      _startTimer();
      emit(TimerRunningState(_duration));
    });

    on<PauseTimerEvent>((event, emit) {
      _pauseTimer();
      emit(TimerPausedState(_duration));
    });

    on<CancelTimerEvent>((event, emit) {
      _cancelTimer();
      emit(TimerCompletedState());
    });

    on<UpdateTimerEvent>((event, emit) {
      _duration = event.duration;
      emit(TimerRunningState(_duration));
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_duration.inSeconds > 0) {
        _duration = _duration - const Duration(seconds: 1);
        add(UpdateTimerEvent(_duration));
      } else {
        _timer?.cancel();
        add(CancelTimerEvent());
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
  }

  void _cancelTimer() {
    _timer?.cancel();
    _duration = Duration.zero;
  }
}
