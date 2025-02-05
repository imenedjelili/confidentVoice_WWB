import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help Center"),
      ),
      body: const HelpCenterContent(),
    );
  }
}

class HelpCenterContent extends StatefulWidget {
  const HelpCenterContent({super.key});

  @override
  _HelpCenterContentState createState() => _HelpCenterContentState();
}

class _HelpCenterContentState extends State<HelpCenterContent> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _helpTopics = [
    "Account Management",
    "Password Reset",
    "Privacy Policy",
    "Payment Issues",
    "How to Delete Account",
    "Technical Support",
    "Feedback and Suggestions",
  ];
  List<String> _filteredTopics = [];

  @override
  void initState() {
    super.initState();
    _filteredTopics = _helpTopics;
    _searchController.addListener(_filterTopics);
  }

  void _filterTopics() {
    setState(() {
      _filteredTopics = _helpTopics
          .where((topic) => topic
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        const SizedBox(height: 10),
        Expanded(
          child: _buildHelpTopicsList(),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search topics...",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildHelpTopicsList() {
    return ListView.builder(
      itemCount: _filteredTopics.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: ListTile(
            leading: const Icon(Icons.help_outline),
            title: Text(_filteredTopics[index]),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("You selected: ${_filteredTopics[index]}"),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
