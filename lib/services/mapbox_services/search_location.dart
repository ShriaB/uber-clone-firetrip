import 'dart:convert';

import 'package:firetrip/models/location_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';

String baseUrl = 'https://api.mapbox.com/geocoding/v5/mapbox.places';
String accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? "";
String searchType = 'place%2Cpostcode%2Caddress';
String searchResultsLimit = '5';
String country = 'in';

/// Fetches the location sugesstions from Mapbox places API
Future<dynamic> getSearchResultsFromQueryService(
    String query, LatLng point) async {
  String proximity = '${point.longitude}%2C${point.latitude}';
  String url =
      '$baseUrl/$query.json?country=$country&limit=$searchResultsLimit&proximity=$proximity&types=$searchType&access_token=$accessToken';
  try {
    final responseData = await get(Uri.parse(url));
    return jsonDecode(responseData.body);
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

/// Converts the JSON data received from [getSearchResultsFromQueryService]
/// to a list of LocationModels and returns it
Future<List<LocationModel>?> getSearchResultsFromQuery(
    String query, LocationModel? location) async {
  try {
    if (location?.locationLatitude != null &&
        location?.locationLongitude != null) {
      LatLng point = LatLng(
          location?.locationLatitude ?? 22, location?.locationLongitude ?? 89);
      dynamic response = await getSearchResultsFromQueryService(query, point);
      List<dynamic> searchedLocations = response['features'];
      List<LocationModel> searchedList = searchedLocations.map((loc) {
        return LocationModel.fromJson(loc);
      }).toList();
      return searchedList;
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
  return null;
}
