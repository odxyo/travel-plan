import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:travel_plan/main.dart';
import 'package:travel_plan/theme/res/palette_theme.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IntroductionScreen(
      pages: [
        PageViewModel(
            title: "Plan Your Trip",
            body: "Create detailed itineraries for your dream destinations",
            image: Padding(
              padding: EdgeInsets.all(32),
              child: Image.asset("assets/images/onboarding1.png"),
            ),
            decoration: PageDecoration(
                titleTextStyle: TextStyle(
                  color: PaletteTheme.title,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
                bodyTextStyle: TextStyle(
                  color: PaletteTheme.textgrey,
                  fontSize: 18,
                ))),
        PageViewModel(
            title: "Trip like a Game",
            body: "Plan trips game and share ideas in real time",
            image: Padding(
              padding: EdgeInsets.all(32),
              child: Image.asset("assets/images/onboarding3.png"),
            ),
            decoration: PageDecoration(
                titleTextStyle: TextStyle(
                  color: PaletteTheme.title,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
                bodyTextStyle: TextStyle(
                  color: PaletteTheme.textgrey,
                  fontSize: 18,
                ))),
      ],
      next: Text(
        "Next",
        style:
            TextStyle(fontWeight: FontWeight.w500, color: PaletteTheme.title),
      ),
      done: Text(
        "Get start",
        style:
            TextStyle(fontWeight: FontWeight.w500, color: PaletteTheme.title),
      ),
      onDone: () {
        prefs.setBool("isOnboarded", true);
        Navigator.pushReplacementNamed(context, '/login');
      },
    ));
  }
}
