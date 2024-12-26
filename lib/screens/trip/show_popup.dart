import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:travel_plan/models/tripItems.dart';
import 'package:travel_plan/screens/trip/trip_edit.dart';
import 'package:travel_plan/theme/res/palette_theme.dart';

final pb = PocketBase('${dotenv.env['POCKETBASE_URL']}');

void showPopup(BuildContext context, TripItem trip, VoidCallback onRefresh) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Center(
          child: Text(
            "${trip.placeTitle}",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: PaletteTheme.black),
          ),
        ),
        content: StatefulBuilder(
          builder: (context, setState) {
            bool isDone = trip.status;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TripEdit(
                          placeId: trip.placeId,
                          tripId: trip.id,
                          start_date: trip.dStart,
                          end_date: trip.dEnd,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PaletteTheme.blue,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit, color: Colors.white),
                      const SizedBox(width: 10),
                      Text(
                        'Edit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      final statuss = <String, dynamic>{"status": !isDone};
                      await pb
                          .collection('place_plans')
                          .update(trip.id, body: statuss);

                      setState(() {
                        isDone = !isDone;
                      });

                      onRefresh();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isDone
                              ? 'Trip plan marked as done!'
                              : 'Trip plan marked as not done!'),
                        ),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error updating trip: $e')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PaletteTheme.green,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check, color: Colors.white),
                      const SizedBox(width: 10),
                      Text(
                        isDone ? 'Undo' : 'Done',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);

                    try {
                      await pb.collection('place_plans').delete(trip.id);

                      onRefresh();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Trip plan deleted successfully!'),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error deleting trip: $e')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PaletteTheme.grey200,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_outline, color: Colors.red),
                      const SizedBox(width: 10),
                      Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
