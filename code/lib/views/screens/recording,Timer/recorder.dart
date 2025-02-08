import 'dart:async';
import 'dart:io';
import 'package:confident_voice/Controllers/recorder_bloc.dart';
import 'package:confident_voice/databases/db_confidentVoice.dart';
import 'package:confident_voice/models/Events/recorder_event.dart';
import 'package:confident_voice/models/States/recorder_state.dart';
import 'package:confident_voice/views/screens/recording,Timer/recordings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:record/record.dart';
import 'package:confident_voice/models/classes/RecordedData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:confident_voice/widgets/styled_snackbar.dart';

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
  int elapsedTime = 0;

  Future<void> startRecording(BuildContext context) async {
    await record.stop();
    await waveformController.stop();
    timer?.cancel();
    audioPath = '${Directory.systemTemp.path}/audio.m4a';

    var status = await Permission.microphone.request();
    if (status.isGranted) {
      waveformController.record();
      await record.start(const RecordConfig(), path: audioPath!);

      context.read<RecorderBloc>().add(StartRecordingEvent());

      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        elapsedTime++;
        if (context.read<RecorderBloc>().state is RecorderRecording) {
          context.read<RecorderBloc>().add(UpdateDurationEvent(elapsedTime));
        }
      });
    } else {
      print('Permission denied');
    }
  }

  void pauseTimer(BuildContext context) {
    timer?.cancel();
    context.read<RecorderBloc>().add(PauseRecordingEvent());
  }

  void resumeTimer(BuildContext context) {
    context.read<RecorderBloc>().add(ResumeRecordingEvent());
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsedTime++;
      context.read<RecorderBloc>().add(UpdateDurationEvent(elapsedTime));
    });
  }

  Future<void> stopRecording(BuildContext context) async {
    await record.stop();
    await waveformController.stop();
    timer?.cancel();

    context.read<RecorderBloc>().add(StopRecordingEvent());

    if (audioPath != null) {
      print("Recording saved at $audioPath");

      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final recording = RecordedData(
            userId: user.uid,
            recordingPath: audioPath!,
            createdAt: DateTime.now().toIso8601String(),
          );

          await RecordedDataDB.insertRecording(recording.toMap());
          print(recording.toMap());
          print("Recording path stored in the database.");
          ScaffoldMessenger.of(context).showSnackBar(
            StyledSnackBar.show(
              message: 'Recording saved successfully!',
            ),
          );
        } else {
          print("User not logged in. Cannot save recording.");
          ScaffoldMessenger.of(context).showSnackBar(
            StyledSnackBar.show(
              message: 'User not logged in. Please log in to save.',
            ),
          );
        }
      } catch (e) {
        print("Error storing recording path: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          StyledSnackBar.show(
            message: 'Error saving recording: $e',
            isError: true,
          ),
        );
      }
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
          child: BlocBuilder<RecorderBloc, RecordersState>(
            builder: (context, state) {
              int duration = elapsedTime;
              if (state is RecorderRecording) {
                duration = elapsedTime;
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
                        state is RecorderRecording ? Icons.pause : Icons.mic,
                      ),
                      color: Colors.purple,
                      onPressed: () {
                        if (state is RecorderRecording) {
                          pauseTimer(context);
                        } else if (state is RecorderPaused &&
                            elapsedTime != 0) {
                          resumeTimer(context);
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
                          onPressed: () {
                            stopRecording(context); // Call stopRecording here
                          },
                        ),
                      ),
                      CircleAvatar(
                        radius: 32,
                        child: IconButton(
                          iconSize: 40,
                          icon: const Icon(Icons.check),
                          color: Colors.green,
                          onPressed: () {
                            stopRecording(
                                context); // Call stopRecording before navigating
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RecordingsPage(),
                              ),
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
