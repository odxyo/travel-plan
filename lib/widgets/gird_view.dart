import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:travel_plan/screens/trip/detail_place.dart';
import 'package:travel_plan/screens/trip/favorite_button.dart';
import 'package:travel_plan/services/btmbar/sharepreference_service.dart';
import 'package:travel_plan/theme/res/palette_theme.dart';
import 'package:travel_plan/widgets/no_data_placeholder.dart';
import '../models/place.dart';

final pb = PocketBase(dotenv.env['POCKETBASE_URL']!);

class GridViews extends StatefulWidget {
  final List<Place> places;
  final int crossA;
  final bool showAll;

  GridViews({
    Key? key,
    required this.places,
    required this.crossA,
    required this.showAll,
  }) : super(key: key);

  @override
  _GridViewsState createState() => _GridViewsState();
}

class _GridViewsState extends State<GridViews> {
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedpreferenceService sharedPreferencesService =
        SharedpreferenceService();
    String? storedUserId = await sharedPreferencesService.getUserId();
    setState(() {
      userId = storedUserId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.places.isNotEmpty
        ? Container(
            width: double.infinity,
            color: PaletteTheme.boxBackground,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.crossA,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: widget.crossA == 2 ? 3 / 3.5 : 3 / 2.1,
              ),
              itemCount: widget.showAll ? widget.places.length : 5,
              itemBuilder: (context, index) {
                final place = widget.places[index];

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
                  child: Container(
                    decoration: BoxDecoration(
                      color: PaletteTheme.white,
                      borderRadius: BorderRadius.circular(10),

                      // border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                "${pb.baseURL}/api/files/pbc_3384545563/${place.id}/${place.img}",
                                fit: BoxFit.cover,
                                height: widget.crossA == 2 ? 125 : 200,
                                width: double.infinity,
                              ),
                            ),
                            Container(
                              height: widget.crossA == 2 ? 125 : 200,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.4),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            if (widget.crossA == 1)
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: FavoriteButton(
                                  placeId: place.id,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          place.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: PaletteTheme.title,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: PaletteTheme.textDesc,
                                size: 18,
                              ),
                              SizedBox(width: 4),
                              Expanded(
                                // Use Expanded to make the text fit within the available space
                                child: Text(
                                  '${place.province}, ${place.district}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: PaletteTheme.textDesc,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        : NoDataFound();
  }
}
