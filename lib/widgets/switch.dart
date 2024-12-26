import 'package:flutter/material.dart';

class YesNoSwitch extends StatefulWidget {
  final bool initialValue;

  YesNoSwitch({required this.initialValue});

  @override
  _YesNoSwitchState createState() => _YesNoSwitchState();
}

class _YesNoSwitchState extends State<YesNoSwitch> {
  late bool _isRecommended;

  @override
  void initState() {
    super.initState();
    _isRecommended = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Make recommend',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        SizedBox(width: 16),
        Switch(
          value: _isRecommended,
          onChanged: (bool newValue) {
            setState(() {
              _isRecommended = newValue;
            });
          },
          activeColor: Colors.blue,
          inactiveThumbColor: Colors.grey,
          inactiveTrackColor: Colors.grey.shade300,
        ),
        Text( 
          _isRecommended ? 'Yes' : 'No',
          style: TextStyle(
            fontSize: 16,
            color: _isRecommended ? Colors.blue : Colors.black,
          ),
        ),
      ],
    );
  }
}
