import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceToTextScreen extends StatefulWidget {
  const VoiceToTextScreen({super.key});

  @override
  State<VoiceToTextScreen> createState() => _VoiceToTextScreenState();
}

class _VoiceToTextScreenState extends State<VoiceToTextScreen> {
  final SpeechToText _speechToText = SpeechToText();
  String _lastWords = '';
  bool _isListening = false;

  void _startListening() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speechToText.listen(
          onResult: (result) {
            setState(() {
              _lastWords = result.recognizedWords;
            });
          },
          listenFor: const Duration(seconds: 10000), // Maximum listen time
        );
      } else {
        // Handle error
        print("The user has denied the use of speech recognition.");
      }
    } else {
      setState(() => _isListening = false);
      _speechToText.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
              'Voice to Text',
              style: TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
                fontSize: 27,
              ),
            ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _lastWords,
              style: const TextStyle(fontSize: 17),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startListening,
              child: Text(_isListening ? 'Stop Listening' : 'Start Listening'),
            ),
          ],
        ),
      ),
    );
  }
}
