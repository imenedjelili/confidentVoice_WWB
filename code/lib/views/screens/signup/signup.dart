import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:confident_voice/views/screens/login/login.dart';
import 'name.dart';
import 'GoogleSignInPage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  bool isLoading = false;

  bool _passwordHasLowerCase = false;
  bool _passwordHasUpperCase = false;
  bool _passwordLengthValid = false;
  bool _passwordStarted = false;

  void createUserWithEmailAndPassword() async {
    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      print(userCredential);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Name(email: _emailController.text.trim()),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _emailError = e.code == 'email-already-in-use'
            ? "Email already in use."
            : e.code == 'invalid-email'
                ? "Invalid email."
                : null;
        _passwordError =
            e.code == 'weak-password' ? "Password is too weak." : null;
      });
    }
  }

  void _validateFields() {
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    setState(() {
      _emailError = email.isEmpty
          ? "Email is required"
          : !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)
              ? "Enter a valid email"
              : null;
      _passwordError = password.isEmpty
          ? "Password is required"
          : password.length < 8
              ? "Password must be at least 8 characters"
              : null;
      _confirmPasswordError =
          confirmPassword != password ? "Passwords do not match" : null;

      // Password criteria validation
      _passwordHasLowerCase = RegExp(r'[a-z]').hasMatch(password);
      _passwordHasUpperCase = RegExp(r'[A-Z]').hasMatch(password);
      _passwordLengthValid = password.length >= 8;
    });

    if (_emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null) {
      setState(() => isLoading = true);
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => isLoading = false);
        createUserWithEmailAndPassword();
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/illustrationSign.png',
                height: 150,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              const Text(
                "Create Account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _emailController,
                hintText: "Email",
                errorText: _emailError,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _passwordController,
                hintText: "Password",
                errorText: _passwordError,
                isPassword: true,
                onChanged: (value) {
                  setState(() {
                    _passwordStarted = value.isNotEmpty;
                    // Update password criteria on every change
                    _passwordHasLowerCase = RegExp(r'[a-z]').hasMatch(value);
                    _passwordHasUpperCase = RegExp(r'[A-Z]').hasMatch(value);
                    _passwordLengthValid = value.length >= 8;
                  });
                },
              ),
              const SizedBox(height: 15),
              if (_passwordStarted) _buildPasswordCriteria(),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _confirmPasswordController,
                hintText: "Confirm Password",
                errorText: _confirmPasswordError,
                isPassword: true,
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: _validateFields,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF412963),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Continue",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
              const SizedBox(height: 15),
              const Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("OR", style: TextStyle(color: Colors.grey)),
                  ),
                  Expanded(child: Divider(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 15),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GoogleSignInPage()),
                  );
                },
                icon: Image.asset('assets/images/googleIcon.png',
                    width: 24, height: 24),
                label: const Text("Sign up with Google",
                    style: TextStyle(color: Colors.black)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    text: "Have an account? ",
                    style: TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: "Log in",
                        style: TextStyle(
                          color: Color(0xFF412963),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String? errorText,
    bool isPassword = false,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade200,
        hintText: hintText,
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildPasswordCriteria() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPasswordCondition(
          "Lowercase letter",
          _passwordHasLowerCase,
        ),
        _buildPasswordCondition(
          "Uppercase letter",
          _passwordHasUpperCase,
        ),
        _buildPasswordCondition(
          "At least 8 characters",
          _passwordLengthValid,
        ),
      ],
    );
  }

  Widget _buildPasswordCondition(String condition, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check : Icons.close,
          color: isValid ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 8),
        Text(
          condition,
          style: TextStyle(
            color: isValid ? Colors.green : Colors.red,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
