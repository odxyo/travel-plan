import 'package:flutter/material.dart';
import 'package:travel_plan/theme/res/palette_theme.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.text,
    required this.path,
  });

  final String text;
  final String path;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/$path');
            },
            child: Text(
              '$text',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: PaletteTheme.blue,
              minimumSize: Size(100, 40),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
    );
  }
}
