import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:travel_plan/models/tripItems.dart';
import 'package:travel_plan/screens/trip/show_popup.dart';
import 'package:travel_plan/services/api/api_service.dart';
import 'package:travel_plan/widgets/no_data_placeholder.dart';

import 'package:travel_plan/theme/res/palette_theme.dart';

final pb = PocketBase('${dotenv.env['POCKETBASE_URL']}');

class TripList extends StatefulWidget {
  final bool status;

  TripList({
    Key? key,
    required this.status,
  });
  @override
  State<TripList> createState() => _TripListState();
}

class _TripListState extends State<TripList> {
  final ApiService apiService = ApiService();
  late Future<List<TripItem>> _futureTrips;

  @override
  void initState() {
    super.initState();
    _futureTrips = _loadTrips();
  }

  Future<List<TripItem>> _loadTrips() async {
    return await apiService.fetchTrips(widget.status);
  }

  void _refreshTrips() {
    setState(() {
      _futureTrips = _loadTrips();
    });
  }

  String formatDate(String dateTime) {
    DateTime date = DateTime.parse(dateTime);
    return DateFormat('MMM-dd-yyyy').format(date);
  }

  String calculateNights(String start, String end) {
    DateTime startDate = DateTime.parse(start);
    DateTime endDate = DateTime.parse(end);
    int difference = endDate.difference(startDate).inDays;
    return '$difference nights';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TripItem>>(
      future: apiService.fetchTrips(widget.status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return NoDataFound();
        }

        final trips = snapshot.data!;

        return Column(
          children: List.generate(trips.length, (index) {
            final trip = trips[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: GestureDetector(
                onTap: () {
                  showPopup(context, trip, _refreshTrips);
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
                                "${trip.placeTitle}",
                                style: TextStyle(
                                  color: PaletteTheme.title,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 1, // Limit to one line
                                overflow: TextOverflow
                                    .ellipsis, 
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${formatDate(trip.dStart)} - ${formatDate(trip.dEnd)}',
                                style: TextStyle(
                                  color: PaletteTheme.textgrey,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    calculateNights(trip.dStart, trip.dEnd),
                                    style: TextStyle(
                                      color: PaletteTheme.textgrey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Text(' || '),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    trip.status ? 'Done' : 'Plan',
                                    style: TextStyle(
                                      color: trip.status
                                          ? Colors.green
                                          : Colors.amber,
                                    ),
                                  ),
                                ],
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
                            "${pb.baseURL}/api/files/pbc_3384545563/${trip.placeId}/${trip.placeImg}",
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
      },
    );
  }
}
