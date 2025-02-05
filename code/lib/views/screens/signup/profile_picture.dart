import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:confident_voice/views/screens/homepage.dart';

class ProfilePicture extends StatelessWidget {
  final String email;
  final String gender;

  const ProfilePicture({
    super.key, 
    required this.email, 
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    return _ProfilePictureView(email: email, gender: gender);
  }
}

class _ProfilePictureView extends StatefulWidget {
  final String email;
  final String gender;

  const _ProfilePictureView({
    required this.email,
    required this.gender,
  });

  @override
  _ProfilePictureViewState createState() => _ProfilePictureViewState();
}

class _ProfilePictureViewState extends State<_ProfilePictureView> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  // Function to pick an image from camera or gallery
  Future<void> _getImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      setState(() {
        _image = imageFile;
      });

      // Upload image to Firebase Storage
      await _uploadImage(imageFile);
    }
  }

  // Function to upload image to Firebase Storage
  Future<void> _uploadImage(File imageFile) async {
    try {
      setState(() => _isUploading = true);

      String userId = FirebaseAuth.instance.currentUser!.uid;
      String fileName = 'profile_pictures/$userId.jpg';

      Reference ref = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Save image URL in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'profilePicture': downloadUrl,
      });

      print("Profile Picture uploaded: $downloadUrl");
    } catch (e) {
      print("Error uploading image: $e");
    } finally {
      setState(() => _isUploading = false);
    }
  }

  // Show a dialog to choose image source (camera or gallery)
  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _getImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _getImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to continue to the next step
  void _continueToNextStep() async {
    if (_image != null) {
      await _uploadImage(_image!);
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Image.asset(
                    'assets/images/illustrationSign.png',
                    height: 200,
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
                Text(
                  "Gender: ${widget.gender}",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 40),
                const Text(
                  "Add a profile picture",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                          image: _image != null
                              ? DecorationImage(
                                  image: FileImage(_image!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _image == null
                            ? const Icon(
                                Icons.add_a_photo,
                                size: 50,
                                color: Colors.grey,
                              )
                            : null,
                      ),
                      if (_isUploading)
                        const CircularProgressIndicator(), // Show loader while uploading
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "This step is optional",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: _continueToNextStep,
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _continueToNextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
