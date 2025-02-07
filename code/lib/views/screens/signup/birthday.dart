import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:confident_voice/views/screens/login/login.dart';
import 'gender.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';

class Birthday extends StatefulWidget {
  final String fullName;
  final String email;

  const Birthday({super.key, required this.fullName, required this.email});

  @override
  _BirthdayState createState() => _BirthdayState();
}

class _BirthdayState extends State<Birthday> {
  String? selectedDate;
  bool isValid = false;
  String? error;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  void _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime minDate = DateTime(now.year - 100);
    final DateTime maxDate = DateTime(now.year - 16, now.month, now.day);

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: maxDate,
      firstDate: minDate,
      lastDate: maxDate,
      helpText: 'Select your birth date (Must be at least 16 years old)',
    );

    if (pickedDate != null) {
      _onDateSelected(pickedDate);
    }
  }

  void _onDateSelected(DateTime date) {
    if (!_isAtLeast16YearsOld(date)) {
      setState(() {
        selectedDate = DateFormat('dd/MM/yyyy').format(date);
        isValid = false;
        error = "You must be at least 16 years old to use this app";
      });
    } else {
      setState(() {
        selectedDate = DateFormat('dd/MM/yyyy').format(date);
        isValid = true;
        error = null;
      });
    }
  }

  bool _isAtLeast16YearsOld(DateTime birthDate) {
    final today = DateTime.now();
    final difference = today.difference(birthDate);
    final age = difference.inDays / 365.25;
    return age >= 16;
  }

  void _onContinuePressed() async {
    if (selectedDate == null || selectedDate!.isEmpty) {
      setState(() {
        error = "Date of Birth is required";
        isValid = false;
      });
    } else if (!isValid) {
      setState(() {
        error = "You must be at least 16 years old to use this app";
        isValid = false;
      });
    } else {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.email)
            .set({
          'fullName': widget.fullName,
          'email': widget.email,
          'dateOfBirth': selectedDate,
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Gender(email: widget.email),
          ),
        );
      } catch (e) {
        setState(() {
          error = "Error saving data. Please try again.";
        });
      }
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Text(
                  "Hello, ${widget.fullName}!",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/illustrationSign.png',
                  height: 160,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Create account",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Date of Birth:",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  controller: TextEditingController(text: selectedDate),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    hintText: "DD/MM/YYYY",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 14.0,
                    ),
                    errorText: error,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onContinuePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF412963),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  ),
                  child: const Text(
                    "Have an account? Log in",
                    style: TextStyle(
                        color: Color(0xFF412963), fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
