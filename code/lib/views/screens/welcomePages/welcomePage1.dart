import 'package:flutter/material.dart';
import 'welcomePage2.dart';
import '../login/login.dart';

class WelcomePage1Widget extends StatefulWidget {
  const WelcomePage1Widget({super.key});
  static const String pageRoute = '/page1Screen';
  @override
  State<WelcomePage1Widget> createState() => WelcomePage1WidgetState();
}

class WelcomePage1WidgetState extends State<WelcomePage1Widget> {
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
              Image.asset(
                  'assets/images/page1.png',
                  ), 
              const SizedBox(height: 20),
              const Text(
                'Own the stage,\ninspire the audience',
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
                  Icon(Icons.circle_rounded,
                  size: 22,
                  color: Color.fromARGB(255, 252, 170, 18),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.circle_rounded,
                  size: 17,
                  color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.circle_rounded,
                  size: 17,
                  color: Colors.white,
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
                          builder: (context) =>  const WelcomePage2Widget(),
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
                    child: const Text('Next',
                    style: TextStyle(
                      color: Colors.white,
                    ),),
                  ),
              ],)
            ],
          ),
        ),
    );
  }
}