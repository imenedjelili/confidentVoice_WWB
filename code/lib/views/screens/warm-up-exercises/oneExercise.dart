import 'package:flutter/material.dart';

class OneExercise extends StatefulWidget {
  final List<String> exerciseSteps;
  final String imagePath; // Path to the image asset

  const OneExercise({
    super.key,
    required this.exerciseSteps,
    required this.imagePath,
  });

  @override
  _OneExerciseState createState() => _OneExerciseState();
}

class _OneExerciseState extends State<OneExercise> {
  int currentStep = 0;
  bool isStepCompleted = false;

  void nextStep() {
    if (currentStep < widget.exerciseSteps.length - 1) {
      setState(() {
        currentStep++;
        isStepCompleted = false;
      });
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
        isStepCompleted = false;
      });
    }
  }

  void toggleCompletion() {
    setState(() {
      isStepCompleted = !isStepCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("One Exercise"),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Display the exercise image with rounded corners and shadow
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    widget.imagePath,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Display the current exercise step inside a Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        widget.exerciseSteps[currentStep],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      if (isStepCompleted)
                        const Icon(Icons.check_circle,
                            color: Colors.green, size: 40),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Navigation buttons for previous, complete/undo, and next steps
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: previousStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    child: const Text("Previous"),
                  ),
                  ElevatedButton(
                    onPressed: toggleCompletion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    child: Text(isStepCompleted ? "Undo" : "Complete"),
                  ),
                  ElevatedButton(
                    onPressed: nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    child: const Text("Next"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
