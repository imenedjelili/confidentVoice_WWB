import 'package:confident_voice/Controllers/timer_configuration_bloc.dart';
import 'package:confident_voice/models/Events/timer_configuration_event.dart';
import 'package:confident_voice/models/States/timer_configuration_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimerConfigurationPage extends StatelessWidget {
  static const String pageRoute = '/TimerSetting';

  const TimerConfigurationPage({super.key});

  List<int> generateList(int max) {
    return List<int>.generate(max, (index) => index);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimerConfigurationBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Center(
            child: Text(
              'Timer',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple),
            ),
          ),
        ),
        body: BlocBuilder<TimerConfigurationBloc, TimerConfigurationState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Hours',
                        style: TextStyle(
                            color: Colors.purple,
                            fontSize: 20,
                            fontWeight: FontWeight.w600)),
                    SizedBox(width: 30),
                    Text('Minutes',
                        style: TextStyle(
                            color: Colors.purple,
                            fontSize: 20,
                            fontWeight: FontWeight.w600)),
                    SizedBox(width: 30),
                    Text('Seconds',
                        style: TextStyle(
                            color: Colors.purple,
                            fontSize: 20,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildTimePicker(
                      generateList(24),
                      state.hours,
                      (value) {
                        context
                            .read<TimerConfigurationBloc>()
                            .add(UpdateHourEvent(value));
                      },
                    ),
                    const Text(':',
                        style: TextStyle(fontSize: 48, color: Colors.purple)),
                    buildTimePicker(
                      generateList(60),
                      state.minutes,
                      (value) {
                        context
                            .read<TimerConfigurationBloc>()
                            .add(UpdateMinuteEvent(value));
                      },
                    ),
                    const Text(':',
                        style: TextStyle(fontSize: 48, color: Colors.purple)),
                    buildTimePicker(
                      generateList(60),
                      state.seconds,
                      (value) {
                        context
                            .read<TimerConfigurationBloc>()
                            .add(UpdateSecondEvent(value));
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 75),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/Timer',
                      arguments: {
                        'hours': state.hours,
                        'minutes': state.minutes,
                        'seconds': state.seconds
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                  ),
                  child: const Text('Start',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }


  Widget buildTimePicker(
      List<int> items, int selectedIndex, Function(int) onSelectedItemChanged) {
    return SizedBox(
      height: 200,
      width: 90,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 70,
        onSelectedItemChanged: (index) {
          onSelectedItemChanged(index);
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            if (index < 0 || index >= items.length) return null;

            Color textColor;
            if (index == selectedIndex) {
              textColor = Colors.purple;
            } else if (index == selectedIndex - 1 ||
                index == selectedIndex + 1) {
              textColor = Colors.purple.shade100;
            } else {
              textColor = Colors.purple.shade100;
            }

            return Center(
              child: Text(
                items[index].toString().padLeft(2, '0'),
                style: TextStyle(fontSize: 60, color: textColor),
              ),
            );
          },
          childCount: items.length,
        ),
      ),
    );
  }

}