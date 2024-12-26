import 'package:flutter/material.dart';

class HomeImageSlide extends StatefulWidget {
  @override
  _HomeImageSlideState createState() => _HomeImageSlideState();
}

class _HomeImageSlideState extends State<HomeImageSlide> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Start the auto scrolling of slides
    _autoScrollSlides();
  }

  void _autoScrollSlides() {
    Future.delayed(const Duration(seconds: 10), () {
      setState(() {
        _currentPage++;
        if (_currentPage >= 3) {
          _currentPage = 0;
        }
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      _autoScrollSlides();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          _buildSlide('TAILOR-MADE TRAVEL', 'assets/images/travel_slide2.jpg'),
          _buildSlide('RELAX WITH NATURE', 'assets/images/travel_slide1.jpg'),
          _buildSlide('FREE TO USE', 'assets/images/wangwieng.webp'),
        ],
      ),
    );
  }

  Widget _buildSlide(String text, String imagePath) {
    return Container(
      height: 218,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.darken,
          ),
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 8),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
