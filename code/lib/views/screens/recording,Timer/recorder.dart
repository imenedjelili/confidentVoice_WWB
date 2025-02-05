import 'dart:async';
import 'dart:io';
import 'package:confident_voice/Controllers/recorder_bloc.dart';
import 'package:confident_voice/models/Events/recorder_event.dart';
import 'package:confident_voice/models/States/recorder_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:record/record.dart';


 
class RecorderPage extends StatefulWidget {
  const RecorderPage({super.key});
  static const String recorder = '/Recorder';

  @override
  _RecorderPageState createState() => _RecorderPageState();
}

class _RecorderPageState extends State<RecorderPage> {
  final RecorderController waveformController = RecorderController();
  final record = AudioRecorder();
  String? audioPath;
  Timer? timer;

  Future<void> startRecording(BuildContext context) async {
    audioPath = '${Directory.systemTemp.path}/audio.m4a';

    var status = await Permission.microphone.request();
    if (status.isGranted) {
      waveformController.record();
      await record.start(const RecordConfig(), path: audioPath!);

      context.read<RecorderBloc>().add(StartRecordingEvent());

      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (context.read<RecorderBloc>().state is RecorderRecording) {
          final currentState =
              context.read<RecorderBloc>().state as RecorderRecording;
          context
              .read<RecorderBloc>()
              .add(UpdateDurationEvent(currentState.duration + 1));
        }
      });
    } else {
      print('Permission denied');
    }
  }

  Future<void> stopRecording(BuildContext context) async {
    await record.stop();
    await waveformController.stop();
    timer?.cancel();

    context.read<RecorderBloc>().add(StopRecordingEvent());

    if (audioPath != null) {
      print("Recording saved at $audioPath");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RecorderBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Recorder',
              style: TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
                fontSize: 27,
              ),
            ),
          ),
        ),
        body: Center(
          child: BlocBuilder<RecorderBloc,RecordersState>(
            builder: (context, state) {
              int duration = 0;
              if (state is RecorderRecording) {
                duration = state.duration;
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AudioWaveforms(
                    enableGesture: false,
                    size: const Size(double.infinity, 200),
                    recorderController: waveformController,
                    waveStyle: const WaveStyle(
                      waveThickness: 7,
                      spacing: 10,
                      showMiddleLine: false,
                      waveColor: Colors.purple,
                      extendWaveform: true,
                      extraClipperHeight: 20.0,
                      scaleFactor: 60,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${(duration ~/ 60).toString().padLeft(2, '0')}:${(duration % 60).toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 48, color: Colors.purple),
                  ),
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 32,
                    child: IconButton(
                      iconSize: 40,
                      icon: Icon(
                          state is RecorderRecording ? Icons.pause : Icons.mic),
                      color: Colors.purple,
                      onPressed: () {
                        if (state is RecorderRecording) {
                          stopRecording(context);
                        } else {
                          startRecording(context);
                        }
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        radius: 32,
                        child: IconButton(
                          iconSize: 40,
                          icon: const Icon(Icons.stop),
                          color: Colors.red,
                          onPressed: state is RecorderRecording
                              ? () => stopRecording(context)
                              : null,
                        ),
                      ),
                      CircleAvatar(
                        radius: 32,
                        child: IconButton(
                          iconSize: 40,
                          icon: const Icon(Icons.check),
                          color: Colors.green,
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/Recording',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
