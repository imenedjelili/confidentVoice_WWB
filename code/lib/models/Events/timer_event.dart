
abstract class TimerEvent {}

class StartTimerEvent extends TimerEvent {}

class PauseTimerEvent extends TimerEvent {}

class CancelTimerEvent extends TimerEvent {}

class UpdateTimerEvent extends TimerEvent {
  final Duration duration;
  UpdateTimerEvent(this.duration);
}
