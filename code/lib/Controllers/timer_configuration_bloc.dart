
import 'package:confident_voice/models/Events/timer_configuration_event.dart';
import 'package:confident_voice/models/States/timer_configuration_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimerConfigurationBloc
    extends Bloc<TimerConfigurationEvent, TimerConfigurationState> {
  TimerConfigurationBloc() : super(TimerConfigurationInitialState());

  @override
  Stream<TimerConfigurationState> mapEventToState(
      TimerConfigurationEvent event) async* {
    if (event is UpdateHourEvent) {
      yield TimerConfigurationUpdatedState(
          hours: event.hour, minutes: state.minutes, seconds: state.seconds);
    } else if (event is UpdateMinuteEvent) {
      yield TimerConfigurationUpdatedState(
          hours: state.hours, minutes: event.minute, seconds: state.seconds);
    } else if (event is UpdateSecondEvent) {
      yield TimerConfigurationUpdatedState(
          hours: state.hours, minutes: state.minutes, seconds: event.second);
    }
  }
}
