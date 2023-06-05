import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart';

String baseUrl = 'https://api.mapbox.com/directions/v5/mapbox';
String accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? "";
String navType = 'driving';

class DirectionsService {
  late final Client client;

  DirectionsService(this.client);

  /// Fetches the Driving route from Mapbox Directions API
  Future<dynamic> getDrivingRoute(LatLng source, LatLng destination) async {
    String url =
        '$baseUrl/$navType/${source.longitude},${source.latitude};${destination.longitude},${destination.latitude}?alternatives=true&continue_straight=true&geometries=geojson&language=en&overview=full&steps=true&access_token=$accessToken';
    try {
      final responseData = await client.get(Uri.parse(url));
      if (responseData.statusCode == 200) {
        return jsonDecode(responseData.body);
      } else {
        throw Exception("Some error occured");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  /// Gets the Driving route
  /// Returns a Map with the required information - the points, distance and duration
  Future<Map> getDirectionsAPIResponse(
      LatLng sourceLatLng, LatLng destinationLatLng) async {
    try {
      final response = await getDrivingRoute(sourceLatLng, destinationLatLng);
      List<LatLng> points =
          (response['routes'][0]['geometry']['coordinates'] as List)
              .map((point) => LatLng(point[1], point[0]))
              .toList();
      num duration = response['routes'][0]['duration'];
      num distance = response['routes'][0]['distance'];
      Map routeResponse = {
        "points": points,
        "duration": duration,
        "distance": distance,
      };
      return routeResponse;
    } catch (e) {
      rethrow;
    }
  }
}

final directionServiceProvider = Provider<DirectionsService>((ref) {
  final client = Client();
  return DirectionsService(client);
});
