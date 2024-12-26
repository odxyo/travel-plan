import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_plan/widgets/place_girdview_screen.dart';
import 'package:travel_plan/services/btmbar/nav_service.dart';

class LikePage extends StatefulWidget {
  @override
  State<LikePage> createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  @override
  Widget build(BuildContext context) {
    var navigationProvider = context.read<NavigationProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Favorites',
          style: TextStyle(
            color: Color(0xFF111518),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Color(0xFF111518)),
            onPressed: () {
              // pages = 2;
              navigationProvider.setIndex(1);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Favorites Popular destinations',
                  style: TextStyle(
                    color: Color(0xFF617B89),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),
              PlaceGirdviewScreen(
                crossA: 1,
                showAll: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
