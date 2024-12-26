import 'package:flutter/material.dart';
import 'package:travel_plan/models/place.dart';
import 'package:travel_plan/services/api/api_service.dart';
import 'package:travel_plan/widgets/gird_view.dart';
import 'package:travel_plan/widgets/no_data_placeholder.dart';

class PlaceGirdviewScreen extends StatelessWidget {
  final ApiService apiService = ApiService();
  final int crossA;
  final String? searchQuery;
  final String? userId;
  final bool showAll;
  PlaceGirdviewScreen({
    Key? key,
    required this.crossA,
    this.searchQuery,
    this.userId,
     required this.showAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Place>>(
      future: crossA == 2
          ? apiService.fetchPlaces()
          : apiService.fetchFavoritePlaces(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return NoDataFound();
        }

        final places = snapshot.data!
            .where((place) =>
                searchQuery == null ||
                searchQuery!.isEmpty ||
                place.title.toLowerCase().contains(searchQuery!.toLowerCase()))
            .toList();

        return GridViews(
          places: places,
          crossA: crossA,
          showAll: showAll,
        );
      },
    );
  }
}
