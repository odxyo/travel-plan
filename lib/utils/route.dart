import 'package:flutter/material.dart';
import 'package:travel_plan/screens/admin/dashboard.dart';
import 'package:travel_plan/screens/auth/login_screens.dart';
import 'package:travel_plan/screens/auth/signup_screen.dart';
import 'package:travel_plan/screens/pages/homePage.dart';
import 'package:travel_plan/screens/onboarding/onboarding_screen.dart';
import 'package:travel_plan/screens/pages/seach_screen.dart';
import 'package:travel_plan/screens/pages/setting_screen.dart';
import 'package:travel_plan/screens/pages/trips_screen.dart';
import 'package:travel_plan/screens/settings/notification_setting.dart';
import 'package:travel_plan/screens/settings/profile_edit.dart';
import 'package:travel_plan/widgets/custom_bottom_bar.dart';

// Define a centralized route mapping
class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signUp = '/signup';
  static const String bottomNavbar = '/navbar';
  static const String homepage = '/homepage';
  static const String search_screen = '/searchpage';
  static const String like_screen = '/likepage';
  static const String detailplace = '/detailplace';
  static const String trips = '/trips';
  static const String setting = '/setting';
  static const String notification = '/notification';
  static const String profileEdit = '/profileedite';
  static const String dashboard = '/dashboard';
  // static const String select_time = '/select_time';

  static Map<String, WidgetBuilder> routes = {
    onboarding: (context) => OnboardingScreen(),
    login: (context) => LoginScreen(),
    signUp: (context) => SignupScreen(),
    bottomNavbar: (context) => CustomBottomNavBar(),
    homepage: (context) => HomeScreen(),
    search_screen: (context) => SearchPage(),
    trips: (context) => TripsScreen(),
    setting: (context) => SettingScreen(),
    notification: (context) => NotificationSettingsPage(),
    profileEdit: (context) => ProfileEditPage(),
    dashboard: (context) => DashboardPage(),
 
  };
}
