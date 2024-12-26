import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:travel_plan/models/place.dart';
import 'package:travel_plan/models/review.dart';
import 'package:travel_plan/models/tripItems.dart';
import 'package:travel_plan/models/user.dart';
import 'package:travel_plan/services/btmbar/sharepreference_service.dart';
import 'package:http/http.dart' as http;

final pb = PocketBase(dotenv.env['POCKETBASE_URL']!);

class ApiService {
  final Dio dio = Dio();
  final String baseUrl = '${pb.baseURL}/api';
  final SharedpreferenceService sharedPreferencesService =
      SharedpreferenceService();

// GET USER ID WHO LOGIGED
  Future<String?> _getUserId() async {
    try {
      return await sharedPreferencesService.getUserId();
    } catch (e) {
      log('Error fetching user ID: $e');
      return null;
    }
  }

  // Fetch all places
  Future<List<Place>> fetchPlaces() async {
    try {
      final response = await dio.get(
        '$baseUrl/collections/places/records',
        queryParameters: {'sort': '-created'}, // Add sort parameter
      );
      final List items = response.data['items'];
      return items.map((item) => Place.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Error fetching places: $e');
    }
  }

  Future<List<Review>> fetchReviews(placeId) async {
    try {
      final response = await pb.collection('user_reviews').getFullList(
          filter: 'place_id="$placeId"', expand: 'user_id', sort: '-created');

      final List<dynamic> items = response.map((e) => e.toJson()).toList();

      log('review : ${items.toString()}');

      return items.map((item) => Review.fromJson(item)).toList();
    } catch (e) {
      log('Error fetching review: $e');
      throw Exception('Error fetching reviews');
    }
  }

// UPDATE THE PLACE
  Future<Place> updatePlace(
    String placeId,  
    Map<String, dynamic> updatedData,
    File? image,
  ) async {
    try {
      final response = await dio.patch(
        '$baseUrl/collections/places/records/$placeId',
        data: updatedData,
      );
      if (image != null) {
        await pb.collection('places').update(
          placeId,
          files: [
            await http.MultipartFile.fromPath(
              'img',
              image.path,
              filename: p.basename(image.path),
            ),
          ],
        );
      }

      return Place.fromJson(response.data);
    } catch (e) {
      throw Exception('Error updating place: $e');
    }
  }

// Make add new place
  Future<Place> addplace(
    Map<String, dynamic> adddData,
    File? image,
  ) async {
    try {
      if (image != null) {
        final response = await pb.collection('places').create(
          body: adddData,
          files: [
            await http.MultipartFile.fromPath(
              'img',
              image.path,
              filename: p.basename(image.path),
            ),
          ],
        );
        return Place.fromJson(response.data);
      } else {
        final response = await pb.collection('places').create(
              body: adddData,
            );
        return Place.fromJson(response.data);
      }
    } catch (e) {
      throw Exception('Error Add place: $e');
    }
  }

  // Fetch place details
  Future<Place> getPlaceDetails(String placeId) async {
    try {
      final response = await dio.get(
        '$baseUrl/collections/places/records/$placeId',
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic>) {
          return Place.fromJson(data);
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception(
            'Failed to load place details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching place details: $e');
      rethrow;
    }
  }

  // Fetch places with filtering or like
  Future<List<Place>> searchPlaces(String query) async {
    try {
      final response = await dio.get(
        '$baseUrl/collections/places/records',
        queryParameters: {
          'filter':
              "title?~'$query' || province?~'$query' || district?~'$query'"
        },
      );
      final List items = response.data['items'];

      return items.map((item) => Place.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Error searching places: $e');
    }
  }

// Fecth the place make favorite
  Future<List<Place>> fetchFavoritePlaces() async {
    try {
      final userId = await _getUserId();

      if (userId == null) {
        log('No user ID found. Returning empty favorites.');
        return [];
      }

      final likesResponse = await pb.collection('likes').getFullList(
            filter: 'user_id="$userId"',
            sort: '-created',
          );
      final placeIds =
          likesResponse.map((like) => like.data['place_id']).toList();

      if (placeIds.isEmpty) {
        return [];
      }

      final filterCondition = placeIds.map((id) => 'id="$id"').join(' || ');

      final placesResponse = await pb.collection('places').getFullList(
            filter: filterCondition,
          );

      return placesResponse.map((place) => Place.fromJson(place.data)).toList();
    } catch (e) {
      log('Error fetching favorite places: $e');
      return [];
    }
  }

// Fetch trip Or make plans
  Future<List<TripItem>> fetchTrips(bool status) async {
    try {
      final userId = await _getUserId();

      if (userId == null) {
        log('No user ID found. Returning empty trips.');
        return [];
      }

      // Fetch data from the place_plans table and expand the place_id relation
      final response = await pb.collection('place_plans').getFullList(
          filter: 'user_id="$userId" && status=${status}',
          expand: 'place_id',
          sort: '-created');

      return response.isEmpty
          ? []
          : response.map((trip) {
              final placeData = trip.expand['place_id'];
              List<dynamic> data = jsonDecode(placeData.toString());

              return TripItem(
                dEnd: trip.data['d_end'] ?? '',
                dStart: trip.data['d_start'] ?? '',
                id: trip.data['id'],
                placeId: trip.data['place_id'],
                updated: trip.data['updated'] ?? '',
                userId: trip.data['user_id'],
                status: trip.data['status'] ?? false,
                placeTitle: data[0]?['title'],
                placeImg: data[0]?['img'],
              );
            }).toList();
    } catch (e) {
      log('Error fetching trips: $e');
      return [];
    }
  }

// Make fetch user Data by id
  Future<UserModel> fetchUserById() async {
    final userId = await _getUserId();
    try {
      final record = await pb.collection('user').getOne(userId!);
      return UserModel.fromJson(record.toJson());
    } catch (e) {
      throw Exception('Failed to fetch user: $e');
    }
  }

  Future<void> updateUserProfile({
    required String name,
    required String bio,
    File? profileImage,
  }) async {
    final userId = await _getUserId();
    try {
      final update_profile = <String, dynamic>{
        "name": name,
        "bio": bio,
      };

      if (profileImage != null) {
        await pb.collection('user').update(
          userId!,
          files: [
            await http.MultipartFile.fromPath(
              'avatar',
              profileImage.path,
              filename: p.basename(profileImage.path),
            ),
          ],
        );
      }

      await pb.collection('user').update(userId!, body: update_profile);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }
}
