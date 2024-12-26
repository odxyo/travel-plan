import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_plan/provider/favorite_provider.dart';
import 'package:travel_plan/screens/auth/login_screens.dart';
import 'package:travel_plan/utils/route.dart';
import 'package:provider/provider.dart';
import 'services/btmbar/nav_service.dart';

late SharedPreferences prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    log("Failed to load .env file: $e");
  }

  prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider(
            pb: pb,
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isOnboarded = prefs.getBool("isOnboarded") ?? false;
    bool isLogin = prefs.getBool("isLogin") ?? false;

    String initialRoute;
    if (!isOnboarded) {
      initialRoute = AppRoutes.onboarding;
    } else if (!isLogin) {
      initialRoute = AppRoutes.login;
    } else {
      initialRoute = AppRoutes.bottomNavbar;
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
          bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
          displayLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
        ),
      ),
      initialRoute: initialRoute,
      routes: AppRoutes.routes,
    
    );
  }
}
