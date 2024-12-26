// import 'package:flutter/material.dart';
// import 'package:travel_plan/models/review.dart';
// import 'package:travel_plan/widgets/user_review.dart';

// Future<List<Review>> fetchReviews() async {
//   // Simulated fetch from database
//   await Future.delayed(Duration(seconds: 2)); // Simulate network delay
//   final response = {
//     'items': [
//       {
//         'id': '1',
//         'detail': 'Great place to visit!',
//         'place_id': 'abc123',
//         'star': 5,
//         'user_id': 'user1',
//         'created': '2024-12-23',
//         'updated': '2024-12-23',
//       },
//       {
//         'id': '2',
//         'detail': 'Average experience, could be better.',
//         'place_id': 'def456',
//         'star': 3,
//         'user_id': 'user2',
//         'created': '2024-12-22',
//         'updated': '2024-12-22',
//       },
//     ],
//   };

//   final data = response['items'] as List;
//   return data.map((json) => Review.fromJson(json)).toList();
// }

// class ReviewListScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(8),
//       child: FutureBuilder<List<Review>>(
//         future: fetchReviews(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No reviews available.'));
//           }

//           final reviews = snapshot.data!;
//           return ListView.builder(
//             padding: EdgeInsets.all(16),
//             itemCount: reviews.length,
//             itemBuilder: (context, index) {
//               return ReviewCard(
//                 review: reviews[index],
//                 userName:
//                     'User ${reviews[index].userId}',
//                 userImageUrl: '',
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
