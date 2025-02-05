
abstract class TimerConfigurationState {
  final int hours;
  final int minutes;
  final int seconds;

  TimerConfigurationState({this.hours = 0, this.minutes = 0, this.seconds = 0});
}

class TimerConfigurationInitialState extends TimerConfigurationState {}

class TimerConfigurationUpdatedState extends TimerConfigurationState {
  TimerConfigurationUpdatedState(
      {required super.hours, required super.minutes, required super.seconds});
}
