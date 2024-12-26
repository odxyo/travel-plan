

import 'package:flutter/material.dart';
import 'package:travel_plan/models/place.dart';
import 'package:travel_plan/services/api/api_service.dart';
import 'package:travel_plan/widgets/list_scroll_view.dart';

class PlaceListScreen extends StatelessWidget {
  final ApiService apiService = ApiService();

  PlaceListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Place>>(
      future: apiService.fetchPlaces(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No places found'));
        }

        final places = snapshot.data!;
        return ListScrollView(
          places: places,
          itemWidths: 300, // Customize width
        );
      },
    );
  }
}
