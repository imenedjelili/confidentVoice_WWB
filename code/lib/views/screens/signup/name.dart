import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'birthday.dart';
import 'package:confident_voice/views/screens/login/login.dart';

class Name extends StatelessWidget {
  const Name({super.key, required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    return _NameView(email: email);
  }
}

class _NameView extends StatefulWidget {
  const _NameView({required this.email});
  final String email;

  @override
  _NameViewState createState() => _NameViewState();
}

class _NameViewState extends State<_NameView> {
  final TextEditingController _nameController = TextEditingController();
  String _errorMessage = '';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // Function to save name to Firestore
  Future<void> _saveNameToFirestore(String name) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Add the user's full name to Firestore under their email
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': widget.email,
          'name': name,
          'created_at': Timestamp.now(),
        }, SetOptions(merge: true)); // Merge to avoid overwriting existing data
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to save name: $e';
      });
    }
  }

  void _validateAndContinue() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _errorMessage = 'Name cannot be empty';
      });
    } else {
      // Save the name to Firestore
      _saveNameToFirestore(name).then((_) {
        // After saving, navigate to the Birthday page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Birthday(
              email: widget.email,
              fullName: name,
            ),
          ),
        );
      });
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
                SizedBox(
                  width: 297,
                  height: 53,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      5,
                      (index) => Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 30,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: index == 0
                                      ? const Color(0xFF412963)
                                      : Colors.grey.shade300,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              if (index == 0)
                                const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20,
                                ),
                            ],
                          ),
                          if (index < 4)
                            Container(
                              width: 36,
                              height: 8,
                              color: index == 0
                                  ? const Color(0xFF412963)
                                  : Colors.grey.shade300,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Your Full Name",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: "Enter your full name",
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          errorText:
                              _errorMessage.isNotEmpty ? _errorMessage : null,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: ElevatedButton(
                    onPressed: _validateAndContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF412963),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Continue",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Sign up with Google",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Image.asset(
                      'assets/images/googleIcon.png',
                      width: 24,
                      height: 24,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 100.0),
                  child: const Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Have an account? ",
                      style: TextStyle(color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                        );
                      },
                      child: const Text(
                        "Log in",
                        style: TextStyle(
                          color: Color(0xFF412963),
                          fontWeight: FontWeight.bold,
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
