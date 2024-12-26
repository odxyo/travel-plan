import 'package:flutter/material.dart';
import 'package:travel_plan/models/place.dart';
import 'package:travel_plan/screens/admin/place_edit.dart';
import 'package:travel_plan/services/api/api_service.dart';
import 'package:travel_plan/theme/res/palette_theme.dart';

class AdminPlaceList extends StatefulWidget {
  final String? searchQuery;
  const AdminPlaceList({
    Key? key,
    this.searchQuery,
  }) : super(key: key);

  @override
  State<AdminPlaceList> createState() => _AdminPlaceListState();
}

class _AdminPlaceListState extends State<AdminPlaceList> {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    final String? search = widget.searchQuery;
    return FutureBuilder<List<Place>>(
        // Corrected Future type
        future: apiService.fetchPlaces(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to load place data.'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No places found.'),
            );
          }
          final places = snapshot.data!
              .where((place) =>
                  search == null ||
                  search.isEmpty ||
                  place.title
                      .toLowerCase()
                      .contains(widget.searchQuery!.toLowerCase()))
              .toList();

          return Column(
            children: List.generate(places.length, (index) {
              final item = places[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PlaceEdit(
                                placeId: item.id,
                              )),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: PaletteTheme.grey200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${item.title}",
                                  style: TextStyle(
                                    color: PaletteTheme.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1, // Limit to one line
                                  overflow: TextOverflow
                                      .ellipsis, // Add ellipsis for long text
                                ),
                                const SizedBox(height: 5),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: item.province,
                                        style: TextStyle(
                                          color: PaletteTheme.textgrey,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' , ',
                                        style: TextStyle(
                                          color: PaletteTheme.textgrey,
                                        ),
                                      ),
                                      TextSpan(
                                        text: item.district,
                                        style: TextStyle(
                                          color: PaletteTheme.textgrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              "${pb.baseURL}/api/files/pbc_3384545563/${item.id}/${item.img}", // Accessing image URL
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        });
  }
}
