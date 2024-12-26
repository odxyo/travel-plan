import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:travel_plan/services/btmbar/nav_service.dart';
import 'package:travel_plan/services/btmbar/sharepreference_service.dart';
import 'package:travel_plan/widgets/custom_bottom_bar.dart';
import 'package:travel_plan/theme/res/palette_theme.dart';

final pb = PocketBase(dotenv.env['POCKETBASE_URL']!);

class TripEdit extends StatefulWidget {
  final String placeId;
  final String tripId;
  final String start_date;
  final String end_date;

  TripEdit({
    Key? key,
    required this.placeId,
    required this.tripId,
    required this.start_date,
    required this.end_date,
  }) : super(key: key);

  @override
  _TripEditState createState() => _TripEditState();
}

class _TripEditState extends State<TripEdit> {
  DateTime? startDate;
  DateTime? endDate;
  DateTime focusedDate = DateTime.now();
  List<DateTime> selectedDates = [];
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    startDate = DateTime.tryParse(widget.start_date);
    endDate = DateTime.tryParse(widget.end_date);
    if (startDate != null && endDate != null) {
      selectedDates = List<DateTime>.generate(
        endDate!.difference(startDate!).inDays + 1,
        (i) => startDate!.add(Duration(days: i)),
      );
    }
  }

  Future<void> _loadUserId() async {
    SharedpreferenceService sharedPreferencesService =
        SharedpreferenceService();
    String? storedUserId = await sharedPreferencesService.getUserId();
    setState(() {
      userId = storedUserId;
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      focusedDate = focusedDay;
      if (startDate == null || (startDate != null && endDate != null)) {
        startDate = selectedDay;
        endDate = null;
        selectedDates = [startDate!];
      } else if (startDate != null && endDate == null) {
        if (selectedDay.isBefore(startDate!)) {
          startDate = selectedDay;
        } else {
          endDate = selectedDay;
          selectedDates = List<DateTime>.generate(
            endDate!.difference(startDate!).inDays + 1,
            (i) => startDate!.add(Duration(days: i)),
          );
        }
      }
    });
  }

  Future<void> _saveDates(NavigationProvider navigationProvider) async {
    try {
      final saveDate = <String, dynamic>{
        "user_id": userId,
        "d_start": "$startDate",
        "d_end": "$endDate",
        "place_id": "${widget.placeId}"
      };
      await pb
          .collection('place_plans')
          .update(widget.tripId, body: saveDate);

      navigationProvider.setIndex(3);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CustomBottomNavBar(),
          ));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Dates updated successfully!")),
      );
    } catch (e) {
      log('Update date failed: $e');
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "Not Selected";
    return DateFormat.yMMMd().format(date);
  }

  @override
  Widget build(BuildContext context) {
    var navigationProvider = context.read<NavigationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Trip Dates",
          style: TextStyle(
            color: Color(0xFF111518),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime(2000),
              lastDay: DateTime(2100),
              focusedDay: focusedDate,
              selectedDayPredicate: (day) {
                if (startDate != null && endDate != null) {
                  return day.isAfter(startDate!.subtract(Duration(days: 1))) &&
                      day.isBefore(endDate!.add(Duration(days: 1)));
                }
                return startDate != null && day.isAtSameMomentAs(startDate!);
              },
              onDaySelected: _onDaySelected,
              calendarFormat: CalendarFormat.month,
              headerStyle: HeaderStyle(formatButtonVisible: false),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text("Start Date: ${_formatDate(startDate)}"),
              subtitle: Text("End Date: ${_formatDate(endDate)}"),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _saveDates(navigationProvider),
              child: Text(
                "Save plan",
                style: TextStyle(color: PaletteTheme.textDesc),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: PaletteTheme.yellow,
                minimumSize: Size(100, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
