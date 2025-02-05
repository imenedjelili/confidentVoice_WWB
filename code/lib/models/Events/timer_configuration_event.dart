
abstract class TimerConfigurationEvent {}

class UpdateHourEvent extends TimerConfigurationEvent {
  final int hour;
  UpdateHourEvent(this.hour);
}

class UpdateMinuteEvent extends TimerConfigurationEvent {
  final int minute;
  UpdateMinuteEvent(this.minute);
}

class UpdateSecondEvent extends TimerConfigurationEvent {
  final int second;
  UpdateSecondEvent(this.second);
}
