import 'dart:io';
import 'package:flutter/material.dart';
import 'package:confident_voice/views/screens/ProVersion/premiumPage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:confident_voice/Controllers/home_bloc.dart';
import 'package:confident_voice/models/Events/home_event.dart';
import 'package:confident_voice/models/States/home_state.dart';
import 'package:confident_voice/views/screens/profilepage.dart';
import 'package:confident_voice/views/screens/librarypage.dart';
import 'package:confident_voice/views/screens/contributepage.dart';
import 'package:confident_voice/views/screens/progress_tracker.dart';
import 'package:confident_voice/data/quotes.dart';
import 'package:confident_voice/databases/db_confidentVoice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  final String userName;
  final String profilePictureUrl;
  final String userEmail; // Added userEmail
  final bool isAssetImage;

  const HomePage({
    super.key,
    required this.userName,
    required this.profilePictureUrl,
    required this.userEmail, // Added userEmail
    this.isAssetImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(InitializeHomeEvent()),
      child: _HomeView(
        userName: userName,
        profilePictureUrl: profilePictureUrl,
        userEmail: userEmail, // Passed userEmail
        isAssetImage: isAssetImage,
      ),
    );
  }
}

class _HomeView extends StatefulWidget {
  final String userName;
  final String profilePictureUrl;
  final String userEmail; // Added userEmail
  final bool isAssetImage;

  const _HomeView({
    required this.userName,
    required this.profilePictureUrl,
    required this.userEmail, // Added userEmail
    required this.isAssetImage,
  });

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  int _currentIndex = 0;
  late List<Widget> _screens;
  late Stream<bool> _premiumStream;

  @override
  void initState() {
    super.initState();
    _screens = [
      const _HomeContent(),
      const ContributePage(),
      ProfileScreen(
        userName: widget.userName,
        userEmail: widget.userEmail, // Used actual userEmail
        profilePictureUrl: widget.profilePictureUrl,
        isAssetImage: widget.isAssetImage,
      ),
    ];
    _premiumStream = _createPremiumStream();
  }

  Stream<bool> _createPremiumStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.value(false);

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((snapshot) => snapshot.data()?['isPremium'] ?? false);
  }

  Widget _buildPremiumOrProgressButton(BuildContext context, bool isPremium) {
    if (!isPremium) {
      return TextButton.icon(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PremiumScreen(),
            ),
          );
          // Recheck premium status after returning from premium screen
          _premiumStream = _createPremiumStream();
        },
        icon: Icon(
          Icons.emoji_events,
          color: Colors.yellow[800],
        ),
        label: Text(
          "Premium",
          style: TextStyle(
            color: Colors.yellow[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          backgroundColor: const Color.fromARGB(255, 255, 220, 92),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.bar_chart_rounded),
        color: Theme.of(context).primaryColor,
        tooltip: 'Progress Tracker',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProgressTrackerScreen(),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : const Color(0xFFF6F6F6),
      body: _screens[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            if (index == 1) {
              // Library tab
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SpeechLibraryPage()),
              );
            } else {
              setState(() {
                _currentIndex = index > 1
                    ? index - 1
                    : index; // Adjust index since library is handled separately
              });
            }
          },
          items: [
            _buildNavItem(Icons.home, 'Home', 0),
            _buildNavItem(Icons.book, 'Library', 1),
            _buildNavItem(Icons.add_circle, 'Contribute', 2),
            _buildNavItem(Icons.person, 'Profile', 3),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      IconData icon, String label, int index) {
    final bool isSelected =
        index == _currentIndex || (index > 1 && (index - 1) == _currentIndex);

    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: isSelected
            ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor
            : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
      ),
      label: label,
    );
  }
}

class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  ImageProvider getImageProvider(String path, bool isAsset) {
    if (isAsset) {
      return AssetImage(path);
    }
    try {
      return FileImage(File(path));
    } catch (e) {
      return const AssetImage('assets/images/image_placeholder.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    final _HomeViewState homeViewState =
        context.findAncestorStateOfType<_HomeViewState>()!;

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[900]
              : const Color(0xFFF6F6F6),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          userName: homeViewState.widget.userName,
                          userEmail: homeViewState.widget.userEmail,
                          profilePictureUrl: homeViewState.widget.profilePictureUrl,
                          isAssetImage: homeViewState.widget.isAssetImage,
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 16,
                    backgroundImage: getImageProvider(
                      homeViewState.widget.profilePictureUrl,
                      homeViewState.widget.isAssetImage,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  homeViewState.widget.userName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Stack(
                    children: [
                      const Icon(Icons.notifications_outlined, color: Colors.black),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: const Text(
                            '2',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    _showNotificationsPanel(context);
                  },
                ),
                StreamBuilder<bool>(
                  stream: homeViewState._premiumStream,
                  builder: (context, snapshot) {
                    final isPremium = snapshot.data ?? false;
                    return homeViewState._buildPremiumOrProgressButton(context, isPremium);
                  },
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(RefreshQuoteEvent());
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFA26DC5),
                              Color(0xFFB87D99),
                              Color(0xFFFCAC12),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "Welcome, dear ${homeViewState.widget.userName}! Have a great day!",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildQuoteOfTheDay(context),
                      const SizedBox(height: 30),
                      const Text(
                        "Categories",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: state.categories.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      state.categories[index]['page'],
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Container(
                                  height: 90.44,
                                  width: 90,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFA26DC5),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.transparent,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 6,
                                            spreadRadius: 2,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        state.categories[index]['icon'],
                                        size: 50,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  state.categories[index]['title'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuoteOfTheDay(BuildContext context) {
    final quote = getRandomQuote();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -10,
              left: 20,
              child: Transform.rotate(
                angle: -0.2,
                child: Icon(
                  Icons.format_quote,
                  size: 40,
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                ),
              ),
            ),
            Positioned(
              bottom: -10,
              right: 20,
              child: Transform.rotate(
                angle: 2.9,
                child: Icon(
                  Icons.format_quote,
                  size: 40,
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quote of the Day',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF412963),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    quote.quote,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.5,
                      fontStyle: FontStyle.italic,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF412963).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Confident Voice',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF412963),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showNotificationsPanel(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildNotificationItem(
                  'New Achievement!',
                  'You completed 5 voice exercises.',
                  '2m ago',
                  Icons.emoji_events,
                  Colors.amber,
                ),
                const SizedBox(height: 12),
                _buildNotificationItem(
                  'Daily Reminder',
                  'Time for your daily voice training.',
                  '1h ago',
                  Icons.notifications_active,
                  Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildNotificationItem(
  String title,
  String message,
  String time,
  IconData icon,
  Color iconColor,
) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                message,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
      itemCount: 0,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Search Result $index'),
          onTap: () {},
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
      itemCount: 0,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Suggestion $index'),
          onTap: () {},
        );
      },
    );
  }
}