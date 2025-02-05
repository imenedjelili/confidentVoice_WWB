import 'package:flutter/material.dart';
import 'scripts.dart';

class NewScript extends StatefulWidget {
  NewScript({super.key});

  @override
  _NewScriptState createState() => _NewScriptState();
}

class _NewScriptState extends State<NewScript> {
  final TextEditingController topicController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? errorMessage;

  void _validateAndSubmit() {
    setState(() {
      if (topicController.text.isEmpty || descriptionController.text.isEmpty) {
        errorMessage = 'Please fill in both topic and description';
      } else {
        errorMessage = null;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scripts(
              newScript: descriptionController.text,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 10,
                      width: 150,
                      color: const Color(0xFFCB96C2),
                    ),
                    const Text(
                      "Let's Do it :",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: topicController,
                decoration: InputDecoration(
                  hintText: "Topic...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  errorText: errorMessage,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Description...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.chat_bubble_outline,
                              color: Colors.orangeAccent),
                          SizedBox(width: 8),
                          Text(
                            "Get help from AI",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Image.asset(
                        'assets/images/iaHelp.png',
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  FloatingActionButton(
                    onPressed: _validateAndSubmit,
                    backgroundColor: const Color(0xFF412963),
                    elevation: 6,
                    shape: const CircleBorder(),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
