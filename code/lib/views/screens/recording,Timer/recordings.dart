import 'package:confident_voice/Controllers/recordings_bloc.dart';
import 'package:confident_voice/models/Events/recordings_event.dart';
import 'package:confident_voice/models/States/recordings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecordingsPage extends StatelessWidget {
  static const String recording = '/Recording';
  const RecordingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RecordingsBloc()..add(FetchRecordingsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Recordings',
            style: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
              fontSize: 27,

            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: BlocBuilder<RecordingsBloc, RecordingsState>(
          builder: (context, state) {
            if (state is RecordingsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RecordingsLoaded) {
              final recordings = state.recordings;

              return recordings.isEmpty
                  ? const Center(child: Text('No recordings found'))
                  : ListView.builder(
                      itemCount: recordings.length,
                      itemBuilder: (context, index) {
                        final recording = recordings[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: ListTile(
                            leading: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(12),
                                backgroundColor: Colors.purple,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/RecordingPlayer',
                                  arguments: {
                                    'audioPath': recording.recordingPath,
                                  },
                                );
                              },
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              recording.createdAt.substring(0, 10),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.purple),
                              onPressed: () {
                                context
                                    .read<RecordingsBloc>()
                                    .add(RemoveRecordingEvent(index));
                              },
                            ),
                          ),
                        );
                      },
                    );
            } else if (state is RecordingsError) {
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
