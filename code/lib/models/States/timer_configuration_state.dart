abstract class TimerConfigurationState {
  final int hours;
  final int minutes;
  final int seconds;

  TimerConfigurationState({this.hours = 4, this.minutes = 1, this.seconds = 1});
}

class TimerConfigurationInitialState extends TimerConfigurationState {}

class TimerConfigurationUpdatedState extends TimerConfigurationState {
  TimerConfigurationUpdatedState(
      {required super.hours, required super.minutes, required super.seconds});
}
