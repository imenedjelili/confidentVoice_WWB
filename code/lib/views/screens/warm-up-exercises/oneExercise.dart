import 'package:flutter/material.dart';

class OneExercise extends StatefulWidget {
  final List<String> exerciseSteps;

  const OneExercise({super.key, required this.exerciseSteps});

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.exerciseSteps[currentStep],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (isStepCompleted)
              const Icon(Icons.check_circle, color: Colors.green, size: 40),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: previousStep,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text("Previous"),
                ),
                ElevatedButton(
                  onPressed: toggleCompletion,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text(isStepCompleted ? "Undo" : "Complete"),
                ),
                ElevatedButton(
                  onPressed: nextStep,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                  child: const Text("Next"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
