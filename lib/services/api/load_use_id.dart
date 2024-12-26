import 'package:flutter/material.dart';
import 'package:travel_plan/services/btmbar/sharepreference_service.dart';

class LoadUserIdComponent extends StatefulWidget {
  final Function(String?) onUserIdLoaded;

  const LoadUserIdComponent({
    Key? key,
    required this.onUserIdLoaded,
  }) : super(key: key);

  @override
  _LoadUserIdComponentState createState() => _LoadUserIdComponentState();
}

class _LoadUserIdComponentState extends State<LoadUserIdComponent> {
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedpreferenceService sharedPreferencesService = SharedpreferenceService();
    String? storedUserId = await sharedPreferencesService.getUserId();
    setState(() {
      userId = storedUserId;
    });
    widget.onUserIdLoaded(userId);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}
