import 'package:flutter/material.dart';
import 'package:confident_voice/views/screens/login/login.dart';

class WelcomePage3Widget extends StatefulWidget {
  const WelcomePage3Widget({super.key});
  static const String pageRoute = '/page3Screen';
  @override
  State<WelcomePage3Widget> createState() => WelcomePage3WidgetState();
}

class WelcomePage3WidgetState extends State<WelcomePage3Widget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 162, 109, 197),
        actions: [
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                  (route) => false,
                );
              },
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 162, 109, 197),
      body: Container(
        margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 85,),
            Image.asset(
              'assets/images/page3.png',
            ),
            const SizedBox(height: 20),
            const Text(
              'Rise above,\nown your voice',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.circle_rounded,
                  size: 17,
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.circle_rounded,
                  size: 17,
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.circle_rounded,
                  size: 22,
                  color: Color.fromARGB(255, 252, 170, 18),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  const Login(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(0, 65, 41, 99),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text(
                    'Finish',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
