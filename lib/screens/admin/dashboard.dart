import 'package:flutter/material.dart';
import 'package:travel_plan/screens/admin/add_place.dart';
import 'package:travel_plan/screens/admin/count_place_users.dart';
import 'package:travel_plan/screens/admin/dashboard_box.dart';
import 'package:travel_plan/screens/admin/view_all_place.dart';

class DashboardPage extends StatelessWidget {
  final countService = CountService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, int>>(
        future: fetchCounts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final counts = snapshot.data!;
            final placeCount = counts['places'] ?? 0;
            final userCount = counts['users'] ?? 0;

            return Center(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  DashboardBox(
                    title: 'Add Place',
                    icon: Icons.add_location_alt,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddPlace()),
                      );
                    },
                  ),
                  DashboardBox(
                    title: placeCount.toString(),
                    icon: Icons.location_city,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ViewAllPlace()),
                      );
                    },
                  ),
                  DashboardBox(
                    title: userCount.toString(),
                    icon: Icons.people,
                    onTap: () {},
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
 
  /// Fetches counts for places and users
  Future<Map<String, int>> fetchCounts() async {
    final placeCount = await countService.countPlaces();
    final userCount = await countService.countUsers();
    return {'places': placeCount, 'users': userCount};
  }
}
