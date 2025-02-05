import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:confident_voice/views/screens/homepage.dart';
import 'package:confident_voice/views/screens/librarypage.dart';
import 'package:confident_voice/views/screens/profilepage.dart';
import 'package:confident_voice/views/screens/contribution_screen.dart';
import 'package:confident_voice/Controllers/bottom_nav_cubit.dart';

class BottomNavigationWidget extends StatelessWidget {
  final bool showBottomNavBar;

  BottomNavigationWidget({super.key, this.showBottomNavBar = true});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomNavCubit(),
      child: Scaffold(
        body: BlocBuilder<BottomNavCubit, int>(
          builder: (context, currentIndex) {
            return _screens[currentIndex];
          },
        ),
        bottomNavigationBar: showBottomNavBar
            ? BlocBuilder<BottomNavCubit, int>(
                builder: (context, currentIndex) {
                  final isDarkMode =
                      Theme.of(context).brightness == Brightness.dark;

                  return BottomNavigationBar(
                    currentIndex: currentIndex,
                    onTap: (index) {
                      context.read<BottomNavCubit>().changeIndex(index);
                    },
                    backgroundColor:
                        isDarkMode ? Colors.grey[800] : Colors.white,
                    selectedItemColor: isDarkMode
                        ? const Color(0xFFA26DC5)
                        : const Color(0xFF412963),
                    unselectedItemColor:
                        isDarkMode ? Colors.white70 : const Color(0xFFA26DC5),
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.book),
                        label: 'Library',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.add_circle),
                        label: 'Contribute',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: 'Profile',
                      ),
                    ],
                  );
                },
              )
            : null,
      ),
    );
  }

  final List<Widget> _screens = [
    const HomePage(),
    const SpeechLibraryPage(),
    const ContributionScreen(),
    const ProfileScreen(),
  ];
}
