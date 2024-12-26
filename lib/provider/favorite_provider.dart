import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:travel_plan/services/btmbar/sharepreference_service.dart';

class FavoriteProvider with ChangeNotifier {
  final PocketBase pb;

  FavoriteProvider({required this.pb}) {
    _loadUserId();
  }

  final Set<String> _favoritePlaceIds = {};
  String? _userId;

  Set<String> get favoritePlaceIds => _favoritePlaceIds;

  String? get userId => _userId;

  Future<void> _loadUserId() async {
    try {
      SharedpreferenceService sharedPreferencesService =
          SharedpreferenceService();
      _userId = await sharedPreferencesService.getUserId();
      if (_userId != null) {
        await fetchFavorites();
      }
      log('like Provider show');
    } catch (e) {
      print('Error loading user ID: $e');
    }
  }

  Future<void> fetchFavorites() async {
    if (_userId == null) return;

    try {
      final response = await pb.collection('likes').getList(
            filter: "user_id='$_userId'",
          );
      _favoritePlaceIds
        ..clear()
        ..addAll(response.items.map((item) => item.data['place_id']));
      notifyListeners();
    } catch (e) {
      print('Error fetching favorites: $e');
    }
  }

  Future<void> toggleFavorite(String placeId) async {
    if (_userId == null) return;
    log(userId.toString());

    try {
      if (_favoritePlaceIds.contains(placeId)) {
        final response = await pb.collection('likes').getList(
              filter: "user_id='$_userId' && place_id='$placeId'",
            );
        if (response.items.isNotEmpty) {
          await pb.collection('likes').delete(response.items.first.id);
          _favoritePlaceIds.remove(placeId);
        }
      } else {
        await pb.collection('likes').create(
          body: {"place_id": placeId, "user_id": _userId},
        );
        _favoritePlaceIds.add(placeId);
      }
      notifyListeners();
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }

  bool isFavorite(String placeId) => _favoritePlaceIds.contains(placeId);
}
