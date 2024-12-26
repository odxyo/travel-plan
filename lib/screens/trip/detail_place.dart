import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:travel_plan/models/place.dart';
import 'package:travel_plan/screens/trip/favorite_button.dart';
import 'package:travel_plan/screens/trip/select_time.dart';
import 'package:travel_plan/services/api/api_service.dart';
import 'package:travel_plan/services/btmbar/sharepreference_service.dart';

import 'package:travel_plan/widgets/user_review.dart';
import 'package:travel_plan/theme/res/palette_theme.dart';
import 'package:travel_plan/widgets/user_review_popup.dart';
import 'package:url_launcher/url_launcher.dart';

final pb = PocketBase('${dotenv.env['POCKETBASE_URL']}');

class DetailPlace extends StatefulWidget {
  final String placeId;

  DetailPlace({Key? key, required this.placeId}) : super(key: key);

  @override
  _DetailPlaceState createState() => _DetailPlaceState();
}

class _DetailPlaceState extends State<DetailPlace> {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Place Details',
          style: TextStyle(
            color: Color(0xFF111518),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Place>(
        future: apiService.getPlaceDetails(widget.placeId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: Text('Place not found!'));
          }

          final place = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),

                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          "${pb.baseURL}/api/files/pbc_3384545563/${place.id}/${place.img}",
                          fit: BoxFit.cover,
                          height: 300,
                          width: double.infinity,
                        ),
                      ),

                      // Positioned favorite icon
                      Positioned(
                          bottom: 16,
                          right: 16,
                          child: FavoriteButton(placeId: widget.placeId)),
                    ],
                  ),

                  SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.only(right: 15, left: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: GestureDetector(
                            onTap: () async {
                              final googleMapsUrl = place.locationPlace;
                              // final googleMapsUrl =
                              //     'https://maps.app.goo.gl/yyc9Xafw9J5LsYJV6';
                              if (await canLaunch(googleMapsUrl)) {
                                await launch(googleMapsUrl);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Could not open Google Maps')),
                                );
                              }
                            },
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(9),
                                  child: Icon(
                                    Icons.place_outlined,
                                    color: Colors.red,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: PaletteTheme.grey200,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      place.district,
                                      style: TextStyle(
                                        color: PaletteTheme.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      place.province,
                                      style: TextStyle(
                                        color: PaletteTheme.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: GestureDetector(
                            onTap: () {
                              _showRatingPopup(context);
                            },
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(9),
                                  child: Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: PaletteTheme.grey100,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'Rating',
                                      style: TextStyle(
                                        color: PaletteTheme.textgrey,
                                      ),
                                    ),
                                    Text(
                                      '5.4',
                                      style: TextStyle(
                                          color: PaletteTheme.black,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    place.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: PaletteTheme.title,
                    ),
                  ),
                  SizedBox(height: 8),

                  SizedBox(height: 16),

                  Text(
                    place.detail,
                    style: TextStyle(
                      fontSize: 14,
                      color: PaletteTheme.textDesc,
                    ),
                  ),
                  SizedBox(height: 100),

                  Text(
                    'User Reviews',
                    style: TextStyle(
                      color: PaletteTheme.textDesc,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  // Displaying user reviews
                  ReviewCard(
                    placeId: place.id,
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelectTimePage(
                placeId: widget.placeId,
              ),
            ),
          );
        },
        label: Text(
          "Make Plan",
          style: TextStyle(color: PaletteTheme.textDesc),
        ),
        icon: Icon(
          Icons.add,
          color: PaletteTheme.black,
        ),
        backgroundColor: PaletteTheme.yellow,
      ),
    );
  }

  void _showRatingPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RatingPopup(
          placeId: widget.placeId,
          getUserId: () async {
            try {
              return await SharedpreferenceService().getUserId();
            } catch (e) {
              log('Error fetching user ID: $e');
              return null;
            }
          },
          submitReview: (body) async {
            await pb.collection('user_reviews').create(body: body);
          },
        );
      },
    );
  }
}
