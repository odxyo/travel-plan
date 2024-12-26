import 'package:shared_preferences/shared_preferences.dart';

class SharedpreferenceService {

  Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance(); 
    await prefs.setString('user_id', userId);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance(); 
    return prefs.getString('user_id'); 
  }
}
