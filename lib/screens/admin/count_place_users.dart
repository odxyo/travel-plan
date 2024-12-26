import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pocketbase/pocketbase.dart';

class CountService {
  final Dio dio = Dio();
  final PocketBase pb = PocketBase(dotenv.env['POCKETBASE_URL']!);


  Future<int> countPlaces() async {
    try {
      final response =
          await dio.get('${pb.baseURL}/api/collections/places/records');
      final List placeItems = response.data['items'] ?? [];
      log(placeItems.length.toString());
      return placeItems.length;
    } catch (e) {
      log('Error fetching places count: $e');
      return 0; 
    }
  }


  Future<int> countUsers() async {
    try {
      final response =
          await dio.get('${pb.baseURL}/api/collections/user/records');
      final List userItems = response.data['items'] ?? [];
      log(userItems.length.toString());
      return userItems.length;
    } catch (e) {
      log('Error fetching users count: $e');
      return 0; 
    }
  }
}
