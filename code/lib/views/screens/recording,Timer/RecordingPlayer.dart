import 'package:confident_voice/Controllers/playback_bloc.dart';
import 'package:confident_voice/models/Events/playback_event.dart';
import 'package:confident_voice/models/States/playback_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class RecordingPlayerPage extends StatelessWidget {
  static const String recording = '/RecordingPlayer';

  const RecordingPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final audioPath = args?['audioPath'] ?? '';

    return BlocProvider(
      create: (_) => PlaybackBloc()..add(LoadAudioEvent(audioPath)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Recording 1',
            style: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
              fontSize: 27,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocBuilder<PlaybackBloc, PlaybackState>(
          builder: (context, state) {
            if (state is PlaybackLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PlaybackReady) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(alignment: Alignment.center, children: [
                    Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.purple[400] ?? Colors.purple,
                          width: 10.0,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Center(
                      child: CircleAvatar(
                          radius: 115,
                          backgroundImage:
                              AssetImage('assets/images/logo.png')),
                    ),
                  ]),
                  const SizedBox(height: 20),
                  Slider(
                    activeColor: Colors.amber,
                    inactiveColor: Colors.grey,
                    min: 0,
                    max: state.duration.inSeconds.toDouble(),
                    value: state.position.inSeconds.toDouble(),
                    onChanged: (value) {
                      context.read<PlaybackBloc>().add(
                          SeekAudioEvent(Duration(seconds: value.toInt())));
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${state.position.inMinutes}:${(state.position.inSeconds.remainder(60)).toString().padLeft(2, '0')}',
                        style:
                            const TextStyle(color: Colors.purple, fontSize: 15),
                      ),
                      Text(
                        '${state.duration.inMinutes}:${(state.duration.inSeconds.remainder(60)).toString().padLeft(2, '0')}',
                        style:
                            const TextStyle(color: Colors.purple, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        iconSize: 40,
                        icon:
                            const Icon(Icons.fast_rewind, color: Colors.purple),
                        onPressed: () {
                          context.read<PlaybackBloc>().add(SeekAudioEvent(
                              state.position - const Duration(seconds: 5)));
                        },
                      ),
                      IconButton(
                        iconSize: 40,
                        icon: Icon(
                          state.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.purple,
                        ),
                        onPressed: () {
                          context
                              .read<PlaybackBloc>()
                              .add(PlayPauseAudioEvent());
                        },
                      ),
                      IconButton(
                        iconSize: 40,
                        icon: const Icon(Icons.fast_forward,
                            color: Colors.purple),
                        onPressed: () {
                          context.read<PlaybackBloc>().add(SeekAudioEvent(
                              state.position + const Duration(seconds: 5)));
                        },
                      ),
                      IconButton(
                        iconSize: 40,
                        icon: const Icon(Icons.share, color: Colors.purple),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              );
            } else if (state is PlaybackError) {
              return Center(child: Text(state.message));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
}
}
