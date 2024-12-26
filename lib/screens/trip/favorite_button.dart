// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:pocketbase/pocketbase.dart';

// final pb = PocketBase('${dotenv.env['POCKETBASE_URL']}');

// class FavoriteButton extends StatefulWidget {
//   final String placeId;
//   final String? userId;

//   const FavoriteButton({
//     Key? key,
//     required this.placeId,
//     required this.userId,
//   }) : super(key: key);

//   @override
//   _FavoriteButtonState createState() => _FavoriteButtonState();
// }

// class _FavoriteButtonState extends State<FavoriteButton> {
//   bool isFavorite = false;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.userId != null) {
//       checkIfFavorite();
//     }
//   }

//   Future<void> checkIfFavorite() async {
//     try {
//       final response = await pb.collection('likes').getList(
//             filter:
//                 "user_id='${widget.userId}' && place_id='${widget.placeId}'",
//           );
//       setState(() {
//         isFavorite = response.items.isNotEmpty;
//       });
//     } catch (e) {
//       print('Error checking favorite status: $e');
//     }
//   }

//   Future<void> toggleFavorite() async {
//     if (widget.userId == null) {
//       print('User is not logged in.');
//       return;
//     }

//     try {
//       if (isFavorite) {
//         final response = await pb.collection('likes').getList(
//               filter:
//                   "user_id='${widget.userId}' && place_id='${widget.placeId}'",
//             );
//         if (response.items.isNotEmpty) {
//           await pb.collection('likes').delete(response.items.first.id);
//         }
//       } else {
//         final favorite = <String, dynamic>{
//           "place_id": widget.placeId,
//           "user_id": widget.userId,
//         };
//         await pb.collection('likes').create(body: favorite);
//       }

//       setState(() {
//         isFavorite = !isFavorite;
//       });
//     } catch (e) {
//       print('Error toggling favorite status: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: toggleFavorite,
//       child: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.8),
//           shape: BoxShape.circle,
//         ),
//         child: Icon(
//           isFavorite ? Icons.favorite : Icons.favorite_border,
//           color: isFavorite ? Colors.red : Colors.grey,
//           size: 30,
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_plan/provider/favorite_provider.dart';

class FavoriteButton extends StatelessWidget {
  final String placeId;

  const FavoriteButton({
    Key? key,
    required this.placeId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final isFavorite = favoriteProvider.isFavorite(placeId);
    return GestureDetector(
      onTap: () => favoriteProvider.toggleFavorite(placeId),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red : Colors.grey,
          size: 30,
        ),
      ),
    );
  }
}
