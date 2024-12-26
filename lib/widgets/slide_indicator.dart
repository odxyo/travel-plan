import 'package:flutter/material.dart';

class SlideIndicator extends StatelessWidget {
  final int currentIndex;
  final int total;

  const SlideIndicator({required this.currentIndex, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        total,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentIndex == index ? Colors.blue : Colors.grey[300],
          ),
        ),
      ),
    );
  }
}
