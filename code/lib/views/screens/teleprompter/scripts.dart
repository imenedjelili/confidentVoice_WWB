import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'teleprompter.dart';
import 'newScript.dart';

class Scripts extends StatefulWidget {
  const Scripts({super.key});

  @override
  State<Scripts> createState() => _ScriptsState();
}

class _ScriptsState extends State<Scripts> {
  List<Map<String, dynamic>> scripts = [];
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadScripts();
  }

  Future<void> _loadScripts() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('scripts')
            .where('userId', isEqualTo: user.uid)
            .orderBy('timestamp', descending: true)
            .get();

        setState(() {
          scripts = querySnapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'User not logged in';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Failed to load scripts: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Confident ",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.purple,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/logo2.png', // Replace with your logo path
                          height: 70,
                          width: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Text(
                      " Voice",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 15,
                      width: 250,
                      color: const Color(0xFFCB96C2),
                    ),
                    const Text(
                      "Teleprompter",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(right: 190, bottom: 16.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 15,
                  width: 250,
                  color: const Color(0xFFCB96C2),
                ),
                const Text(
                  "Your Recent Scripts:",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            const Expanded(
              // Use Expanded to center the indicator
              child: Center(child: CircularProgressIndicator()),
            )
          else if (error != null)
            Expanded(
              // Use Expanded to center the error message
              child: Center(child: Text(error!)),
            )
          else if (scripts.isEmpty)
            const Expanded(
              child: Center(
                child: Text("No scripts yet. Create one!"),
              ),
            )
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.6,
                  ),
                  itemCount: scripts.length,
                  itemBuilder: (context, index) {
                    final script = scripts[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Teleprompter(
                              text: script['description'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          script['topic'],
                          style: const TextStyle(fontSize: 16, height: 1.6),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
       
      
      Padding(
        padding:const EdgeInsets.symmetric(
          horizontal: 50.0,
          vertical: 16.0,
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NewScript(),
              ),
            ).then((_) {
              _loadScripts(); // Refresh scripts after returning
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF412963),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Center(
            child: Text(
              "Create new script",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ),
],
),
    );
  }
}
