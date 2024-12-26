import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:travel_plan/models/user.dart';
import 'package:travel_plan/services/api/api_service.dart';
import 'package:travel_plan/theme/res/palette_theme.dart';

final pb = PocketBase(dotenv.env['POCKETBASE_URL']!);

class ProfileSection extends StatefulWidget {
  const ProfileSection({Key? key}) : super(key: key);

  @override
  _ProfileSectionState createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder<UserModel>(
      future: apiService.fetchUserById(), // Fetch user data by ID
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Failed to load user data.'),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: Text('No user data found.'),
          );
        }

        final user = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    user.avatar.isNotEmpty
                        ? "${pb.baseURL}/api/files/pbc_2862526969/${user.id}/${user.avatar}"
                        : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name.isNotEmpty ? user.name : 'N A M E',
                      style: TextStyle(
                        color: PaletteTheme.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user.email.isNotEmpty ? user.email : 'No Email',
                      style: TextStyle(
                        color: PaletteTheme.textgrey,
                      ),
                    ),
                  ],
                ),
                // const Icon(
                //   Icons.keyboard_arrow_right,
                //   size: 30,
                // )
              ],
            ),
            if (user.role_admin) ...[
              const SizedBox(height: 40),
              buildSettingOption(
                context,
                icon: Icons.dashboard_customize_outlined,
                label: 'Admin dashboard',
                onTap: () => Navigator.pushNamed(context, '/dashboard'),
              ),
            ],
          ]),
        );
      },
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              // const Icon(
              //   Icons.keyboard_arrow_right,
              //   size: 30,
              // )
            ],
          ),
        ],
      ),
    );
  }
}
