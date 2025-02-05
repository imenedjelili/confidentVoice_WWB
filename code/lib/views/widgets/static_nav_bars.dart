import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confident_voice/views/themes/themeprovider.dart';

class StaticNavBars {
  static BottomNavigationBar homeNavigationBar(BuildContext context, int currentIndex, Function(int) onTap) {
    final isDarkMode = Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark;
    
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
      selectedItemColor: const Color(0xFF412963), // Deep purple
      unselectedItemColor: const Color(0xFFA26DC5), // Normal purple
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
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
  }

  static BottomNavigationBar speechLibraryNavigationBar(BuildContext context, int currentIndex, Function(int) onTap) {
    final isDarkMode = Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark;
    
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
      selectedItemColor: const Color(0xFF412963), // Deep purple
      unselectedItemColor: const Color(0xFFA26DC5), // Normal purple
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.slideshow),
          label: 'Slides',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.text_fields),
          label: 'Text',
        ),
      ],
    );
  }
}
