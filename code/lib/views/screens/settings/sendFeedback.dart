import 'package:flutter/material.dart';
import 'package:confident_voice/widgets/styled_snackbar.dart';

class SendFeedbackScreen extends StatelessWidget {
  const SendFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send Feedback"),
      ),
      body: const FeedbackContent(),
    );
  }
}

class FeedbackContent extends StatefulWidget {
  const FeedbackContent({super.key});

  @override
  _FeedbackContentState createState() => _FeedbackContentState();
}

class _FeedbackContentState extends State<FeedbackContent> {
  final TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "We value your feedback. Please let us know your thoughts:",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _feedbackController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: "Write your feedback here...",
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 5,
            ),
            onPressed: () {
              if (_feedbackController.text.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  StyledSnackBar.show(
                    message: 'Thank you for your feedback!',
                  ),
                );
                _feedbackController.clear();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  StyledSnackBar.show(
                    message: 'Please enter your feedback',
                    isError: true,
                  ),
                );
              }
            },
            child: const Text(
              "Submit Feedback",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
