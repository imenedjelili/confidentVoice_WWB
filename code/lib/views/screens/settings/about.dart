import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
      ),
      body: const AboutContent(),
    );
  }
}

class AboutContent extends StatelessWidget {
  const AboutContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAppInfo(),
          const Divider(),
          _buildTeamSection(),
          const Divider(),
          _buildContactSection(),
          const Divider(),
          _buildAcknowledgments(),
        ],
      ),
    );
  }

  Widget _buildAppInfo() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Confident Voice",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          "Version 1.0.0",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        SizedBox(height: 12),
        Text(
          "Confident Voice is a mobile app designed to help users improve their public speaking skills. "
          "With features like a teleprompter, voice warm-up exercises, a timer, and speech analysis tools, "
          "this app aims to provide comprehensive support to both novice and experienced speakers.",
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildTeamSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Team Members",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          "- Djelili Imene Fatma\n"
          "- Hattabi Hadil\n"
          "- Ghorab Meriem",
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Contact Us",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          "For inquiries, feedback, or collaboration, please contact us:",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 8),
        Text(
          "Email: confidentvoice@gmail.com",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 4),
        Text(
          "Phone: will be provided later :)",
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildAcknowledgments() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Acknowledgments",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          "We would like to thank all the open-source contributors and tools that made this project possible. "
          "Special thanks to the Flutter community for their support and resources.",
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
