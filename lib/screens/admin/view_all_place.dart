import 'package:flutter/material.dart';
import 'package:travel_plan/screens/admin/admin_place_list.dart';
import 'package:travel_plan/widgets/seach_component.dart';

import 'package:travel_plan/theme/res/palette_theme.dart';

class ViewAllPlace extends StatefulWidget {
  const ViewAllPlace({super.key});

  @override
  State<ViewAllPlace> createState() => _ViewAllPlaceState();
}

class _ViewAllPlaceState extends State<ViewAllPlace> {
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
        // automaticallyImplyLeading: false,
        title: Text(
          'Places',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchComponent(onSearch: onSearch),
              Text(
                'All places',
                style: TextStyle(
                  color: PaletteTheme.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              AdminPlaceList(searchQuery: searchQuery),
            ],
          ),
        ),
      ),
    );
  }
}
