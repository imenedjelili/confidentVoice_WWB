import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'birthday.dart'; // Import your Birthday page

class GoogleSignInPage extends StatefulWidget {
  const GoogleSignInPage({super.key});

  @override
  _GoogleSignInPageState createState() => _GoogleSignInPageState();
}

class _GoogleSignInPageState extends State<GoogleSignInPage> {
  bool isSigningIn = false;

  Future<void> signInWithGoogle() async {
    setState(() => isSigningIn = true);

    try {
      // Step 0: Clear any cached account to force account selection
      await GoogleSignIn().signOut();

      // Step 1: Trigger Google Sign-In
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        print("Google Sign-In canceled");
        setState(() => isSigningIn = false);
        return;
      }

      // Step 2: Get Google Authentication Credentials
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Step 3: Sign in to Firebase with Google Credentials
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        print("Signed in as: ${user.email}");

        // Step 4: Fetch or Create User in Firestore
        final DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (!userDoc.exists) {
          // Step 5: Save User Details in Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'uid': user.uid,
            'name': user.displayName ?? '', // Use Google account name
            'email': user.email, // Use Google account email
            'profile_picture': user.photoURL ?? '', // Use Google account photo
            'created_at': FieldValue.serverTimestamp(),
          });
          print("User added to Firestore");
        }

        // Step 6: Navigate to Birthday Page
        print("Navigating to Birthday page...");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Birthday(
              fullName: user.displayName ?? '',
              email: user.email ?? '',
            ),
          ),
        );
      }
    } catch (e) {
      print("Error signing in with Google: $e");
      setState(() => isSigningIn = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF412963),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('assets/images/logo.png'),
                  height: 150, // Adjust height for your app's logo
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 40),
                const Text(
                  "Welcome to Confident Voice",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Sign in to continue and unlock powerful public speaking tools.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 30),
                if (isSigningIn)
                  const CircularProgressIndicator()
                else
                  ElevatedButton.icon(
                    onPressed: signInWithGoogle,
                    icon: const Icon(
                      Icons.account_circle,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Sign in with Google",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDB4437), // Google Red
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                const SizedBox(height: 20),
                const Text(
                  "By signing in, you agree to our Terms of Service and Privacy Policy.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
