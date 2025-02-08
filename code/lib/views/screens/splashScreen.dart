import 'package:flutter/material.dart';
// Update this import based on your BottomNavigationWidget file
import 'package:confident_voice/views/screens/welcomePages/welcomePage1.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.repeat(reverse: true);

    Future.delayed(Duration.zero, () {
      setState(() {
        _opacity = 1.0;
      });
    });

    // Simulate loading resources or data
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WelcomePage1Widget(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF412963),
              Color(0xFF2C1C42),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _animation.value,
                    child: AnimatedOpacity(
                      opacity: _opacity,
                      duration: const Duration(seconds: 2),
                      child: Image.asset(
                        'assets/images/logoa.png',
                        height: 250,
                        width: 270,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(seconds: 2),
                child: const Column(
                  children: [
                    Text(
                      "ConfidentVoice",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Speak with Confidence",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(seconds: 2),
                child: Column(
                  children: [
                    // const SizedBox(
                    //   width: 40,
                    //   height: 40,
                    //   child: CircularProgressIndicator(
                    //     valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                    //     strokeWidth: 2,
                    //   ),
                    // ),
                    const SizedBox(height: 24),
                    Text(
                      "Version 1.0.0",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
