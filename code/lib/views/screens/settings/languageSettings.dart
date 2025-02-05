import 'package:flutter/material.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Language Settings"),
      ),
      body: const LanguageContent(),
    );
  }
}

class LanguageContent extends StatefulWidget {
  const LanguageContent({super.key});

  @override
  _LanguageContentState createState() => _LanguageContentState();
}

class _LanguageContentState extends State<LanguageContent> {
  String _currentLanguage = "English";
  final List<String> _languages = [
    "English",
    "French",
    "Spanish",
    "Arabic",
    "German",
    "Chinese",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        _buildLanguageDropdown(),
      ],
    );
  }

  Widget _buildLanguageDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButtonFormField<String>(
        value: _currentLanguage,
        items: _languages
            .map(
              (lang) => DropdownMenuItem(
                value: lang,
                child: Text(lang),
              ),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            _currentLanguage = value!;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Language changed to $_currentLanguage"),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        decoration: InputDecoration(
          labelText: "Select Language",
          prefixIcon: const Icon(Icons.language),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
