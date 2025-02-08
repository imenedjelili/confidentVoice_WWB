import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confident_voice/views/screens/homepage.dart';
import 'package:confident_voice/widgets/styled_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicture extends StatefulWidget {
  final String email;

  const ProfilePicture({super.key, required this.email});

  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  File? _profilePicture;
  final ImagePicker _picker = ImagePicker();
  String? _name, _birthday, _gender;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch the user data from Firestore based on the email provided.
  Future<void> _fetchUserData() async {
    try {
      final QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.email)
          .get();

      if (userQuery.docs.isNotEmpty) {
        final userDoc = userQuery.docs.first;
        final data = userDoc.data() as Map<String, dynamic>?;

        if (data != null) {
          setState(() {
            // Check for both 'name' and 'fullName' fields.
            _name = data['name'] ?? data['fullName'] ?? 'No Name';
            _birthday = data['dateOfBirth'] ?? 'No Birthday';
            _gender = data['gender'] ?? 'No Gender';
          });
        } else {
          _showSnackBar("User document is empty or invalid");
        }
      } else {
        _showSnackBar("User data not found in Firestore");
      }
    } catch (e) {
      _showSnackBar("Error fetching user data: $e");
    }
  }

  // Utility method to show SnackBar messages.
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(StyledSnackBar.show(message: message, isError: !message.contains('successfully')));
  }

  // Pick an image from the gallery.
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profilePicture = File(pickedFile.path);
      });
    }
  }

  // Save the chosen profile picture to Firestore and navigate to HomePage.
  Future<void> _saveProfilePicture() async {
    if (_profilePicture == null) {
      _showSnackBar("Please select a profile picture");
      return;
    }

    if (_name == null || _birthday == null || _gender == null) {
      _showSnackBar("User data is incomplete");
      return;
    }

    try {
      String imageUrl = _profilePicture!.path;

      // Find the user document and update the profile picture.
      final QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.email)
          .get();

      if (userQuery.docs.isNotEmpty) {
        final userDoc = userQuery.docs.first;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userDoc.id)
            .update({'profile_picture': imageUrl});

        _showSnackBar("Profile picture updated successfully!");

        // Navigate to the HomePage, passing the user name and image URL.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              userName: _name!,
                profilePictureUrl: imageUrl, userEmail: widget.email,
            ),
          ),
        );
      } else {
        _showSnackBar("User not found in Firestore");
      }
    } catch (e) {
      _showSnackBar("Error saving profile picture: $e");
    }
  }

  // Skip selecting a profile picture. Use a default placeholder image and update Firestore.
  Future<void> _skipAndGoToHome() async {
    const String defaultImage = 'assets/images/image_placeholder.png';

    if (_name == null || _birthday == null || _gender == null) {
      _showSnackBar("User data is incomplete");
      return;
    }

    try {
      final QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.email)
          .get();

      if (userQuery.docs.isNotEmpty) {
        final userDoc = userQuery.docs.first;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userDoc.id)
            .update({'profile_picture': defaultImage});

        _showSnackBar("Profile picture updated successfully!");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              userName: _name!,
                profilePictureUrl: defaultImage, userEmail: widget.email,
            ),
          ),
        );
      } else {
        _showSnackBar("User not found in Firestore");
      }
    } catch (e) {
      _showSnackBar("Error skipping profile picture: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Illustration image at the top.
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Image.asset(
                  'assets/images/illustrationSign.png',
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
              const Text(
                "Create account",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              const Text(
                "Select your profile picture:",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 10),
              // The CircleAvatar shows the selected image or an add icon.
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: _profilePicture != null
                      ? FileImage(_profilePicture!)
                      : null,
                  child: _profilePicture == null
                      ? const Icon(Icons.add_a_photo,
                          color: Colors.white, size: 30)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              // Save button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: ElevatedButton(
                  onPressed: _saveProfilePicture,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF412963),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Save & Go to Home",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Skip button to allow the user to bypass this step.
              TextButton(
                onPressed: _skipAndGoToHome,
                child: const Text(
                  "Skip for now",
                  style: TextStyle(
                    color: Color(0xFF412963),
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
