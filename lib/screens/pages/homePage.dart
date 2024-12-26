import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_plan/widgets/home_image_slide.dart';
import 'package:travel_plan/widgets/place_girdview_screen.dart';
import 'package:travel_plan/screens/pages/place_list_screen.dart';
import 'package:travel_plan/services/api/api_service.dart';
import 'package:travel_plan/services/btmbar/nav_service.dart';

import 'package:travel_plan/theme/res/palette_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // int _currentIndex = 0;

  final ApiService apiService = ApiService();
  bool showAll = false;
  @override
  Widget build(BuildContext context) {
    var navigationProvider = context.read<NavigationProvider>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          'Travel',
          style: TextStyle(
            color: Color(0xFF201A09),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Color(0xFF201A09)),
            onPressed: () {
              navigationProvider.setIndex(1);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                height: 218,
                child: HomeImageSlide(),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Get stard searching for a place plan or \n make your experiene. ',
                      style: TextStyle(
                        color: const Color.fromARGB(253, 158, 158, 158),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          navigationProvider.setIndex(1);
                        },
                        child: Text(
                          'Get start search',
                          style: TextStyle(color: PaletteTheme.title),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(300, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: BorderSide(
                            color: PaletteTheme.grey150,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      ' Recommended',
                      style: TextStyle(
                        color: PaletteTheme.textDesc,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              PlaceListScreen(),
              SizedBox(
                height: 10,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ' Trending travel',
                      style: TextStyle(
                        color: PaletteTheme.textDesc,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              PlaceGirdviewScreen(
                crossA: 2,
                showAll: showAll,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showAll = !showAll;
                        });
                      },
                      child: Text(
                        showAll ? 'Show Less' : 'Show All',
                        style: TextStyle(color: PaletteTheme.textDesc),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(100, 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          side: BorderSide(
                            color: PaletteTheme.grey150,
                            width: 1,
                          )),
                    ),
                    SizedBox(width: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
