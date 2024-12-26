import 'package:flutter/material.dart';
import 'package:travel_plan/theme/res/palette_theme.dart';
import 'package:travel_plan/widgets/place_girdview_screen.dart';
import 'package:travel_plan/screens/pages/place_list_screen.dart';

import 'package:travel_plan/widgets/seach_component.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchQuery = '';

  void onSearch(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Search',
            style: TextStyle(
              color: Color(0xFF201A09),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchComponent(onSearch: onSearch),
              const SizedBox(height: 12),
              Text(
                'Search the place you need to travel \nand make a plan.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              if (searchQuery.isEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  ' For You',
                  style: TextStyle(
                    color: PaletteTheme.textDesc,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                PlaceListScreen(),
              ],
              const SizedBox(height: 20),
              Text(
                ' Popular destinations',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: PaletteTheme.textDesc,
                ),
              ),
              const SizedBox(height: 8),
              PlaceGirdviewScreen(
                crossA: 2,
                searchQuery: searchQuery,
                showAll: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
