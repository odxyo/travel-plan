import 'package:flutter/material.dart';
import 'dart:developer';

class RatingPopup extends StatelessWidget {
  final String placeId;
  final Future<String?> Function() getUserId;
  final Future<void> Function(Map<String, dynamic> body) submitReview;

  RatingPopup({
    required this.placeId,
    required this.getUserId,
    required this.submitReview,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController _userReview = TextEditingController();
    final TextEditingController _star = TextEditingController();

    void _submit() async {
      final userId = await getUserId();
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching user ID!')),
        );
        return;
      }

      if (_star.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Review cannot be empty!')),
        );
        return;
      }
      if (_userReview.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Review cannot be empty!')),
        );
        return;
      }

      try {
        final body = {
          "user_id": userId,
          "star": _star.text,
          "detail": _userReview.text,
          "place_id": placeId,
        };
        await submitReview(body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Review submitted successfully!')),
        );
        Navigator.of(context).pop();
      } catch (e) {
        log('Error submitting review: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting review: $e')),
        );
      }
    }

    return AlertDialog(
      title: Text(
        'Submit Your Review',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add your comments below:',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _star,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: 'Give star 1 - 5',
              border: OutlineInputBorder(),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
              ),
            ),
          ),
          TextField(
            controller: _userReview,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: '.  .  .  .',
              border: OutlineInputBorder(),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(
            'Submit',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow,
          ),
        ),
      ],
    );
  }
}
