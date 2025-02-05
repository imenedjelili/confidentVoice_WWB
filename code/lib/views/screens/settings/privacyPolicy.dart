import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
      ),
      body: const PrivacyPolicyContent(),
    );
  }
}

class PrivacyPolicyContent extends StatelessWidget {
  const PrivacyPolicyContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Privacy Policy",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text(
            "Your privacy is important to us. This document outlines how we collect, use, and protect your data while using our services. We respect your right to privacy and are committed to transparency.",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 12),
          Text(
            "Data Collection:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "We may collect data such as your device information, usage statistics, and location to improve app performance and provide personalized services.",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 12),
          Text(
            "Data Usage:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "The information collected is used solely for app functionality, user support, and app improvements. We do not share personal information with third parties.",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 12),
          Text(
            "Contact Us:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "For any inquiries related to privacy concerns, contact us at: confidentvoice@gmail.com",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
