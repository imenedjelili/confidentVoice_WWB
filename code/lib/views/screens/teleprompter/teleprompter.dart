import 'package:flutter/material.dart';
import 'dart:async';

class Teleprompter extends StatefulWidget {
  final String text;

  const Teleprompter({super.key, required this.text});

  @override
  _TeleprompterState createState() => _TeleprompterState();
}

class _TeleprompterState extends State<Teleprompter> {
  final ScrollController _scrollController = ScrollController();
  Timer? _scrollTimer;
  bool _isScrolling = false;
  double _scrollSpeed = 20.0;

  void _startScrolling() {
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.offset + (_scrollSpeed / 10),
          duration: const Duration(milliseconds: 100),
          curve: Curves.linear,
        );
      }
    });
    setState(() {
      _isScrolling = true;
    });
  }

  void _stopScrolling() {
    _scrollTimer?.cancel();
    setState(() {
      _isScrolling = false;
    });
  }

  @override
  void dispose() {
    _stopScrolling();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFF9A8B),
              Color(0xFFFF6A88),
              Color(0xFFFF99AC),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 100),
                  child: Text(
                    widget.text,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: 8),
              child: Slider(
                value: _scrollSpeed,
                min: 10.0,
                max: 50.0,
                activeColor: Colors.pinkAccent,
                inactiveColor: Colors.white.withOpacity(0.5),
                onChanged: (value) {
                  setState(() {
                    _scrollSpeed = value;
                  });
                },
              ),
            ),
            ElevatedButton(
              onPressed: _isScrolling ? _stopScrolling : _startScrolling,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isScrolling ? Colors.red : Colors.purple,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                _isScrolling ? "Stop Scrolling" : "Start Scrolling",
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
