import 'package:flutter/material.dart';
import 'package:travel_plan/theme/res/palette_theme.dart';

class SearchComponent extends StatefulWidget {
  final Function(String) onSearch;

  SearchComponent({required this.onSearch});

  @override
  _SearchComponentState createState() => _SearchComponentState();
}

class _SearchComponentState extends State<SearchComponent> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _controller,
        onChanged: (value) {
          widget.onSearch(value);
        },
        decoration: InputDecoration(
          hintText: 'Where to?',
          hintStyle: TextStyle(color: PaletteTheme.textDesc),
          prefixIcon: Icon(Icons.search, color: PaletteTheme.title),
          filled: true,
          fillColor: Color(0xFFF0F3F4),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
