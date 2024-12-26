import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:travel_plan/models/review.dart';
import 'package:travel_plan/services/api/api_service.dart';
import 'package:travel_plan/theme/res/palette_theme.dart';
import 'package:travel_plan/widgets/no_user_avialable.dart';

// Initialize PocketBase
final pb = PocketBase('${dotenv.env['POCKETBASE_URL']}');

class ReviewCard extends StatelessWidget {
  final String placeId;

  const ReviewCard({
    Key? key,
    required this.placeId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();

    String formatDate(String dateTime) {
      DateTime date = DateTime.parse(dateTime);
      return DateFormat('MMM-dd-yyyy h:mm a').format(date);
    }

    return FutureBuilder<List<Review>>(
      future: apiService.fetchReviews(placeId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: NoReviewsAvailable());
        }

        final reviews = snapshot.data!;

        return Container(
          child: Column(
            children: reviews.map((review) {
              return Card(
                elevation: 0,
                margin: const EdgeInsets.symmetric(vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              '${pb.baseURL}/api/files/pbc_2862526969/${review.user.id}/${review.user.avatar}',
                            ),
                            // backgroundImage: AssetImage(
                            //   'assets/images/user_profile.webp',
                            // ),
                            radius: 25,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review.user.name == null
                                    ? review.user.email
                                    : review.user.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                formatDate(review.created),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: PaletteTheme.textgrey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            Icons.star,
                            color: index < review.star
                                ? const Color(0xFFFAC638)
                                : Colors.grey,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        review.detail,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
