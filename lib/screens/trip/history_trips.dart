

import 'package:flutter/material.dart';
import 'package:travel_plan/screens/trip/trip_list.dart';
import 'package:travel_plan/theme/res/palette_theme.dart';

class HistoryTrips extends StatelessWidget {
  const HistoryTrips({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Center(
            child: Text(
          'Where you did done?',
          style: TextStyle(
            color: Color(0xFF201A09),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        )),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              Text(
                'Done 😊',
                style: TextStyle(
                  color: PaletteTheme.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TripList(status: true,),
            ],
          ),
        ),
      ),
    );
  }
}
