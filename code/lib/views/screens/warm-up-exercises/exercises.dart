import 'package:flutter/material.dart';
import 'oneExercise.dart';

class Exercises extends StatelessWidget {
  const Exercises({super.key});

  final List<Map<String, dynamic>> exercises = const [
    {
      'title': 'Deep Breathing',
      'duration': '5 minutes',
      'progress': 0.7,
      'imagePath': 'assets/images/exo1.png',
      'steps': [
        'Step 1: Inhale deeply through your nose for 4 seconds.',
        'Step 2: Hold your breath for 7 seconds.',
        'Step 3: Exhale slowly through your mouth for 8 seconds.',
        'Step 4: Repeat the process for 5 minutes.'
      ],
    },
    {
      'title': 'Resonance Tone-Ups',
      'duration': '5 minutes',
      'progress': 0.5,
      'imagePath': 'assets/images/exo2.png',
      'steps': [
        'Step 1: Hum gently while keeping your lips closed.',
        'Step 2: Feel vibrations in your chest and nose.',
        'Step 3: Increase pitch gradually and return to normal.',
        'Step 4: Repeat for 5 minutes.'
      ],
    },
    {
      'title': 'Facial Warm-ups',
      'duration': '5 minutes',
      'progress': 0.3,
      'imagePath': 'assets/images/exo3.png',
      'steps': [
        'Step 1: Stretch your mouth wide and hold for 5 seconds.',
        'Step 2: Puff your cheeks and release air slowly.',
        'Step 3: Massage your jaw in circular motions.',
        'Step 4: Repeat for 5 minutes.'
      ],
    },
    {
      'title': 'Vocal Exercises',
      'duration': '7 minutes',
      'progress': 0.8,
      'imagePath': 'assets/images/exo1.png',
      'steps': [
        'Step 1: Say "ma-me-mi-mo-mu" slowly and clearly.',
        'Step 2: Increase speed while maintaining clarity.',
        'Step 3: Change pitch gradually from low to high.',
        'Step 4: Repeat for 7 minutes.'
      ],
    },
    {
      'title': 'Breathing with Rhythm',
      'duration': '6 minutes',
      'progress': 0.6,
      'imagePath': 'assets/images/exo2.png',
      'steps': [
        'Step 1: Breathe in for 4 seconds.',
        'Step 2: Hold breath for 4 seconds.',
        'Step 3: Breathe out for 4 seconds.',
        'Step 4: Maintain rhythm for 6 minutes.'
      ],
    },
    {
      'title': 'Relaxation Techniques',
      'duration': '10 minutes',
      'progress': 0.4,
      'imagePath': 'assets/images/exo3.png',
      'steps': [
        'Step 1: Find a quiet place and sit comfortably.',
        'Step 2: Close your eyes and take deep breaths.',
        'Step 3: Focus on relaxing each part of your body.',
        'Step 4: Continue for 10 minutes.'
      ],
    },
    {
      'title': 'Mindfulness Meditation',
      'duration': '15 minutes',
      'progress': 0.9,
      'imagePath': 'assets/images/exo1.png',
      'steps': [
        'Step 1: Sit in a comfortable position.',
        'Step 2: Focus on your breath.',
        'Step 3: Observe your thoughts without judgment.',
        'Step 4: Continue for 15 minutes.'
      ],
    },
  ];

  void _navigateToExercise(
      BuildContext context, Map<String, dynamic> exercise) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OneExercise(
          exerciseSteps: List<String>.from(exercise['steps']),
          imagePath: exercise['imagePath'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF412963),
      appBar: AppBar(
        backgroundColor: const Color(0xFF412963),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Warm up",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: Image.asset(
                'assets/images/logo2.png',
                height: 61,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  return ExerciseCard(
                    title: exercise['title'],
                    duration: exercise['duration'],
                    progress: exercise['progress'],
                    imagePath: exercise['imagePath'],
                    onTap: () => _navigateToExercise(context, exercise),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final String title;
  final String duration;
  final double progress;
  final String imagePath;
  final VoidCallback onTap;

  const ExerciseCard({
    super.key,
    required this.title,
    required this.duration,
    required this.progress,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: const Color(0xFF7F53A5),
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: Image.asset(imagePath, width: 60, height: 60),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                duration,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                color: const Color(0xFF5E2875),
              ),
            ],
          ),
          trailing: const Icon(
            Icons.arrow_forward,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
