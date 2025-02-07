import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:confident_voice/Controllers/theme_bloc.dart';

/// --- Profile State ---
/// Updated so that the initial state is “empty” (and loading) rather than
/// showing static “John Doe” data.
class ProfileState {
  final String name;
  final String email;
  final bool isLoading;
  final String? phone;
  final String? bio;
  final String profileImage;

  ProfileState({
    required this.name,
    required this.email,
    required this.isLoading,
    this.phone,
    this.bio,
    this.profileImage = "assets/images/profile.png",
  });

  /// The initial state is now “empty” and shows a loading indicator.
  factory ProfileState.initial() {
    return ProfileState(
      name: '',
      email: '',
      isLoading: true,
      phone: '',
      bio: '',
      profileImage: "assets/images/profile.png",
    );
  }

  ProfileState copyWith({
    String? name,
    String? email,
    bool? isLoading,
    String? phone,
    String? bio,
    String? profileImage,
  }) {
    return ProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}

/// --- Personal Information Widget ---
class PersonalInformation extends StatefulWidget {
  const PersonalInformation({Key? key}) : super(key: key);

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;

  // Local profile state
  late ProfileState _profile;

  @override
  void initState() {
    super.initState();
    _profile = ProfileState.initial();

    // Initialize the controllers with empty values.
    _nameController = TextEditingController(text: _profile.name);
    _emailController = TextEditingController(text: _profile.email);
    _phoneController = TextEditingController(text: _profile.phone ?? '');
    _bioController = TextEditingController(text: _profile.bio ?? '');

    // Fetch the user data from Firestore.
    _fetchUserData();
  }

  /// Fetches the current user’s data from Firestore and updates the controllers.
  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Assume your user documents are stored in a "users" collection.
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        setState(() {
          _profile = ProfileState(
            name: data['name'] ?? '',
            email: data['email'] ?? '',
            isLoading: false,
            phone: data['phone'] ?? '',
            bio: data['bio'] ?? '',
            profileImage: data['profileImage'] ?? "assets/images/profile.png",
          );
          _nameController.text = _profile.name;
          _emailController.text = _profile.email;
          _phoneController.text = _profile.phone ?? '';
          _bioController.text = _profile.bio ?? '';
        });
      } else {
        // If no document exists for the user, stop the loading state.
        setState(() {
          _profile = _profile.copyWith(isLoading: false);
        });
      }
    } else {
      // If there is no authenticated user, stop loading.
      setState(() {
        _profile = _profile.copyWith(isLoading: false);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keeping the ThemeBloc for theme management.
    final isDarkMode = context.watch<ThemeBloc>().state.isDark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text('Personal Information'),
      ),
      body: _profile.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              icon: Icon(Icons.person),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              icon: Icon(Icons.email),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              labelText: 'Phone',
                              icon: Icon(Icons.phone),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _bioController,
                            decoration: const InputDecoration(
                              labelText: 'Bio',
                              icon: Icon(Icons.description),
                            ),
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      // Update the local profile state with the new values.
                      setState(() {
                        _profile = _profile.copyWith(
                          name: _nameController.text,
                          email: _emailController.text,
                          phone: _phoneController.text,
                          bio: _bioController.text,
                        );
                      });
                      // Update the Firestore document.
                      User? user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .update({
                          'name': _profile.name,
                          'email': _profile.email,
                          'phone': _profile.phone,
                          'bio': _profile.bio,
                          'profileImage': _profile.profileImage,
                        });
                      }
                      // Optionally, navigate back with the updated profile.
                      Navigator.pop(context, _profile);
                    },
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            ),
    );
  }
}
