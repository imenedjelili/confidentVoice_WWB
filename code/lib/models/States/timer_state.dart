
abstract class TimerState {
  final Duration duration;
  final bool isRunning;
  TimerState(this.duration, this.isRunning);
}

class TimerInitialState extends TimerState {
  TimerInitialState(Duration duration) : super(duration, false);
}

class TimerRunningState extends TimerState {
  TimerRunningState(Duration duration) : super(duration, true);
}

class TimerPausedState extends TimerState {
  TimerPausedState(Duration duration) : super(duration, false);
}

class TimerCompletedState extends TimerState {
  TimerCompletedState() : super(Duration.zero, false);
}
