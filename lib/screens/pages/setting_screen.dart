import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_plan/screens/settings/profile_section.dart';
import 'package:travel_plan/theme/res/palette_theme.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Settings',
          style: TextStyle(
            color: Color(0xFF201A09),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.yellow,
            ),
            onPressed: () {
              _showLogoutDialog(context); // Show the logout dialog
            },
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/profileedite');
                },
                child: Row(
                  children: [
                    ProfileSection(),
                  ],
                ),
              ),

              const SizedBox(height: 40),
              Text(
                'Account settings',
                style: TextStyle(
                  color: PaletteTheme.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 30),
              // Change Password
              buildSettingOption(
                context,
                icon: Icons.lock,
                label: 'Change password',
                onTap: () => Navigator.pushNamed(context, '#'),
              ),
              const SizedBox(height: 30),
              // Notifications
              buildSettingOption(
                context,
                icon: Icons.notifications,
                label: 'Notification',
                onTap: () => Navigator.pushNamed(context, '/notification'),
              ),
              const SizedBox(height: 30),
              // Help
              buildSettingOption(
                context,
                icon: Icons.help,
                label: 'Help',
                subtitle: 'Contact to admin?',
                onTap: () => Navigator.pushNamed(context, '#'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSettingOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: PaletteTheme.grey200,
                ),
                child: Icon(
                  icon,
                  color: PaletteTheme.textDesc,
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: PaletteTheme.black,
                      fontSize: 15,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: PaletteTheme.textgrey,
                      ),
                    ),
                ],
              ),
            ],
          ),
          Icon(
            Icons.keyboard_arrow_right,
            size: 30,
            color: PaletteTheme.title,
          )
        ],
      ),
    );
  }
}

Future<void> _showLogoutDialog(BuildContext context) async {
  // Display the confirmation dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Logout'),
        content: Text('Do you want to log out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              // Set the login status to false in SharedPreferences
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool("isLogin", false);

              // Navigate to the login screen
              Navigator.of(context).pop(); // Close the dialog
              Navigator.pushReplacementNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Optional styling for 'Sure'
            ),
            child: Text(
              'Sure',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}
