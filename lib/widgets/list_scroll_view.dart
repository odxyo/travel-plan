import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:travel_plan/screens/trip/detail_place.dart';
import 'package:travel_plan/theme/res/palette_theme.dart';
import '../models/place.dart';

final pb = PocketBase('${dotenv.env['POCKETBASE_URL']}');

class ListScrollView extends StatelessWidget {
  final List<Place> places;
  final double itemWidths;

  const ListScrollView({
    required this.places,
    required this.itemWidths,
  });

  @override
  Widget build(BuildContext context) {
    final recommendedPlaces = places.where((place) => place.recommend).toList();
    return Container(
      height: 270,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendedPlaces.length,
        itemBuilder: (context, index) {
          final place = recommendedPlaces[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPlace(
                    placeId: place.id,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: Container(
                width: itemWidths,
                decoration: BoxDecoration(
                  color: PaletteTheme.grey200,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 4), // Shadow position
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5, left: 5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            "${pb.baseURL}/api/files/pbc_3384545563/${place.id}/${place.img}", // Image URL from API
                            fit: BoxFit.cover,
                            height: 160,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          place.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: PaletteTheme.title,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: PaletteTheme.black,
                              size: 18,
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${place.province}, ${place.district}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: PaletteTheme.textDesc,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
