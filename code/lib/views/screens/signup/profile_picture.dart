import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confident_voice/databases/db_confidentVoice.dart';
import 'package:confident_voice/databases/dbhelper.dart';
import 'package:confident_voice/views/screens/homepage.dart';
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

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.email)
          .get();

      if (userDoc.exists) {
        setState(() {
          _name = userDoc['fullName'] ?? 'No Name';
          _birthday = userDoc['dateOfBirth'] ?? 'No Birthday';
          _gender = userDoc['gender'] ?? 'No Gender';
        });
      } else {
        _showSnackBar("User data not found in Firestore");
      }
    } catch (e) {
      _showSnackBar("Error fetching user data: $e");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profilePicture = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfilePicture({bool skipImage = false}) async {
    if (!skipImage && _profilePicture == null) {
      _showSnackBar("Please select a profile picture or skip this step");
      return;
    }

    if (_name == null || _birthday == null || _gender == null) {
      _showSnackBar("User data is incomplete");
      return;
    }

    try {
      String imageUrl = skipImage 
          ? 'assets/images/image_placeholder.png'  // Default image when skipped
          : _profilePicture!.path;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.email)
          .update({'profile_picture': imageUrl});

      bool tableExists = await DBHelper.doesTableExist('User');
      if (!tableExists) {
        _showSnackBar("User table does not exist in the database");
        return;
      }

      await UserDB.insertUser({
        'username': _name!,
        'email': widget.email,
        'password': '',
        'birthday': _birthday!,
        'image': imageUrl,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            userName: _name!,
            profilePictureUrl: imageUrl,
          ),
        ),
      );
    } catch (e) {
      _showSnackBar("Error saving profile picture: $e");
    }
  }

  void _skipToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(
          userName: _name ?? 'Guest User',
          profilePictureUrl: 'assets/images/image_placeholder.png',
        ),
      ),
    );
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => _saveProfilePicture(skipImage: false),
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
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: _skipToHome,
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
            ],
          ),
        ),
      ),
    );
  }
}
