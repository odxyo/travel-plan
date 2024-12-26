import 'package:flutter/material.dart';
import 'package:travel_plan/screens/trip/history_trips.dart';
import 'package:travel_plan/screens/trip/trip_list.dart';
import 'package:travel_plan/theme/res/palette_theme.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
            child: Text(
          'Trips',
          style: TextStyle(
            color: Color(0xFF201A09),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        )),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HistoryTrips()),
                  );
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'History trips',
                            style: TextStyle(
                                color: PaletteTheme.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Where did done?',
                            style: TextStyle(
                              color: PaletteTheme.textgrey,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        size: 30,
                        color: PaletteTheme.yellow,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                'Upcoming plans',
                style: TextStyle(
                  color: PaletteTheme.textDesc,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TripList(
                status: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
