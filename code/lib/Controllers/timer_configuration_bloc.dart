import 'package:confident_voice/models/Events/timer_configuration_event.dart';
import 'package:confident_voice/models/States/timer_configuration_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimerConfigurationBloc
    extends Bloc<TimerConfigurationEvent, TimerConfigurationState> {
  TimerConfigurationBloc()
      : super(
            TimerConfigurationUpdatedState(hours: 0, minutes: 0, seconds: 0)) {
    on<UpdateHourEvent>((event, emit) {
      emit(
        TimerConfigurationUpdatedState(
          hours: event.hour,
          minutes: state.minutes,
          seconds: state.seconds,
        ),
      );
      print("Updated Hour: ${event.hour}");
    });

    on<UpdateMinuteEvent>((event, emit) {
      emit(
        TimerConfigurationUpdatedState(
          hours: state.hours,
          minutes: event.minute,
          seconds: state.seconds,
        ),
      );
      print("Updated Minute: ${event.minute}");
    });

    on<UpdateSecondEvent>((event, emit) {
      emit(
        TimerConfigurationUpdatedState(
          hours: state.hours,
          minutes: state.minutes,
          seconds: event.second,
        ),
      );
      print("Updated Second: ${event.second}");
    });
  }
}
