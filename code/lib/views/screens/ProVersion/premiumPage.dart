import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confident_voice/Controllers/premiumPlanCUbit.dart';
import 'package:confident_voice/views/screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PremiumCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFF6A1B9A),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Go Premium!",
                  style: TextStyle(
                    color: Color(0xFFFFD700),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Unlock exclusive features and take your experience to the next level!",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFAB47BC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFFFD700),
                      width: 2,
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PremiumFeature(
                        icon: Icons.star,
                        title: "Exclusive Features",
                        description:
                            "Access tools like the progress tracker, AI assistance and much more.",
                      ),
                      SizedBox(height: 16),
                      PremiumFeature(
                        icon: Icons.access_time,
                        title: "Unlimited Access",
                        description:
                            "Enjoy unlimited access to all the limited features in the free version.",
                      ),
                      SizedBox(height: 16),
                      PremiumFeature(
                        icon: Icons.lock,
                        title: "Ad-Free Experience",
                        description:
                            "Enjoy using the app without any interruptions from ads.",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Choose Your Plan",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                BlocBuilder<PremiumCubit, PremiumPlan>(
                  builder: (context, selectedPlan) {
                    return Column(
                      children: [
                        PremiumPlanCard(
                          title: "Monthly Plan",
                          price: "799 da/month",
                          color: const Color(0xFF9C27B0),
                          isSelected: selectedPlan == PremiumPlan.monthly,
                          onTap: () {
                            context.read<PremiumCubit>().selectMonthlyPlan();
                          },
                        ),
                        const SizedBox(height: 16),
                        PremiumPlanCard(
                          title: "Yearly Plan",
                          price: "7999 da/year",
                          color: const Color(0xFF7B1FA2),
                          isPopular: true,
                          isSelected: selectedPlan == PremiumPlan.yearly,
                          onTap: () {
                            context.read<PremiumCubit>().selectYearlyPlan();
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 30),
                Builder(
                  builder: (context) {
                    return ElevatedButton(
                      onPressed: () async {
                        final selectedPlan = context.read<PremiumCubit>().state;
                        if (selectedPlan == PremiumPlan.none) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("Please select a plan to continue."),
                            ),
                          );
                        } else {
                          try {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .update({
                                'isPremium': true,
                                'premiumPlan':
                                    selectedPlan == PremiumPlan.monthly
                                        ? 'monthly'
                                        : 'yearly',
                                'premiumExpiryDate':
                                    _calculateExpiryDate(selectedPlan),
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "You have successfully upgraded to the ${selectedPlan == PremiumPlan.monthly ? 'Monthly' : 'Yearly'} plan!",
                                  ),
                                ),
                              );
                              final currentUser =
                                  FirebaseAuth.instance.currentUser;
                              try {
                                final userDoc = await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(currentUser!.uid)
                                    .get();

                                final userName =userDoc['fullName']??
                                    currentUser.displayName;
                                final String profilePictureUrl =
                                    userDoc.get('profilePictureUrl') ??
                                        'assets/images/default_profile.png';

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(
                                      userName: userName,
                                      profilePictureUrl: profilePictureUrl, userEmail: '',
                                    ),
                                  ),
                                );
                              } catch (firestoreError) {
                                print(
                                    "Error fetching from Firestore: $firestoreError");
                                final userName = currentUser?.displayName ??
                                    'Guest'; 
                                const profilePictureUrl =
                                    'assets/images/default_profile.png'; 

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(
                                      userName: userName,
                                      profilePictureUrl: profilePictureUrl, userEmail: '3',
                                    ),
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("User not logged in."),
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Error upgrading: $e"),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: const BorderSide(
                            color: Color(0xFFFFD700),
                            width: 2,
                          ),
                        ),
                      ),
                      child: const Text(
                        "Upgrade Now",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFFFFD700),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "No, Thanks",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DateTime _calculateExpiryDate(PremiumPlan plan) {
    if (plan == PremiumPlan.monthly) {
      return DateTime.now().add(const Duration(days: 30));
    } else if (plan == PremiumPlan.yearly) {
      return DateTime.now().add(const Duration(days: 365));
    } else {
      return DateTime.now();
    }
  }
}
class PremiumFeature extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const PremiumFeature({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: const Color(0xFFFFD700),
          size: 32,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class PremiumPlanCard extends StatelessWidget {
  final String title;
  final String price;
  final Color color;
  final bool isPopular;
  final bool isSelected;
  final VoidCallback onTap;

  const PremiumPlanCard({
    super.key,
    required this.title,
    required this.price,
    required this.color,
    this.isPopular = false,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? const Color(0xFFFFD700) : Colors.transparent,
                width: isSelected ? 3 : 0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  price,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          if (isPopular)
            Positioned(
              right: 10,
              top: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Popular",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}