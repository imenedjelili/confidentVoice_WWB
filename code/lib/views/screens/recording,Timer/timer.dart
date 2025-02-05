import 'package:confident_voice/Controllers/timer_bloc.dart';
import 'package:confident_voice/models/Events/timer_event.dart';
import 'package:confident_voice/models/States/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class TimerPage extends StatelessWidget {
  static const String pageRoute = '/Timer';

  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, int>;
    final hour = args['hours']!;
    final minute = args['minutes']!;
    final second = args['seconds']!;
    final initialDuration =
        Duration(hours: hour, minutes: minute, seconds: second);

    return BlocProvider(
      create: (_) => TimerBloc(initialDuration),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Timer',
            style: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<TimerBloc, TimerState>(
          builder: (context, state) {
            String timerText =
                '${state.duration.inHours.toString().padLeft(2, '0')}:${(state.duration.inMinutes % 60).toString().padLeft(2, '0')}:${(state.duration.inSeconds % 60).toString().padLeft(2, '0')}';
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 120),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const SizedBox(height: 60),
                    SizedBox(
                      width: 220,
                      height: 220,
                      child: CircularProgressIndicator(
                        value: 10,
                        backgroundColor: Colors.transparent,
                        strokeWidth: 10,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.purple[100] ?? Colors.purple),
                      ),
                    ),
                    SizedBox(
                      width: 220,
                      height: 220,
                      child: CircularProgressIndicator(
                        value: state.duration.inSeconds /
                            (hour * 60 * 60 + minute * 60 + second),
                        backgroundColor: Colors.transparent,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.purple),
                        strokeWidth: 10,
                      ),
                    ),
                    Text(
                      timerText,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                          ),
                          onPressed: () {
                            context.read<TimerBloc>().add(CancelTimerEvent());
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.close, color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 90),
                    Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                          ),
                          onPressed: () {
                            if (state is TimerRunningState) {
                              context.read<TimerBloc>().add(PauseTimerEvent());
                            } else {
                              context.read<TimerBloc>().add(StartTimerEvent());
                            }
                          },
                          child: Icon(
                            state is TimerRunningState
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          state is TimerRunningState ? 'Pause' : 'Resume',
                          style: const TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
