import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:confident_voice/Controllers/theme_bloc.dart';
import 'package:confident_voice/Controllers/profile_bloc.dart';
import 'package:confident_voice/models/Events/profile_event.dart';
import 'package:confident_voice/models/States/profile_state.dart';
import 'package:confident_voice/views/screens/login/login.dart';
import 'package:confident_voice/views/screens/profile/help_center.dart';
import 'package:confident_voice/views/screens/profile/logout.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc()..add(InitializeProfileEvent()),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeBloc>().state.isDark;
    final profileBloc = context.read<ProfileBloc>();
    
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: isDarkMode ? Colors.grey[900] : const Color(0xFFF6F6F6),
          appBar: AppBar(
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
            elevation: 0.5,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/homepage');
              },
            ),
            title: Text(
              "Profile",
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.logout,
                    color: isDarkMode ? Colors.white : Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  );
                },
              ),
            ],
            centerTitle: false,
          ),
          body: Column(
            children: [
              const SizedBox(height: 40),
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(state.profileImage),
              ),
              const SizedBox(height: 20),
              Text(
                state.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                state.email,
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 160,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/personal_info');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode
                        ? Colors.deepPurple[700]!
                        : const Color(0xFFA26DC5),
                    elevation: 5,
                    shadowColor: Colors.grey.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.deepPurple),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    "Edit Profile",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView(
                  children: [
                    _buildProfileOption(
                      context,
                      icon: Icons.person,
                      title: "Personnel Info",
                      onTap: () {
                        Navigator.pushNamed(context, '/personal_info');
                      },
                      isDarkMode: isDarkMode,
                    ),
                    _buildProfileOption(
                      context,
                      icon: Icons.settings,
                      title: "Settings",
                      onTap: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                      isDarkMode: isDarkMode,
                    ),
                    _buildProfileOption(
                      context,
                      icon: Icons.security,
                      title: "Security",
                      onTap: () {
                        Navigator.pushNamed(context, '/security');
                      },
                      isDarkMode: isDarkMode,
                    ),
                    _buildProfileOption(
                      context,
                      icon: Icons.help_outline,
                      title: "Help Center",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HelpCenter()),
                        );
                      },
                      isDarkMode: isDarkMode,
                    ),
                    _buildProfileOption(
                      context,
                      icon: Icons.logout,
                      title: "Logout",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LogoutPage()),
                        );
                      },
                      isLogout: true,
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
    required bool isDarkMode,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout
            ? Colors.red
            : isDarkMode
                ? Colors.white
                : const Color(0xFF412963),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isLogout
              ? Colors.red
              : isDarkMode
                  ? Colors.white
                  : Colors.black,
        ),
      ),
      trailing:
          const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
      onTap: onTap,
    );
  }
}
